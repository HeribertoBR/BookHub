import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf_reader_app/features/library/library_page.dart';
import 'package:pdf_reader_app/data/models/book.dart';
import 'package:pdf_reader_app/services/theme_controller.dart';

void main() {
  test('reading progress uses the real PDF page count', () {
    const book = Book(
      id: 'book-1',
      title: 'Book',
      path: '/book.pdf',
      lastPage: 2,
      totalPages: 12,
    );

    expect(book.readingProgress, 0.25);
    expect(book.readingProgressPercent, 25);
    expect(book.progressAtPage(11), 1);
    expect(book.progressAtPage(20), 1);
  });

  test('older saved books default to unknown page count', () {
    final book = Book.fromJson({
      'id': 'book-1',
      'title': 'Book',
      'path': '/book.pdf',
      'lastPage': 2,
    });

    expect(book.totalPages, 0);
    expect(book.readingProgressPercent, 0);
  });

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
