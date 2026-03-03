/// Provider database dan layanan inti NiagaRea.
///
/// Menyediakan instance singleton AppDatabase dan
/// FifoEngine via Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../domain/fifo/fifo_engine.dart';

/// Provider singleton untuk database utama.
///
/// Instance ini digunakan di seluruh aplikasi.
/// Jangan dispose secara manual — lifecycle mengikuti app.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// Provider FIFO Engine.
///
/// Bergantung pada [databaseProvider].
final fifoEngineProvider = Provider<FifoEngine>((ref) {
  final db = ref.watch(databaseProvider);
  return FifoEngine(db);
});
