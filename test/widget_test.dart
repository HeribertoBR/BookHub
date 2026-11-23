import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf_reader_app/features/library/library_page.dart';
import 'package:pdf_reader_app/services/theme_controller.dart';

void main() {
  testWidgets('the theme switch changes between light and dark', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await ThemeController.instance.load();
    await tester.pumpWidget(const MaterialApp(home: LibraryPage()));

    expect(ThemeController.instance.isDark, isFalse);
    expect(find.byTooltip('Cambiar a modo oscuro'), findsOneWidget);

    await tester.tap(find.byTooltip('Cambiar a modo oscuro'));
    await tester.pump();

    expect(ThemeController.instance.isDark, isTrue);
    expect(find.byTooltip('Cambiar a modo claro'), findsOneWidget);
  });
}
