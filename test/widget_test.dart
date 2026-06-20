import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vijnanadeepam/main.dart';

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
}
