import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Status konektivitas internet.
enum ConnectivityStatus {
  isConnected,
  isDisconnected,
  isNotDetermined,
}

/// Provider untuk memantau status koneksi internet secara real-time.
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    // connectivity_plus v6.0+ mengembalikan List<ConnectivityResult>
    if (results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.isDisconnected;
    } else {
      return ConnectivityStatus.isConnected;
    }
  });
});

/// Provider boolean sederhana untuk mengecek apakah sedang offline.
final isOfflineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.maybeWhen(
    data: (s) => s == ConnectivityStatus.isDisconnected,
    orElse: () => false,
  );
});
