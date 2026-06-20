import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vijnanadeepam/main.dart';

void main() {
  testWidgets('opens a volume and displays the reader', (tester) async {
    await tester.pumpWidget(const VijnanaDeepamApp());

    expect(find.byKey(const Key('app-heading')), findsOneWidget);
    expect(find.text('Apostolic Roots'), findsWidgets);

    await tester.ensureVisible(find.byKey(const Key('volume-12')));
    await tester.tap(find.byKey(const Key('volume-12')));
    await tester.pumpAndSettle();

    expect(find.text('Apostolic Roots'), findsWidgets);
    expect(find.text('CHAPTER 1'), findsOneWidget);
  });
}
