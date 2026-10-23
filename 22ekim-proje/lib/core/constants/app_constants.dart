class CatMascot {
  final String id;
  final String name;
  final String personality;
  final String personalityEn;
  final String assetPath;
  final String lottieAssetPath;
  final String greeting;
  final String greetingEn;

  const CatMascot({
    required this.id,
    required this.name,
    required this.personality,
    required this.personalityEn,
    required this.assetPath,
    required this.lottieAssetPath,
    required this.greeting,
    required this.greetingEn,
  });

  String getPersonality(String lang) => lang == 'EN' ? personalityEn : personality;
  String getGreeting(String lang) => lang == 'EN' ? greetingEn : greeting;
}

class AppConstants {
  static const List<CatMascot> mascots = [
    CatMascot(
      id: 'pamuk',
      name: 'Pamuk',
      personality: 'Sakin, şefkatli ve huzur dolu tüy yumağı',
      personalityEn: 'Calm, affectionate, and peaceful ball of fur',
      assetPath: 'assets/images/cat_pamuk.png',
      lottieAssetPath: 'assets/animations/cat_pamuk.json',
      greeting: 'Bugün harika bir gün olacak, birlikte başlayalım!',
      greetingEn: 'Today is going to be wonderful, let us start together!',
    ),
    CatMascot(
      id: 'tarcin',
      name: 'Tarçın',
      personality: 'Enerjik, neşeli ve durdurulamaz sarman',
      personalityEn: 'Energetic, cheerful, and unstoppable ginger',
      assetPath: 'assets/images/cat_tarcin.png',
      lottieAssetPath: 'assets/animations/cat_tarcin.json',
      greeting: 'Hadi hedeflerine doğru koşalım, sen yapabilirsin!',
      greetingEn: 'Let us run towards your goals, you can do it!',
    ),
    CatMascot(
      id: 'duman',
      name: 'Duman',
      personality: 'Derin düşünen, bilge ve huzurlu yoldaş',
      personalityEn: 'Deep-thinking, wise, and serene companion',
      assetPath: 'assets/images/cat_duman.png',
      lottieAssetPath: 'assets/animations/cat_duman.json',
      greeting: 'Her küçük adım büyük bir değişimin başlangıcıdır.',
      greetingEn: 'Every small step is the beginning of a great change.',
    ),
    CatMascot(
      id: 'zeytin',
      name: 'Zeytin',
      personality: 'Meraklı, oyuncu ve zarif smokin kedi',
      personalityEn: 'Curious, playful, and graceful tuxedo cat',
      assetPath: 'assets/images/cat_zeytin.png',
      lottieAssetPath: 'assets/animations/cat_zeytin.json',
      greeting: 'Yeni alışkanlıklar keşfetmeye hazır mısın?',
      greetingEn: 'Are you ready to explore new habits?',
    ),
  ];

  static const List<Map<String, String>> habitSuggestionsTr = [
    {
      'name': 'Koşu Yapmak',
      'nameTr': 'Koşu Yapmak',
      'nameEn': 'Running',
      'emoji': '🏃‍♂️',
      'category': 'Spor',
      'categoryTr': 'Spor',
      'categoryEn': 'Fitness',
    },
    {
      'name': 'Yürüyüşe Çıkmak',
      'nameTr': 'Yürüyüşe Çıkmak',
      'nameEn': 'Go for a Walk',
      'emoji': '🚶‍♀️',
      'category': 'Spor',
      'categoryTr': 'Spor',
      'categoryEn': 'Fitness',
    },
    {
      'name': 'Kitap Okumak',
      'nameTr': 'Kitap Okumak',
      'nameEn': 'Read a Book',
      'emoji': '📚',
      'category': 'Gelişim',
      'categoryTr': 'Gelişim',
      'categoryEn': 'Growth',
    },
    {
      'name': 'Günlük Yazmak',
      'nameTr': 'Günlük Yazmak',
      'nameEn': 'Daily Journaling',
      'emoji': '✍️',
      'category': 'Farkındalık',
      'categoryTr': 'Farkındalık',
      'categoryEn': 'Mindfulness',
    },
    {
      'name': 'Resim / Boyama',
      'nameTr': 'Resim / Boyama',
      'nameEn': 'Drawing / Painting',
      'emoji': '🎨',
      'category': 'Sanat',
      'categoryTr': 'Sanat',
      'categoryEn': 'Art',
    },
    {
      'name': 'Örgü Örmek',
      'nameTr': 'Örgü Örmek',
      'nameEn': 'Knitting / Crafting',
      'emoji': '🧶',
      'category': 'Hobi',
      'categoryTr': 'Hobi',
      'categoryEn': 'Hobby',
    },
    {
      'name': 'Meditasyon Yapmak',
      'nameTr': 'Meditasyon Yapmak',
      'nameEn': 'Meditation',
      'emoji': '🧘',
      'category': 'Zihin',
      'categoryTr': 'Zihin',
      'categoryEn': 'Mind',
    },
    {
      'name': '2 Litre Su İçmek',
      'nameTr': '2 Litre Su İçmek',
      'nameEn': 'Drink 2L Water',
      'emoji': '💧',
      'category': 'Sağlık',
      'categoryTr': 'Sağlık',
      'categoryEn': 'Health',
    },
    {
      'name': 'Erken Uyanmak',
      'nameTr': 'Erken Uyanmak',
      'nameEn': 'Wake Up Early',
      'emoji': '🌅',
      'category': 'Rutin',
      'categoryTr': 'Rutin',
      'categoryEn': 'Routine',
    },
    {
      'name': 'Gitar / Müzik Pratiği',
      'nameTr': 'Gitar / Müzik Pratiği',
      'nameEn': 'Guitar / Music Practice',
      'emoji': '🎸',
      'category': 'Sanat',
      'categoryTr': 'Sanat',
      'categoryEn': 'Art',
    },
  ];

