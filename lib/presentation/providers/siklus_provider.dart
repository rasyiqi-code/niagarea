/// Provider siklus — state management untuk siklus deposit.
///
/// Menyediakan stream reaktif siklus aktif dan
/// total saldo internal via Riverpod.
library;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import 'core_providers.dart';

/// Stream provider siklus aktif (real-time updates).
final siklusAktifProvider = StreamProvider<List<Siklus>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.siklusDao.watchSiklusAktif();
});

/// Stream provider total saldo internal (real-time).
final totalSaldoInternalProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.siklusDao.watchTotalSaldoInternal();
});

/// Future provider semua siklus (termasuk selesai).
final semuaSiklusProvider = FutureProvider<List<Siklus>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.siklusDao.ambilSemuaSiklus();
});

/// Notifier untuk operasi CRUD siklus.
class SiklusNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  SiklusNotifier(this._db) : super(const AsyncValue.data(null));

  /// Tambah siklus baru dengan validasi.
  Future<int?> tambahSiklus({
    required String namaSiklus,
    required int modalSetor,
    int biayaAdmin = 0,
    int biayaTransaksi = 0,
  }) async {
    state = const AsyncValue.loading();
    try {
      final saldoMasuk = modalSetor - biayaAdmin - biayaTransaksi;

      if (saldoMasuk <= 0) {
        throw ArgumentError('Saldo masuk harus lebih dari 0');
      }

      final id = await _db.siklusDao.tambahSiklus(
        SiklusTableCompanion.insert(
          namaSiklus: namaSiklus,
          modalSetor: modalSetor,
          biayaAdmin: Value(biayaAdmin),
          biayaTransaksi: Value(biayaTransaksi),
          saldoMasuk: saldoMasuk,
          saldoSisa: saldoMasuk,
        ),
      );

      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Tutup siklus secara manual.
  Future<void> tutupSiklus(int idSiklus) async {
    state = const AsyncValue.loading();
    try {
      await _db.siklusDao.tandaiSelesai(idSiklus);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider notifier untuk operasi CRUD siklus.
final siklusNotifierProvider =
    StateNotifierProvider<SiklusNotifier, AsyncValue<void>>((ref) {
      final db = ref.watch(databaseProvider);
      return SiklusNotifier(db);
    });
