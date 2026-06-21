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
    expect(find.text('Apostolic Roots'), findsWidgets);

    await tester.ensureVisible(find.byKey(const Key('volume-12')));
    await tester.tap(find.byKey(const Key('volume-12')));
    await tester.pumpAndSettle();

    expect(find.text('Apostolic Roots'), findsWidgets);
    expect(find.text('CHAPTER 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Bookmark'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-bookmarks')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('volume-12')), findsOneWidget);
  });

  test('loads a PDF-backed volume from the catalogue', () {
    final volume = MagazineVolume.fromJson({
      'id': 'volume-46',
      'year': 2023,
      'volume_number': 46,
      'title': 'വിക്ഞാനദീപം',
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
  });
}
