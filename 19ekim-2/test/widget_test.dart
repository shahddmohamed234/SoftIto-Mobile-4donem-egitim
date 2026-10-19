import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım v1 temel arayüz, su ekleme ve tema geçiş testi', (WidgetTester tester) async {
    // Başlangıçta dark mode olduğundan emin olalım
    ThemeController.instance.setThemeMode(ThemeMode.dark);

    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // Uygulama başlığı ve başlangıç durumu doğrulaması
    expect(find.text('Susadım'), findsOneWidget);
    expect(find.text('v1'), findsOneWidget);
    expect(find.text('%0'), findsOneWidget);

    // +200 ml hızlı ekleme butonuna basma
    final add200Btn = find.text('+200');
    expect(add200Btn, findsOneWidget);
    await tester.tap(add200Btn);
    await tester.pumpAndSettle();

    // Tüketilen suyun güncellendiğini doğrulama (200 / 2000 ml = %10)
    expect(find.text('%10'), findsOneWidget);

    // Tema Değiştirme Butonuna basma (Dark -> Light)
    final themeToggleBtn = find.byTooltip('Açık Mod');
    expect(themeToggleBtn, findsOneWidget);
    await tester.tap(themeToggleBtn);
    await tester.pumpAndSettle();

    // Açık moda geçtiğini doğrulama
    expect(ThemeController.instance.isDarkMode, isFalse);
    expect(find.byTooltip('Karanlık Mod'), findsOneWidget);

    // Tekrar Karanlık moda geçiş
    await tester.tap(find.byTooltip('Karanlık Mod'));
    await tester.pumpAndSettle();
    expect(ThemeController.instance.isDarkMode, isTrue);
  });
}
