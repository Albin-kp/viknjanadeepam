import 'package:flutter_test/flutter_test.dart';
import 'package:vijnanadeepam/main.dart';

void main() {
  testWidgets('opens a volume and displays the reader', (tester) async {
    await tester.pumpWidget(const VijnanaDeepamApp());

    expect(find.text('Annual Archive'), findsOneWidget);
    expect(find.text('Volume 12'), findsOneWidget);

    await tester.tap(find.text('Volume 12'));
    await tester.pumpAndSettle();

    expect(find.text('The Light of Knowledge'), findsWidgets);
    expect(find.text('CHAPTER 1'), findsOneWidget);
  });
}
