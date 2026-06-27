import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vijnanadeepam/main.dart';
import 'package:vijnanadeepam/models/magazine_volume.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('opens a volume and displays the reader', (tester) async {
    await tester.pumpWidget(const VijnanaDeepamApp());

    expect(find.byKey(const Key('app-heading')), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('category-Sabhacharithram')), findsOneWidget);
    await tester.tap(find.byKey(const Key('category-Sabhacharithram')));
    await tester.pumpAndSettle();
    expect(find.text('Serial No -52'), findsWidgets);
    expect(find.byKey(const Key('download-volume-52')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('volume-52')));
    await tester.tap(find.byKey(const Key('volume-52')));
    await tester.pumpAndSettle();

    expect(find.text('2026 · Volume 52'), findsOneWidget);
    expect(find.text('1 / 8'), findsOneWidget);
    expect(find.byTooltip('Download PDF'), findsOneWidget);

    await tester.tap(find.byTooltip('Bookmark'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-bookmarks')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('volume-52')), findsOneWidget);
  });

  test('loads a PDF-backed volume from the catalogue', () {
    final volume = MagazineVolume.fromJson({
      'id': 'volume-46',
      'year': 2023,
      'volume_number': 46,
      'title': 'വിജ്ഞാന ദീപം',
      'page_images': [
        'assets/books/volume-46-page-001.jpg',
        'assets/books/volume-46-page-002.jpg',
      ],
      'pdf_path': 'assets/books/volume-46-original.pdf',
      'published': true,
    });

    expect(volume.pageImages, hasLength(2));
    expect(volume.pdfPath, endsWith('original.pdf'));
    expect(volume.chapters, isEmpty);
    expect(volume.category, 'General');
    expect(volume.coverColorHex, '#8F2020');
    expect(volume.coverIssueLabel, '2023');
  });

  test('builds a cover issue label from uploaded PDF metadata', () {
    final volume = MagazineVolume.fromJson({
      'year': 2023,
      'volume_number': 47,
      'title': 'Serial No - 47',
      'subtitle': 'NOVEMBER 2023',
      'issue_label': 'NOVEMBER 2023',
      'published': true,
    });

    expect(volume.coverIssueLabel, 'NOVEMBER 2023');
  });
}
