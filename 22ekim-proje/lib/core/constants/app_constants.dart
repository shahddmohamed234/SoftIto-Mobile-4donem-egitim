class CatMascot {
  final String id;
  final String name;
  final String personality;
  final String assetPath;
  final String greeting;

  const CatMascot({
    required this.id,
    required this.name,
    required this.personality,
    required this.assetPath,
    required this.greeting,
  });
}

class AppConstants {
  static const List<CatMascot> mascots = [
    CatMascot(
      id: 'pamuk',
      name: 'Pamuk',
      personality: 'Sakin, şefkatli ve huzur dolu tüy yumağı',
      assetPath: 'assets/images/cat_pamuk.png',
      greeting: 'Bugün harika bir gün olacak, birlikte başlayalım!',
    ),
    CatMascot(
      id: 'tarcin',
      name: 'Tarçın',
      personality: 'Enerjik, neşeli ve durdurulamaz sarman',
      assetPath: 'assets/images/cat_tarcin.png',
      greeting: 'Hadi hedeflerine doğru koşalım, sen yapabilirsin!',
    ),
    CatMascot(
      id: 'duman',
      name: 'Duman',
      personality: 'Derin düşünen, bilge ve huzurlu yoldaş',
      assetPath: 'assets/images/cat_duman.png',
      greeting: 'Her küçük adım büyük bir değişimin başlangıcıdır.',
    ),
    CatMascot(
      id: 'zeytin',
      name: 'Zeytin',
      personality: 'Meraklı, oyuncu ve zarif smokin kedi',
      assetPath: 'assets/images/cat_zeytin.png',
      greeting: 'Yeni alışkanlıklar keşfetmeye hazır mısın?',
    ),
  ];

  static const List<Map<String, String>> habitSuggestions = [
    {'name': 'Koşu Yapmak', 'emoji': '🏃‍♂️', 'category': 'Spor'},
    {'name': 'Yürüyüşe Çıkmak', 'emoji': '🚶‍♀️', 'category': 'Spor'},
    {'name': 'Kitap Okumak', 'emoji': '📚', 'category': 'Gelişim'},
    {'name': 'Günlük Yazmak', 'emoji': '✍️', 'category': 'Farkındalık'},
    {'name': 'Resim / Boyama', 'emoji': '🎨', 'category': 'Sanat'},
    {'name': 'Örgü Örmek', 'emoji': '🧶', 'category': 'Hobi'},
    {'name': 'Meditasyon Yapmak', 'emoji': '🧘', 'category': 'Zihin'},
    {'name': '2 Litre Su İçmek', 'emoji': '💧', 'category': 'Sağlık'},
    {'name': 'Erken Uyanmak', 'emoji': '🌅', 'category': 'Rutin'},
    {'name': 'Gitar / Müzik Pratiği', 'emoji': '🎸', 'category': 'Sanat'},
  ];

  static const List<Map<String, String>> motivationalQuotes = [
    {
      'quote': 'Küçük adımların gücünü asla küçümse. Her gün atılan bir adım, dağları aşmanı sağlar.',
      'author': 'Go On İlhamı',
      'tag': 'Süreklilik',
    },
    {
      'quote': 'Alışkanlıklar hayatının mimarlarıdır. Bugün ne inşa ettiğine dikkat et.',
      'author': 'F. M. Alexander',
      'tag': 'Farkındalık',
    },
    {
      'quote': 'Başarı, her gün tekrarlanan küçük disiplinlerin toplamıdır.',
      'author': 'Robert Collier',
      'tag': 'Disiplin',
    },
    {
      'quote': 'Kediler gibi esnek, hedeflerin gibi kararlı ol. Huzur süreklilikte gizlidir.',
      'author': 'Miyav Felsefesi',
      'tag': 'Huzur',
    },
    {
      'quote': 'Kendine nazik ol ama hedeflerinden de vazgeçme. Sen bu seriyi sürdürebilirsin!',
      'author': 'Go On Dostun',
      'tag': 'Özşefkat',
    },
  ];

  static const List<Map<String, dynamic>> defaultBadges = [
    {
      'id': 'badge_first_step',
      'type': 'badge',
      'title': 'İlk Adım',
      'description': 'İlk alışkanlığını tamamlayıp seriye başladın!',
      'isUnlocked': true,
      'icon': 'flag',
    },
    {
      'id': 'badge_3_day_streak',
      'type': 'badge',
      'title': '3 Günlük Işıltı',
      'description': 'Üst üste 3 gün boyunca alışkanlıklarını tamamladın.',
      'isUnlocked': true,
      'icon': 'auto_awesome',
    },
    {
      'id': 'badge_7_day_reader',
      'type': 'badge',
      'title': 'Kitap Kurdu Kedicik',
      'description': '7 gün üst üste kitap okuma alışkanlığını sürdürdün.',
      'isUnlocked': false,
      'icon': 'menu_book',
    },
    {
      'id': 'badge_early_bird',
      'type': 'badge',
      'title': 'Erken Kalkan Pati',
      'description': 'Erken uyanma hedefini 5 kez başarıyla tamamladın.',
      'isUnlocked': false,
      'icon': 'wb_sunny',
    },
    {
      'id': 'badge_water_master',
      'type': 'badge',
      'title': 'Su Şampiyonu',
      'description': '10 gün boyunca günlük su hedefini aksatmadın.',
      'isUnlocked': false,
      'icon': 'water_drop',
    },
    {
      'id': 'badge_streak_30',
      'type': 'badge',
      'title': 'Efsanevi Seri',
      'description': 'Tam 30 gün boyunca kesintisiz seriyi korudun!',
      'isUnlocked': false,
      'icon': 'workspace_premium',
    },
  ];

  static const List<Map<String, dynamic>> defaultCoupons = [
    {
      'id': 'coupon_jan',
      'type': 'coupon',
      'title': 'Ocak Ayı Zaferi: %25 Kitap İndirimi',
      'description': 'D&R veya seçili kitapçılarda geçerli indirim kodu.',
      'discountCode': 'GOON-KITAP25',
      'isUnlocked': true,
      'icon': 'local_activity',
    },
    {
      'id': 'coupon_feb',
      'type': 'coupon',
      'title': 'Şubat Kahve Keyfi: 1 Kahve Hediye',
      'description': 'Tüm anlaşmalı kahvecilerde geçerli bedava kahve kuponu.',
      'discountCode': 'KAHVE-KEDI100',
      'isUnlocked': true,
      'icon': 'coffee',
    },
    {
      'id': 'coupon_mar',
      'type': 'coupon',
      'title': 'Mart Sinema Bileti: %50 İndirim',
      'description': 'Paribu Cineverse salonlarında geçerli film indirimi.',
      'discountCode': 'SINEMA-GOON50',
      'isUnlocked': false,
      'icon': 'movie',
    },
    {
      'id': 'coupon_apr',
      'type': 'coupon',
      'title': 'Nisan Spor ve Giyim: 200 TL Hediye Çeki',
      'description': 'Decathlon ve seçili spor mağazalarında geçerli.',
      'discountCode': 'SPOR-GIFT200',
      'isUnlocked': false,
      'icon': 'checkroom',
    },
    {
      'id': 'coupon_may',
      'type': 'coupon',
      'title': 'Mayıs Konser Bileti: %30 İndirim',
      'description': 'Biletix ve Passo etkinliklerinde geçerli özel kupon.',
      'discountCode': 'KONSER-MUSIC30',
      'isUnlocked': false,
      'icon': 'music_note',
    },
  ];
}
