import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_entrepreneur/core/theme/theme_controller.dart';
import 'package:future_entrepreneur/main.dart';

void main() {
  testWidgets('FutureEntrepreneurApp renders dashboard and toggles theme',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FutureEntrepreneurApp());

    expect(find.text('Future Entrepreneur'), findsOneWidget);
    expect(find.text('Fikrini Başarıya Dönüştür!'), findsOneWidget);

    final initialMode = ThemeController.instance.themeMode.value;
    expect(initialMode, ThemeMode.light);

    // Toggle theme
    ThemeController.instance.toggleTheme();
    await tester.pumpAndSettle();

    expect(ThemeController.instance.themeMode.value, ThemeMode.dark);
  });
}
