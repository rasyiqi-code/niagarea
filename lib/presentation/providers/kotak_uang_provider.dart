import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import 'core_providers.dart';

/// Stream provider semua kotak uang (reactive).
final kotakUangListProvider = StreamProvider<List<KotakUang>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.kotakUangDao.watchAllKotakUang();
});

/// Future provider kotak uang berdasarkan ID.
final kotakUangByIdProvider = FutureProvider.family<KotakUang?, int>((ref, id) {
  final db = ref.watch(databaseProvider);
  return db.kotakUangDao.getKotakUangById(id);
});
