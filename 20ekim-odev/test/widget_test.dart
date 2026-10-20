import 'package:flutter_test/flutter_test.dart';
import 'package:easy_rent/main.dart';

/// EasyRentApp widget testleri
void main() {
  testWidgets('Açılışta zorunlu LoginScreen karşılamalıdır', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const EasyRentApp());
    await tester.pumpAndSettle();

    // Zorunlu Login ekranı başlığı ve SMS butonu doğrulanır
    expect(find.text('Ehliyet ve Kimlik Doğrulama'), findsOneWidget);
    expect(find.text('SMS Kodu Al ve Giriş Yap'), findsOneWidget);
  });
}
