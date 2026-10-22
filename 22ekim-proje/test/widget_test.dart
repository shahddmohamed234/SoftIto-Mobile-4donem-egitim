import 'package:flutter_test/flutter_test.dart';
import 'package:go_on/main.dart';

void main() {
  testWidgets('GoOnApp basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoOnApp());
    expect(find.byType(GoOnApp), findsOneWidget);
  });
}