  static const List<Map<String, String>> habitSuggestionsEn = [
    {
      'name': 'Running',
      'nameTr': 'Koşu Yapmak',
      'nameEn': 'Running',
      'emoji': '🏃‍♂️',
      'category': 'Fitness',
      'categoryTr': 'Spor',
      'categoryEn': 'Fitness',
    },
    {
      'name': 'Go for a Walk',
      'nameTr': 'Yürüyüşe Çıkmak',
      'nameEn': 'Go for a Walk',
      'emoji': '🚶‍♀️',
      'category': 'Fitness',
      'categoryTr': 'Spor',
      'categoryEn': 'Fitness',
    },
    {
      'name': 'Read a Book',
      'nameTr': 'Kitap Okumak',
      'nameEn': 'Read a Book',
      'emoji': '📚',
      'category': 'Growth',
      'categoryTr': 'Gelişim',
      'categoryEn': 'Growth',
    },
    {
      'name': 'Daily Journaling',
      'nameTr': 'Günlük Yazmak',
      'nameEn': 'Daily Journaling',
      'emoji': '✍️',
      'category': 'Mindfulness',
      'categoryTr': 'Farkındalık',
      'categoryEn': 'Mindfulness',
    },
    {
      'name': 'Drawing / Painting',
      'nameTr': 'Resim / Boyama',
      'nameEn': 'Drawing / Painting',
      'emoji': '🎨',
      'category': 'Art',
      'categoryTr': 'Sanat',
      'categoryEn': 'Art',
    },
    {
      'name': 'Knitting / Crafting',
      'nameTr': 'Örgü Örmek',
      'nameEn': 'Knitting / Crafting',
      'emoji': '🧶',
      'category': 'Hobby',
      'categoryTr': 'Hobi',
      'categoryEn': 'Hobby',
    },
    {
      'name': 'Meditation',
      'nameTr': 'Meditasyon Yapmak',
      'nameEn': 'Meditation',
      'emoji': '🧘',
      'category': 'Mind',
      'categoryTr': 'Zihin',
      'categoryEn': 'Mind',
    },
    {
      'name': 'Drink 2L Water',
      'nameTr': '2 Litre Su İçmek',
      'nameEn': 'Drink 2L Water',
      'emoji': '💧',
      'category': 'Health',
      'categoryTr': 'Sağlık',
      'categoryEn': 'Health',
    },
    {
      'name': 'Wake Up Early',
      'nameTr': 'Erken Uyanmak',
      'nameEn': 'Wake Up Early',
      'emoji': '🌅',
      'category': 'Routine',
      'categoryTr': 'Rutin',
      'categoryEn': 'Routine',
    },
    {
      'name': 'Guitar / Music Practice',
      'nameTr': 'Gitar / Müzik Pratiği',
      'nameEn': 'Guitar / Music Practice',
      'emoji': '🎸',
      'category': 'Art',
      'categoryTr': 'Sanat',
      'categoryEn': 'Art',
    },
  ];

  static List<Map<String, String>> habitSuggestions = habitSuggestionsTr;

  static List<Map<String, String>> getHabitSuggestions(String lang) {
    return lang == 'EN' ? habitSuggestionsEn : habitSuggestionsTr;
  }

