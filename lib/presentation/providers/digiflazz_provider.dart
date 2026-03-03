/// Provider Riverpod untuk integrasi Digiflazz.
///
/// Menyediakan instance service Digiflazz, state saldo,
/// status sync, dan antrian transaksi via Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../services/auth/admin_guard.dart';
import '../../services/digiflazz/digiflazz_client.dart';
import '../../services/digiflazz/digiflazz_config.dart';
import '../../services/digiflazz/sync_service.dart';
import '../../services/digiflazz/transaction_queue_service.dart';
import 'core_providers.dart';

// ── Singleton Providers ─────────────────────────────────

/// Provider singleton untuk konfigurasi Digiflazz.
final digiflazzConfigProvider = Provider<DigiflazzConfig>((ref) {
  return DigiflazzConfig();
});

/// Provider singleton untuk Guard Admin (PIN).
final adminGuardProvider = Provider<AdminGuard>((ref) {
  return AdminGuard();
});

/// Provider singleton untuk HTTP client Digiflazz.
final digiflazzClientProvider = Provider<DigiflazzClient>((ref) {
  final config = ref.watch(digiflazzConfigProvider);
  return DigiflazzClient(config: config);
});

/// Provider singleton untuk service sinkronisasi produk.
final syncServiceProvider = Provider<SyncService>((ref) {
  final client = ref.watch(digiflazzClientProvider);
  final db = ref.watch(databaseProvider);
  final config = ref.watch(digiflazzConfigProvider);
  return SyncService(client: client, produkDao: db.produkDao, config: config);
});

/// Provider singleton untuk service antrian transaksi.
final transactionQueueProvider = Provider<TransactionQueueService>((ref) {
  final client = ref.watch(digiflazzClientProvider);
  final db = ref.watch(databaseProvider);
  final fifo = ref.watch(fifoEngineProvider);
  return TransactionQueueService(
    client: client,
    antrianDao: db.antrianDao,
    fifoEngine: fifo,
  );
});

// ── State Providers ─────────────────────────────────────

/// FutureProvider untuk cek saldo Digiflazz (on-demand).
///
/// Dipanggil manual saat user tekan "Perbarui Saldo".
/// Tidak auto-refresh karena butuh koneksi internet.
final saldoDigiflazzProvider = FutureProvider.autoDispose<int?>((ref) async {
  final client = ref.watch(digiflazzClientProvider);
  final config = ref.watch(digiflazzConfigProvider);

  // Jangan cek jika credential belum ada
  if (!await config.hasCredential()) return null;

  try {
    final response = await client.cekSaldo();
    return response.deposit;
  } on DigiflazzException {
    return null;
  }
});

/// Stream provider antrian transaksi (reactive).
final antrianProvider = StreamProvider<List<AntrianDigiflazz>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.antrianDao.watchAntrian();
});

/// FutureProvider jumlah antrian pending (untuk badge).
final jumlahPendingProvider = FutureProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  return db.antrianDao.hitungPending();
});

/// FutureProvider cek apakah credential sudah dikonfigurasi.
final hasCredentialProvider = FutureProvider<bool>((ref) {
  final config = ref.watch(digiflazzConfigProvider);
  return config.hasCredential();
});

// ── Notifier ────────────────────────────────────────────

/// State untuk notifier Digiflazz.
class DigiflazzState {
  /// Loading state untuk operasi async
  final bool isLoading;

  /// Pesan error terakhir (null jika tidak ada)
  final String? error;

  /// Pesan sukses terakhir (null jika tidak ada)
  final String? sukses;

  const DigiflazzState({this.isLoading = false, this.error, this.sukses});

  DigiflazzState copyWith({bool? isLoading, String? error, String? sukses}) {
    return DigiflazzState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sukses: sukses,
    );
  }
}

/// Notifier untuk operasi async Digiflazz.
///
/// Mengelola state loading/error/sukses untuk:
/// - Simpan credential
/// - Test koneksi
/// - Sinkronisasi produk
/// - Proses antrian
class DigiflazzNotifier extends StateNotifier<DigiflazzState> {
  final Ref _ref;

  DigiflazzNotifier(this._ref) : super(const DigiflazzState());

  /// Simpan credential API Digiflazz.
  Future<bool> simpanCredential({
    required String username,
    required String apiKey,
  }) async {
    state = state.copyWith(isLoading: true, error: null, sukses: null);
    try {
      final config = _ref.read(digiflazzConfigProvider);
      await config.saveCredential(username: username, apiKey: apiKey);

      // Invalidate providers yang bergantung pada credential
      _ref.invalidate(hasCredentialProvider);
      _ref.invalidate(saldoDigiflazzProvider);

      state = state.copyWith(
        isLoading: false,
        sukses: 'Credential berhasil disimpan.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal simpan credential: $e',
      );
      return false;
    }
  }

  /// Test koneksi ke Digiflazz (cek saldo).
  Future<int?> testKoneksi() async {
    state = state.copyWith(isLoading: true, error: null, sukses: null);
    try {
      final client = _ref.read(digiflazzClientProvider);
      final response = await client.cekSaldo();

      state = state.copyWith(
        isLoading: false,
        sukses: 'Koneksi berhasil! Saldo: Rp ${response.deposit}',
      );
      return response.deposit;
    } on DigiflazzException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Sinkronisasi produk dari Digiflazz.
  Future<bool> sinkronisasiProduk() async {
    state = state.copyWith(isLoading: true, error: null, sukses: null);
    try {
      final syncService = _ref.read(syncServiceProvider);
      final result = await syncService.sinkronisasiProduk();

      // Invalidate provider produk agar UI refresh
      _ref.invalidate(saldoDigiflazzProvider);

      state = state.copyWith(isLoading: false, sukses: result.pesan);
      return true;
    } on DigiflazzException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Proses semua antrian pending.
  Future<void> prosesAntrian() async {
    state = state.copyWith(isLoading: true, error: null, sukses: null);
    try {
      final queueService = _ref.read(transactionQueueProvider);
      final result = await queueService.prosesSemuaPending();

      _ref.invalidate(jumlahPendingProvider);
      _ref.invalidate(saldoDigiflazzProvider);

      state = state.copyWith(
        isLoading: false,
        sukses:
            'Selesai: ${result.sukses} sukses, '
            '${result.gagal} gagal, '
            '${result.pending} pending.',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Kirim ulang satu item antrian.
  Future<void> kirimUlang(int idAntrian) async {
    state = state.copyWith(isLoading: true, error: null, sukses: null);
    try {
      final queueService = _ref.read(transactionQueueProvider);
      await queueService.kirimUlang(idAntrian);

      _ref.invalidate(jumlahPendingProvider);

      state = state.copyWith(
        isLoading: false,
        sukses: 'Transaksi berhasil dikirim ulang.',
      );
    } on DigiflazzException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Hapus credential API.
  Future<void> hapusCredential() async {
    final config = _ref.read(digiflazzConfigProvider);
    await config.clearCredential();
    _ref.invalidate(hasCredentialProvider);
    _ref.invalidate(saldoDigiflazzProvider);
    state = state.copyWith(sukses: 'Credential dihapus.');
  }

  /// Reset state error/sukses.
  void resetState() {
    state = const DigiflazzState();
  }
}

/// Provider notifier Digiflazz.
final digiflazzNotifierProvider =
    StateNotifierProvider<DigiflazzNotifier, DigiflazzState>((ref) {
      return DigiflazzNotifier(ref);
    });

/// Provider untuk melacak apakah sedang dalam mode Admin.
/// Default: false (Mode User biasa).
final isAdminModeProvider = StateProvider<bool>((ref) => false);
