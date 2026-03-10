import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../database/tables/kotak_uang_table.dart';

part 'kotak_uang_dao.g.dart';

@DriftAccessor(tables: [KotakUangTable])
class KotakUangDao extends DatabaseAccessor<AppDatabase>
    with _$KotakUangDaoMixin {
  KotakUangDao(super.db);

  /// Ambil semua kotak uang
  Stream<List<KotakUang>> watchAllKotakUang() {
    return select(kotakUangTable).watch();
  }

  /// Ambil kotak uang berdasarkan ID
  Future<KotakUang?> getKotakUangById(int id) {
    return (select(
      kotakUangTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Tambah kotak uang baru
  Future<int> addKotakUang(KotakUangTableCompanion entry) {
    return into(kotakUangTable).insert(entry);
  }

  /// Update data kotak uang
  Future<bool> updateKotakUang(KotakUang entry) {
    return update(kotakUangTable).replace(entry);
  }

  /// Update saldo kotak uang (tambah/kurang)
  Future<void> updateSaldo(int id, int amount) async {
    final current = await getKotakUangById(id);
    if (current == null) return;

    await (update(kotakUangTable)..where((t) => t.id.equals(id))).write(
      KotakUangTableCompanion(saldo: Value(current.saldo + amount)),
    );
  }

  /// Hapus kotak uang (hanya jika saldo 0 atau ada proteksi lain)
  Future<void> hapusKotakUang(int id) {
    return (delete(kotakUangTable)..where((t) => t.id.equals(id))).go();
  }

  /// Reset saldo (untuk koreksi)
  Future<void> setSaldo(int id, int newBalance) {
    return (update(kotakUangTable)..where((t) => t.id.equals(id))).write(
      KotakUangTableCompanion(saldo: Value(newBalance)),
    );
  }
}