  static const List<Map<String, String>> motivationalQuotesTr = [
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

  static const List<Map<String, String>> motivationalQuotesEn = [
    {
      'quote': 'Never underestimate the power of small steps. A step taken every day moves mountains.',
      'author': 'Go On Inspiration',
      'tag': 'Consistency',
    },
    {
      'quote': 'Habits are the architects of your life. Pay close attention to what you build today.',
      'author': 'F. M. Alexander',
      'tag': 'Mindfulness',
    },
    {
      'quote': 'Success is the sum of small disciplines, repeated day in and day out.',
      'author': 'Robert Collier',
      'tag': 'Discipline',
    },
    {
      'quote': 'Be agile like a cat, determined like your dreams. Peace lies in consistency.',
      'author': 'Purr Philosophy',
      'tag': 'Peace',
    },
    {
      'quote': 'Be gentle with yourself, but do not give up on your goals. You can keep this streak going!',
      'author': 'Your Go On Buddy',
      'tag': 'Self-Compassion',
    },
  ];

  static List<Map<String, String>> motivationalQuotes = motivationalQuotesTr;

  static List<Map<String, String>> getMotivationalQuotes(String lang) {
    return lang == 'EN' ? motivationalQuotesEn : motivationalQuotesTr;
  }

  static const List<Map<String, dynamic>> defaultBadges = [
    {
      'id': 'badge_first_step',
      'type': 'badge',
      'title': 'İlk Adım',
      'titleEn': 'First Step',
      'description': 'İlk alışkanlığını tamamlayıp seriye başladın!',
      'descriptionEn': 'Completed your first habit and started the streak!',
      'isUnlocked': true,
      'icon': 'flag',
    },
    {
      'id': 'badge_3_day_streak',
      'type': 'badge',
      'title': '3 Günlük Işıltı',
      'titleEn': '3-Day Glow',
      'description': 'Üst üste 3 gün boyunca alışkanlıklarını tamamladın.',
      'descriptionEn': 'Maintained habits for 3 consecutive days.',
      'isUnlocked': true,
      'icon': 'auto_awesome',
    },
    {
      'id': 'badge_7_day_reader',
      'type': 'badge',
      'title': 'Kitap Kurdu Kedicik',
      'titleEn': 'Bookworm Kitten',
      'description': '7 gün üst üste kitap okuma alışkanlığını sürdürdün.',
      'descriptionEn': 'Maintained reading habits for 7 consecutive days.',
      'isUnlocked': false,
      'icon': 'menu_book',
    },
    {
      'id': 'badge_early_bird',
      'type': 'badge',
      'title': 'Erken Kalkan Pati',
      'titleEn': 'Early Bird Paw',
      'description': 'Erken uyanma hedefini 5 kez başarıyla tamamladın.',
      'descriptionEn': 'Successfully completed early morning routine 5 times.',
      'isUnlocked': false,
      'icon': 'wb_sunny',
    },
    {
      'id': 'badge_water_master',
      'type': 'badge',
      'title': 'Su Şampiyonu',
      'titleEn': 'Hydration Champion',
      'description': '10 gün boyunca günlük su hedefini aksatmadın.',
      'descriptionEn': 'Hit daily hydration goals for 10 days.',
      'isUnlocked': false,
      'icon': 'water_drop',
    },
    {
      'id': 'badge_streak_30',
      'type': 'badge',
      'title': 'Efsanevi Seri',
      'titleEn': 'Legendary Streak',
      'description': 'Tam 30 gün boyunca kesintisiz seriyi korudun!',
      'descriptionEn': 'Maintained an unbroken streak for 30 full days!',
      'isUnlocked': false,
      'icon': 'workspace_premium',
    },
  ];

  static const List<Map<String, dynamic>> defaultCoupons = [
    {
      'id': 'coupon_jan',
      'type': 'coupon',
      'title': 'Ocak Ayı Zaferi: %25 Kitap İndirimi',
      'titleEn': 'January Victory: 25% Book Discount',
      'description': 'D&R veya seçili kitapçılarda geçerli indirim kodu.',
      'descriptionEn': 'Valid at bookstores and online reading stores.',
      'discountCode': 'GOON-KITAP25',
      'isUnlocked': true,
      'icon': 'local_activity',
    },
    {
      'id': 'coupon_feb',
      'type': 'coupon',
      'title': 'Şubat Kahve Keyfi: 1 Kahve Hediye',
      'titleEn': 'February Coffee: 1 Free Coffee',
      'description': 'Tüm anlaşmalı kahvecilerde geçerli bedava kahve kuponu.',
      'descriptionEn': 'Complimentary specialty coffee at partner cafes.',
      'discountCode': 'KAHVE-KEDI100',
      'isUnlocked': true,
      'icon': 'coffee',
    },
    {
      'id': 'coupon_mar',
      'type': 'coupon',
      'title': 'Mart Sinema Bileti: %50 İndirim',
      'titleEn': 'March Cinema: 50% Off Ticket',
      'description': 'Paribu Cineverse salonlarında geçerli film indirimi.',
      'descriptionEn': 'Valid for movie screenings at participating cinemas.',
      'discountCode': 'SINEMA-GOON50',
      'isUnlocked': false,
      'icon': 'movie',
    },
    {
      'id': 'coupon_apr',
      'type': 'coupon',
      'title': 'Nisan Spor ve Giyim: 200 TL Hediye Çeki',
      'titleEn': 'April Fitness: \$15 Gift Voucher',
      'description': 'Decathlon ve seçili spor mağazalarında geçerli.',
      'descriptionEn': 'Valid at athletic and sporting equipment stores.',
      'discountCode': 'SPOR-GIFT200',
      'isUnlocked': false,
      'icon': 'checkroom',
    },
    {
      'id': 'coupon_may',
      'type': 'coupon',
      'title': 'Mayıs Konser Bileti: %30 İndirim',
      'titleEn': 'May Concerts: 30% Discount',
      'description': 'Biletix ve Passo etkinliklerinde geçerli özel kupon.',
      'descriptionEn': 'Special discount code for concert and festival events.',
      'discountCode': 'KONSER-MUSIC30',
      'isUnlocked': false,
      'icon': 'music_note',
    },
  ];
}
