/// Widget test dasar untuk NiagaRea.
///
/// Memverifikasi bahwa aplikasi bisa di-render
/// tanpa crash.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:niagarea/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Aplikasi bisa di-render tanpa crash', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: NiagaReaApp()));

    // Verifikasi judul muncul
    expect(find.text('NiagaRea'), findsOneWidget);
  });
}
