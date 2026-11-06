import 'package:firebase_analytics/firebase_analytics.dart';

class AnalitikServisi {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> ekranGoruntulendi(String ekranAdi) async {
    await _analytics.logScreenView(screenName: ekranAdi);
  }

  Future<void> butonTiklandi({
    required String buttonId,
    required String kategori,
  }) async {
    await _analytics.logEvent(
      name: "buton_tiklama",
      parameters: {
        'buton_id': buttonId,
        'kategori': kategori,
        'zaman': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> sepeteEklendi({
    required String urunId,
    required double fiyat,
  }) async {
    await _analytics.logEvent(
      name: 'sepete_ekleme',
      parameters: {'urun_id': urunId, 'fiyat': fiyat, 'para_birimi': 'TL'},
    );
  }
}
