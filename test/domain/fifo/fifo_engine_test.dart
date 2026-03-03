/// Unit test FIFO Engine — logika inti NiagaRea.
///
/// Menguji semua kasus FIFO:
/// 1. Transaksi dari 1 siklus (saldo cukup)
/// 2. Transaksi lintas 2 siklus (siklus pertama habis)
/// 3. Transaksi gagal — saldo tidak cukup
/// 4. Transaksi gagal — tidak ada siklus aktif
/// 5. Rollback transaksi — saldo dikembalikan
/// 6. Siklus otomatis selesai — saldo_sisa = 0
/// 7. Transaksi persis sama dengan sisa saldo 1 siklus
library;

import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:niagarea/data/database/app_database.dart';
import 'package:niagarea/domain/fifo/fifo_engine.dart';

void main() {
  late AppDatabase db;
  late FifoEngine fifo;

  setUp(() {
    // Database in-memory untuk testing
    db = AppDatabase.forTesting(NativeDatabase.memory());
    fifo = FifoEngine(db);
  });

  tearDown(() async {
    await db.close();
  });

  // ── Helper: buat siklus test ─────────────────────────
  Future<int> buatSiklus({
    required String nama,
    required int saldoMasuk,
    DateTime? tanggalMulai,
  }) async {
    return db
        .into(db.siklusTable)
        .insert(
          SiklusTableCompanion.insert(
            namaSiklus: nama,
            modalSetor: saldoMasuk,
            saldoMasuk: saldoMasuk,
            saldoSisa: saldoMasuk,
            tanggalMulai: Value(tanggalMulai ?? DateTime.now()),
          ),
        );
  }

  // ── Helper: buat transaksi dummy ─────────────────────
  Future<int> buatTransaksiDummy() async {
    return db
        .into(db.transaksiTable)
        .insert(
          TransaksiTableCompanion.insert(
            hargaBeli: 11000,
            hargaJual: 12000,
            profit: 1000,
          ),
        );
  }

  // ── Helper: ambil siklus by ID ───────────────────────
  Future<Siklus> ambilSiklus(int id) async {
    return (db.select(
      db.siklusTable,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  group('Konsumsi Saldo FIFO', () {
    test('Transaksi dari 1 siklus — saldo cukup', () async {
      // Arrange: 1 siklus dengan saldo 498.000
      await buatSiklus(nama: 'Siklus 1', saldoMasuk: 498000);
      final idTrx = await buatTransaksiDummy();

      // Act: konsumsi 11.000
      final result = await fifo.konsumsiSaldo(
        jumlah: 11000,
        idTransaksi: idTrx,
      );

      // Assert
      expect(result.totalDikonsumsi, 11000);
      expect(result.jumlahSiklusTerlibat, 1);
      expect(result.detailKonsumsi[0].jumlahDikonsumsi, 11000);
      expect(result.detailKonsumsi[0].saldoSisaSiklus, 487000);
      expect(result.adaSiklusSelesai, false);

      // Verifikasi saldo di database
      final siklus = await ambilSiklus(1);
      expect(siklus.saldoSisa, 487000);
      expect(siklus.status, 'aktif');
    });

    test('Transaksi lintas 2 siklus — siklus pertama habis', () async {
      // Arrange: Siklus 1 sisa 3.000, Siklus 2 saldo 498.000
      final tanggal1 = DateTime(2026, 3, 1);
      final tanggal2 = DateTime(2026, 3, 5);
      await buatSiklus(
        nama: 'Siklus 1',
        saldoMasuk: 3000,
        tanggalMulai: tanggal1,
      );
      await buatSiklus(
        nama: 'Siklus 2',
        saldoMasuk: 498000,
        tanggalMulai: tanggal2,
      );
      final idTrx = await buatTransaksiDummy();

      // Act: konsumsi 11.000 (lebih besar dari siklus 1)
      final result = await fifo.konsumsiSaldo(
        jumlah: 11000,
        idTransaksi: idTrx,
      );

      // Assert: 2 siklus terlibat
      expect(result.totalDikonsumsi, 11000);
      expect(result.jumlahSiklusTerlibat, 2);

      // Siklus 1: habis, diambil 3.000
      expect(result.detailKonsumsi[0].namaSiklus, 'Siklus 1');
      expect(result.detailKonsumsi[0].jumlahDikonsumsi, 3000);
      expect(result.detailKonsumsi[0].saldoSisaSiklus, 0);

      // Siklus 2: diambil 8.000 (11.000 - 3.000)
      expect(result.detailKonsumsi[1].namaSiklus, 'Siklus 2');
      expect(result.detailKonsumsi[1].jumlahDikonsumsi, 8000);
      expect(result.detailKonsumsi[1].saldoSisaSiklus, 490000);

      expect(result.adaSiklusSelesai, true);

      // Verifikasi database
      final s1 = await ambilSiklus(1);
      expect(s1.saldoSisa, 0);
      expect(s1.status, 'selesai');
      expect(s1.tanggalSelesai, isNotNull);

      final s2 = await ambilSiklus(2);
      expect(s2.saldoSisa, 490000);
      expect(s2.status, 'aktif');
    });

    test('Saldo tidak cukup — throw InsufficientBalanceException', () async {
      // Arrange: 1 siklus saldo 5.000
      await buatSiklus(nama: 'Siklus Kecil', saldoMasuk: 5000);
      final idTrx = await buatTransaksiDummy();

      // Act & Assert
      expect(
        () => fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx),
        throwsA(
          isA<InsufficientBalanceException>()
              .having((e) => e.dibutuhkan, 'dibutuhkan', 11000)
              .having((e) => e.tersedia, 'tersedia', 5000),
        ),
      );

      // Verifikasi saldo tetap utuh (atomik)
      final siklus = await ambilSiklus(1);
      expect(siklus.saldoSisa, 5000);
    });

    test('Tidak ada siklus aktif — throw NoActiveCycleException', () async {
      final idTrx = await buatTransaksiDummy();

      // Act & Assert
      expect(
        () => fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx),
        throwsA(isA<NoActiveCycleException>()),
      );
    });

    test('Transaksi persis habiskan saldo 1 siklus', () async {
      // Arrange
      await buatSiklus(nama: 'Siklus Pas', saldoMasuk: 11000);
      final idTrx = await buatTransaksiDummy();

      // Act
      final result = await fifo.konsumsiSaldo(
        jumlah: 11000,
        idTransaksi: idTrx,
      );

      // Assert: siklus selesai
      expect(result.totalDikonsumsi, 11000);
      expect(result.detailKonsumsi[0].saldoSisaSiklus, 0);
      expect(result.adaSiklusSelesai, true);

      final siklus = await ambilSiklus(1);
      expect(siklus.saldoSisa, 0);
      expect(siklus.status, 'selesai');
    });

    test('Multiple transaksi berturut-turut — FIFO konsisten', () async {
      // Arrange: saldo 30.000
      await buatSiklus(nama: 'Siklus A', saldoMasuk: 30000);

      // Transaksi 1: 11.000
      final idTrx1 = await buatTransaksiDummy();
      await fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx1);

      // Transaksi 2: 11.000
      final idTrx2 = await buatTransaksiDummy();
      await fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx2);

      // Verifikasi: sisa 8.000
      final siklus = await ambilSiklus(1);
      expect(siklus.saldoSisa, 8000);
      expect(siklus.status, 'aktif');

      // Transaksi 3: 8.000 (habiskan)
      final idTrx3 = await buatTransaksiDummy();
      await fifo.konsumsiSaldo(jumlah: 8000, idTransaksi: idTrx3);

      final siklusFinal = await ambilSiklus(1);
      expect(siklusFinal.saldoSisa, 0);
      expect(siklusFinal.status, 'selesai');
    });
  });

  group('Rollback FIFO', () {
    test('Rollback transaksi 1 siklus — saldo dikembalikan', () async {
      // Arrange
      await buatSiklus(nama: 'Siklus R', saldoMasuk: 498000);
      final idTrx = await buatTransaksiDummy();
      await fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx);

      // Verifikasi setelah konsumsi
      var siklus = await ambilSiklus(1);
      expect(siklus.saldoSisa, 487000);

      // Act: rollback
      await fifo.rollbackKonsumsi(idTrx);

      // Assert: saldo dikembalikan
      siklus = await ambilSiklus(1);
      expect(siklus.saldoSisa, 498000);
      expect(siklus.status, 'aktif');

      // Detail konsumsi dihapus
      final details = await (db.select(
        db.detailKonsumsiSiklusTable,
      )..where((t) => t.idTransaksi.equals(idTrx))).get();
      expect(details, isEmpty);
    });

    test(
      'Rollback transaksi lintas siklus — semua saldo dikembalikan',
      () async {
        // Arrange: 2 siklus
        await buatSiklus(
          nama: 'S1',
          saldoMasuk: 3000,
          tanggalMulai: DateTime(2026, 3, 1),
        );
        await buatSiklus(
          nama: 'S2',
          saldoMasuk: 498000,
          tanggalMulai: DateTime(2026, 3, 5),
        );
        final idTrx = await buatTransaksiDummy();

        // Konsumsi 11.000 → S1 habis, S2 dikurangi 8.000
        await fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx);

        var s1 = await ambilSiklus(1);
        expect(s1.status, 'selesai');

        // Act: rollback
        await fifo.rollbackKonsumsi(idTrx);

        // Assert: kedua siklus dikembalikan
        s1 = await ambilSiklus(1);
        expect(s1.saldoSisa, 3000);
        expect(s1.status, 'aktif'); // Kembali aktif dari selesai

        final s2 = await ambilSiklus(2);
        expect(s2.saldoSisa, 498000);
        expect(s2.status, 'aktif');
      },
    );
  });

  group('Detail Konsumsi Siklus', () {
    test('Detail konsumsi tercatat dengan benar di database', () async {
      // Arrange
      await buatSiklus(
        nama: 'SK1',
        saldoMasuk: 5000,
        tanggalMulai: DateTime(2026, 3, 1),
      );
      await buatSiklus(
        nama: 'SK2',
        saldoMasuk: 100000,
        tanggalMulai: DateTime(2026, 3, 5),
      );
      final idTrx = await buatTransaksiDummy();

      // Act
      await fifo.konsumsiSaldo(jumlah: 11000, idTransaksi: idTrx);

      // Assert: 2 rows detail konsumsi
      final details =
          await (db.select(db.detailKonsumsiSiklusTable)
                ..where((t) => t.idTransaksi.equals(idTrx))
                ..orderBy([(t) => OrderingTerm.asc(t.idSiklus)]))
              .get();

      expect(details.length, 2);
      expect(details[0].idSiklus, 1);
      expect(details[0].jumlahDikonsumsi, 5000);
      expect(details[1].idSiklus, 2);
      expect(details[1].jumlahDikonsumsi, 6000);
    });
  });
}
