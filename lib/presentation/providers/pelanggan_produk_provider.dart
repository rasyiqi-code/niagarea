/// Provider pelanggan dan produk — state management.
///
/// Menyediakan stream reaktif dan notifier
/// untuk manajemen pelanggan dan produk.
library;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import 'core_providers.dart';

// ═══════════════════════════════════════════════════════════
// PELANGGAN PROVIDERS
// ═══════════════════════════════════════════════════════════

/// Stream provider semua pelanggan (reactive).
final pelangganProvider = StreamProvider<List<Pelanggan>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.pelangganDao.watchSemuaPelanggan();
});

/// Future provider satu pelanggan berdasarkan ID.
final pelangganByIdProvider = FutureProvider.family<Pelanggan?, int>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.pelangganDao.ambilPelangganById(id);
});

/// Notifier untuk operasi CRUD pelanggan.
class PelangganNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  PelangganNotifier(this._db) : super(const AsyncValue.data(null));

  /// Tambah pelanggan baru.
  Future<int?> tambah({
    required String nama,
    String noHp = '',
    String catatan = '',
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = await _db.pelangganDao.tambahPelanggan(
        PelangganTableCompanion.insert(
          nama: nama,
          noHp: Value(noHp),
          catatan: Value(catatan),
        ),
      );
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Hapus pelanggan.
  Future<void> hapus(int id) async {
    state = const AsyncValue.loading();
    try {
      await _db.pelangganDao.hapusPelanggan(id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider notifier pelanggan.
final pelangganNotifierProvider =
    StateNotifierProvider<PelangganNotifier, AsyncValue<void>>((ref) {
      final db = ref.watch(databaseProvider);
      return PelangganNotifier(db);
    });

// ═══════════════════════════════════════════════════════════
// PRODUK PROVIDERS
// ═══════════════════════════════════════════════════════════

/// Stream provider produk aktif (reactive).
final produkAktifProvider = StreamProvider<List<Produk>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.produkDao.watchProdukAktif();
});

/// Future provider semua produk (termasuk non-aktif).
final semuaProdukProvider = FutureProvider<List<Produk>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.produkDao.ambilSemuaProduk();
});

/// Notifier untuk operasi CRUD produk.
class ProdukNotifier extends StateNotifier<AsyncValue<void>> {
  final AppDatabase _db;

  ProdukNotifier(this._db) : super(const AsyncValue.data(null));

  /// Tambah produk manual.
  Future<int?> tambah({
    required String nama,
    required String kategori,
    required int hargaBeli,
    required int hargaJual,
    String kodeDigiflazz = '',
    String brand = '',
  }) async {
    state = const AsyncValue.loading();
    try {
      final id = await _db.produkDao.tambahProduk(
        ProdukTableCompanion.insert(
          kodeDigiflazz: kodeDigiflazz.isEmpty ? 'manual_$nama' : kodeDigiflazz,
          nama: nama,
          kategori: Value(kategori),
          brand: Value(brand),
          hargaBeli: hargaBeli,
          hargaJual: Value(hargaJual),
          aktif: const Value(true),
        ),
      );
      state = const AsyncValue.data(null);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update harga jual produk.
  Future<void> updateHargaJual(int idProduk, int hargaBaru) async {
    state = const AsyncValue.loading();
    try {
      await _db.produkDao.updateHargaJual(idProduk, hargaBaru);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggle status aktif produk.
  Future<void> toggleAktif(int idProduk, bool aktif) async {
    try {
      await _db.produkDao.toggleAktif(idProduk, aktif);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Hapus produk.
  Future<void> hapus(int idProduk) async {
    state = const AsyncValue.loading();
    try {
      await _db.produkDao.hapusProduk(idProduk);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider notifier produk.
final produkNotifierProvider =
    StateNotifierProvider<ProdukNotifier, AsyncValue<void>>((ref) {
      final db = ref.watch(databaseProvider);
      return ProdukNotifier(db);
    });
