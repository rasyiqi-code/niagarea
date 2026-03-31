import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/digiflazz/pascabayar_service.dart';
import '../../services/digiflazz/digiflazz_models.dart';
import 'digiflazz_provider.dart';

/// State untuk proses inquiry pascabayar.
class PascabayarInquiryState {
  final bool isLoading;
  final TagihanResponse? data;
  final String? error;

  const PascabayarInquiryState({this.isLoading = false, this.data, this.error});

  PascabayarInquiryState copyWith({
    bool? isLoading,
    TagihanResponse? data,
    String? error,
  }) {
    return PascabayarInquiryState(
      isLoading: isLoading ?? this.isLoading,
      data: data,
      error: error,
    );
  }
}

/// Provider singleton untuk PascabayarService.
final pascabayarServiceProvider = Provider<PascabayarService>((ref) {
  final client = ref.watch(digiflazzClientProvider);
  return PascabayarService(client: client);
});

/// Notifier untuk mengelola alur inquiry pascabayar.
class PascabayarNotifier extends StateNotifier<PascabayarInquiryState> {
  final PascabayarService _service;

  PascabayarNotifier(this._service) : super(const PascabayarInquiryState());

  /// Reset state inquiry.
  void reset() => state = const PascabayarInquiryState();

  /// Melakukan inquiry tagihan.
  Future<void> inquiry({
    required String customerNo,
    required String buyerSkuCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _service.inquiry(
        customerNo: customerNo,
        buyerSkuCode: buyerSkuCode,
      );
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Utilitas untuk cek nama pelanggan PLN.
  Future<InquiryPlnResponse?> cekPelangganPln(String customerNo) async {
    try {
      return await _service.cekPelangganPln(customerNo);
    } catch (e) {
      return null;
    }
  }
}

/// Provider notifier pascabayar.
final pascabayarNotifierProvider =
    StateNotifierProvider<PascabayarNotifier, PascabayarInquiryState>((ref) {
      final service = ref.watch(pascabayarServiceProvider);
      return PascabayarNotifier(service);
    });
