import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:niagarea/data/database/app_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:sqlite3/open.dart';
import 'dart:ffi';
import 'dart:io';

void main() {
  open.overrideFor(OperatingSystem.linux, () {
    return DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0');
  });

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('KotakUangDao Tests', () {
    test('Tambah dan ambil Kotak Uang', () async {
      await db.kotakUangDao.addKotakUang(
        KotakUangTableCompanion.insert(
          nama: 'Tabungan',
          saldo: const drift.Value(1000),
        ),
      );

      final list = await db.kotakUangDao.watchAllKotakUang().first;
      // Index 0 adalah Laci Tunai (dari seed), Index 1 adalah Tabungan
      expect(list.length, 2);
      expect(list.any((k) => k.nama == 'Tabungan'), isTrue);
    });

    test('Update saldo (tambah & kurang)', () async {
      final id = await db.kotakUangDao.addKotakUang(
        KotakUangTableCompanion.insert(
          nama: 'Bank',
          saldo: const drift.Value(5000),
        ),
      );

      // Tambah 2000
      await db.kotakUangDao.updateSaldo(id, 2000);
      var updated = await db.kotakUangDao.getKotakUangById(id);
      expect(updated?.saldo, 7000);

      // Kurang 3000
      await db.kotakUangDao.updateSaldo(id, -3000);
      updated = await db.kotakUangDao.getKotakUangById(id);
      expect(updated?.saldo, 4000);
    });

    test('Hapus Kotak Uang', () async {
      final id = await db.kotakUangDao.addKotakUang(
        KotakUangTableCompanion.insert(
          nama: 'Hapus Me',
          saldo: const drift.Value(0),
        ),
      );

      await db.kotakUangDao.hapusKotakUang(id);
      final deleted = await db.kotakUangDao.getKotakUangById(id);
      expect(deleted, isNull);
    });
  });
}
