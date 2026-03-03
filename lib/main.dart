/// Entry point aplikasi NiagaRea.
///
/// Menginisialisasi database, provider, dan tema
/// sebelum menjalankan MaterialApp.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: NiagaReaApp()));
}
