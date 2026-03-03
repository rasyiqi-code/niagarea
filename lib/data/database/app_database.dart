/// Database utama aplikasi NiagaRea menggunakan Drift.
///
/// Menghubungkan semua tabel dan DAOs ke dalam
/// satu instance database SQLite.
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import 'tables/antrian_digiflazz_table.dart';
import 'tables/detail_konsumsi_siklus_table.dart';
import 'tables/pelanggan_table.dart';
import 'tables/produk_table.dart';
import 'tables/siklus_table.dart';
import 'tables/transaksi_table.dart';

// DAOs
import '../daos/siklus_dao.dart';
import '../daos/produk_dao.dart';
import '../daos/pelanggan_dao.dart';
import '../daos/transaksi_dao.dart';
import '../daos/detail_konsumsi_dao.dart';
import '../daos/antrian_dao.dart';

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
  ],
  daos: [
    SiklusDao,
    ProdukDao,
    PelangganDao,
    TransaksiDao,
    DetailKonsumsiDao,
    AntrianDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

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
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // TODO: Tambahkan migrasi saat schema berubah
      },
    );
  }
}

/// Membuka koneksi ke database SQLite lokal.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
