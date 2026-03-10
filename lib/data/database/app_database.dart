/// Database utama aplikasi NiagaRea menggunakan Drift.
///
/// Menghubungkan semua tabel dan DAOs ke dalam
/// satu instance database SQLite.
library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'tables/antrian_digiflazz_table.dart';
import 'tables/detail_konsumsi_siklus_table.dart';
import 'tables/pelanggan_table.dart';
import 'tables/produk_table.dart';
import 'tables/siklus_table.dart';
import 'tables/transaksi_table.dart';
import 'tables/kotak_uang_table.dart';

// DAOs
import '../daos/siklus_dao.dart';
import '../daos/produk_dao.dart';
import '../daos/pelanggan_dao.dart';
import '../daos/transaksi_dao.dart';
import '../daos/detail_konsumsi_dao.dart';
import '../daos/antrian_dao.dart';
import '../daos/kotak_uang_dao.dart';

part 'app_database.g.dart';

/// Database utama NiagaRea.
///
/// Instance tunggal (singleton) yang menyimpan semua data
/// transaksi, siklus, produk, dan pelanggan secara lokal.
@DriftDatabase(
  tables: [
    SiklusTable,
    ProdukTable,
    PelangganTable,
    TransaksiTable,
    DetailKonsumsiSiklusTable,
    AntrianDigiflazzTable,
    KotakUangTable,
  ],
  daos: [
    SiklusDao,
    ProdukDao,
    PelangganDao,
    TransaksiDao,
    DetailKonsumsiDao,
    AntrianDao,
    KotakUangDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: AppConstants.databaseName));

  /// Constructor untuk testing — terima executor dari luar
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => AppConstants.databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        // Seed: tambahkan pelanggan default "Umum"
        await into(pelangganTable).insert(
          PelangganTableCompanion.insert(
            nama: 'Umum',
            noHp: const Value(''),
            catatan: const Value('Pelanggan umum tanpa nama'),
          ),
        );

        // Seed: tambahkan kotak uang default "Laci Tunai"
        await into(kotakUangTable).insert(
          KotakUangTableCompanion.insert(
            nama: 'Laci Tunai',
            saldo: const Value(0),
          ),
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Tambahkan kolom saldo_piutang ke tabel pelanggan
          await m.addColumn(pelangganTable, pelangganTable.saldoPiutang);
        }
      },
    );
  }
}
