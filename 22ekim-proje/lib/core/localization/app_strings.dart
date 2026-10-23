import '../state/app_state.dart';
import '../utils/translation_service.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'TR': {
      // Navigation
      'nav_today': 'Bugün',
      'nav_stats': 'İstatistik',
      'nav_calendar': 'Takvim',
      'nav_rewards': 'Rozetler',
      'nav_inspiration': 'İlham',
      'nav_profile': 'Profil',

      // Home View
      'home_title': 'Bugün Neler Yaptın? ✨',
      'home_subtitle': 'Her gün düzenli ol, serini bozma!',
      'streak_day': 'Gün',
      'add_habit_title': 'Yeni Alışkanlık Ekle',
      'habit_title_label': 'Alışkanlık Başlığı',
      'habit_title_hint': 'Örn: Kitap Okuma, Yürüyüş...',
      'habit_desc_label': 'Açıklama / Hedef (İsteğe Bağlı)',
      'habit_desc_hint': 'Örn: Günde 20 sayfa okumak',
      'save_habit_btn': 'Alışkanlığı Kaydet',
      'browse_presets_btn': 'Hazır Önerilerden Seç',
      'preset_modal_title': 'Popüler Alışkanlık Önerileri',
      'preset_modal_subtitle': 'Eklemek istediğin alışkanlığa dokun',
      'today_habits_title': 'Bugünün Alışkanlıkları',
      'no_habits': 'Henüz eklenmiş alışkanlık yok. Yukarıdan ekleyebilirsin!',
      'enter_title_warning': 'Lütfen bir alışkanlık başlığı yazın.',
      'habit_added_snack': 'başarıyla eklendi!',
      'completed_count': 'kez yapıldı',
      'add': 'Ekle',
      'delete': 'Sil',
      'delete_habit_title': 'Alışkanlığı Sil',
      'delete_habit_confirm': '"{name}" alışkanlığını silmek istediğine emin misin?',
      'habit_deleted_snack': 'Alışkanlık silindi',
      'more_emojis_btn': 'Daha Fazla',
      'choose_emoji_title': 'Emoji Seç veya Yaz',
      'choose_emoji_subtitle': 'Klavyenden istediğin emojiyi yazabilir veya kategorilerden seçebilirsin.',
      'custom_emoji_hint': 'Emoji yaz veya yapıştır (örn: 🛹, 🏊, ☕)...',
      'select_emoji_btn': 'Kullan',
      'emoji_cat_sports': '🏃‍♂️ Spor & Aktivite',
      'emoji_cat_mind': '📚 Zihin & Çalışma',
      'emoji_cat_health': '🌿 Sağlık & Rutin',
      'emoji_cat_art': '🎨 Sanat & Hobi',
      'emoji_cat_soul': '🌸 Ruh & Yaşam',

      // Statistics
      'stats_title': 'Alışkanlık İstatistikleri 📊',
      'stats_subtitle': 'Bugüne kadar gösterdiğin tüm çabaların özeti burada.',
      'top_habit_badge': 'En Çok Yapılan Alışkanlık',
      'top_habit_completed': 'Toplam {count} kez tamamlandı! 🌟',
      'all_habits_title': 'Tüm Alışkanlıklar',
      'no_stats': 'Görüntülenecek istatistik bulunmuyor.',
      'times_unit': 'Kez',

      // Calendar
      'calendar_title': 'Aylık Takvim ve Seri 📅',
      'calendar_subtitle': 'Alışkanlıklarını tamamladığın günlerde pembe kalpler parlar!',
      'current_streak_title': 'Mevcut Seri',
      'total_hearted_days': 'Toplam Kalpli Gün',
      'cat_keep_collecting_hearts': 'Kalpleri toplamaya devam!',

      // Rewards & Coupons
      'rewards_title': 'Rozetler ve Kuponlar 🎁',
      'rewards_subtitle': 'Serilerini koruyarak başarı rozetlerini ve gerçek indirim kuponlarını aç!',
      'achievement_badges': 'Başarı Rozetleri',
      'monthly_coupons': 'Aylık Gerçek İndirim Kuponları',
      'coupon_copied': 'Kupon kodu panoya kopyalandı!',
      'coupon_locked': '🔒 Tam ay serisi tamamlandığında açılır',
      'coupon_code_locked': 'KİLİTLİ',
      'cat_deserve_rewards': 'Ödülleri hak ettin!',

      // Mascot Selection
      'mascot_select_title': 'Maskotunu Seç',
      'mascot_select_intro_title': 'Sana Yol Arkadaşlığı Edecek Kedini Seç',
      'mascot_select_intro_subtitle': 'Seçtiğin kedi her gün hedeflerinde seni izleyecek ve motive edecek!',
      'mascot_confirm_btn': 'Bu Kediyi Seç ve Devam Et',

      // Motivation
      'inspiration_title': 'Günün İlhamı 🌸',
      'inspiration_subtitle': 'Ruhunu dinlendirecek ve seni ileriye taşıyacak sözler',
      'daily_quote_badge': 'Günün Sözü',
      'daily_tips_title': 'Günün İpucu 💡',
      'daily_tip_desc': 'Küçük hedeflerle başla. Günde sadece 5 sayfa kitap okumak veya 500 adım atmak bile beyninde yeni sinirsel yollar oluşturur.',

      // Profile & Settings
      'profile_title': 'Profil ve Ayarlar ⚙️',
      'profile_subtitle': 'Hesap bilgilerini ve uygulama tercihlerini yönet.',
      'mascot_label': 'Maskot',
      'change_mascot': 'Değiştir',
      'preferences_title': 'Uygulama Tercihleri',
      'app_language': 'Uygulama Dili',
      'theme_selection': 'Tema Seçimi',
      'theme_light': 'Açık Pastel',
      'theme_dark': 'Sakin Gece (Koyu)',
      'faq_title': 'Sıkça Sorulan Sorular (SSS)',
      'faq_q1': 'Streak (Seri) nasıl çalışır?',
      'faq_a1': 'Her gün en az bir alışkanlığını tamamladığında serin 1 gün artar. Gün atlanırsa seri sıfırlanır.',
      'faq_q2': 'Kuponları nasıl kazanırım?',
      'faq_a2': 'Takvimde tam aylık serileri tamamlayarak ve belirli kilometre taşı rozetlerine ulaşarak kuponları aktif hale getirebilirsin.',
      'faq_q3': 'Verilerim nerede saklanıyor?',
      'faq_a3': 'Tüm verilerin cihazında güvenli JSON dosyalarında saklanır, internete ihtiyaç duymaz.',
      'logout_btn': 'Çıkış Yap',
      'logout_dialog_title': 'Çıkış Yapmak İstiyor musun?',
      'logout_dialog_content': 'Oturumun kapatılacak ve giriş ekranına yönlendirileceksin.',
      'cancel': 'İptal',
      'confirm_logout': 'Çıkış Yap',

      // Auth / Login / Register
      'welcome_back': 'Tekrar Hoş Geldin!',
      'welcome_subtitle': 'Alışkanlıklarını takip etmeye devam et.',
      'email': 'E-posta',
      'password': 'Şifre',
      'login_btn': 'Giriş Yap',
      'no_account': 'Hesabın yok mu? Kayıt Ol',
      'register_title': 'Yeni Hesap Oluştur',
      'register_subtitle': 'Daha düzenli bir hayat için ilk adımı at.',
      'name': 'Ad',
      'surname': 'Soyad',
      'birth_date': 'Doğum Tarihi (YYYY-AA-GG)',
      'password_again': 'Şifre Tekrar',
      'register_btn': 'Kayıt Ol ve Maskot Seç',
      'have_account': 'Zaten hesabın var mı? Giriş Yap',
      'fill_all_fields': 'Lütfen tüm alanları doldurun.',
      'passwords_dont_match': 'Şifreler birbiriyle eşleşmiyor.',

      // Cat Messages
      'cat_great_job': 'Harika gidiyorsun!',
      'cat_with_you': 'Her adımda yanındayım!',
      'cat_purr': 'Mırr... Bugün kendine iyi bak!',
      'cat_keep_going': 'Küçük adımlar büyük fark yaratır!',
      'cat_stats_great': 'Rakamların harika gidiyor!',
    },
    'EN': {
      // Navigation
      'nav_today': 'Today',
      'nav_stats': 'Stats',
      'nav_calendar': 'Calendar',
      'nav_rewards': 'Badges',
      'nav_inspiration': 'Inspiration',
      'nav_profile': 'Profile',

      // Home View
      'home_title': 'What did you do today? ✨',
      'home_subtitle': 'Stay consistent, keep your streak alive!',
      'streak_day': 'Days',
      'add_habit_title': 'Add New Habit',
      'habit_title_label': 'Habit Title',
      'habit_title_hint': 'E.g.: Reading, Walking...',
      'habit_desc_label': 'Description / Target (Optional)',
      'habit_desc_hint': 'E.g.: Read 20 pages a day',
      'save_habit_btn': 'Save Habit',
      'browse_presets_btn': 'Pick from Presets',
      'preset_modal_title': 'Popular Habit Suggestions',
      'preset_modal_subtitle': 'Tap any habit to add to your day',
      'today_habits_title': "Today's Habits",
      'no_habits': 'No habits added yet. You can add one above!',
      'enter_title_warning': 'Please enter a habit title.',
      'habit_added_snack': 'successfully added!',
      'completed_count': 'times completed',
      'add': 'Add',
      'delete': 'Delete',
      'delete_habit_title': 'Delete Habit',
      'delete_habit_confirm': 'Are you sure you want to delete "{name}"?',
      'habit_deleted_snack': 'Habit deleted',
      'more_emojis_btn': 'More Emojis',
      'choose_emoji_title': 'Choose or Type Emoji',
      'choose_emoji_subtitle': 'Type any emoji from your keyboard or choose from the categories below.',
      'custom_emoji_hint': 'Type or paste emoji (e.g. 🛹, 🏊, ☕)...',
      'select_emoji_btn': 'Use',
      'emoji_cat_sports': '🏃‍♂️ Sports & Activity',
      'emoji_cat_mind': '📚 Mind & Study',
      'emoji_cat_health': '🌿 Health & Routine',
      'emoji_cat_art': '🎨 Art & Hobby',
      'emoji_cat_soul': '🌸 Soul & Life',


      // Statistics
      'stats_title': 'Habit Statistics 📊',
      'stats_subtitle': 'A summary of all your efforts and milestones.',
      'top_habit_badge': 'Top Habit',
      'top_habit_completed': 'Completed {count} times in total! 🌟',
      'all_habits_title': 'All Habits',
      'no_stats': 'No statistics available yet.',
      'times_unit': 'Times',

      // Calendar
      'calendar_title': 'Monthly Calendar & Streak 📅',
      'calendar_subtitle': 'Pink hearts shine on days you completed habits!',
      'current_streak_title': 'Current Streak',
      'total_hearted_days': 'Total Heart Days',
      'cat_keep_collecting_hearts': 'Keep collecting hearts!',

      // Rewards & Coupons
      'rewards_title': 'Badges & Coupons 🎁',
      'rewards_subtitle': 'Maintain your streaks to unlock badges and real discounts!',
      'achievement_badges': 'Achievement Badges',
      'monthly_coupons': 'Monthly Real Coupons',
      'coupon_copied': 'Coupon code copied to clipboard!',
      'coupon_locked': '🔒 Unlocks with a complete month streak',
      'coupon_code_locked': 'LOCKED',
      'cat_deserve_rewards': 'You earned these rewards!',

      // Mascot Selection
      'mascot_select_title': 'Select Your Mascot',
      'mascot_select_intro_title': 'Choose Your Cat Companion',
      'mascot_select_intro_subtitle': 'Your chosen cat will accompany and motivate you every day!',
      'mascot_confirm_btn': 'Choose This Cat & Continue',

      // Motivation
      'inspiration_title': "Daily Inspiration 🌸",
      'inspiration_subtitle': 'Words to soothe your soul and propel you forward',
      'daily_quote_badge': 'Quote of the Day',
      'daily_tips_title': 'Tip of the Day 💡',
      'daily_tip_desc': 'Start small. Reading just 5 pages or taking 500 steps a day builds new neural pathways in your brain.',

      // Profile & Settings
      'profile_title': 'Profile & Settings ⚙️',
      'profile_subtitle': 'Manage your account and app preferences.',
      'mascot_label': 'Mascot',
      'change_mascot': 'Change',
      'preferences_title': 'App Preferences',
      'app_language': 'App Language',
      'theme_selection': 'Theme Selection',
      'theme_light': 'Light Pastel',
      'theme_dark': 'Calm Night (Dark)',
      'faq_title': 'Frequently Asked Questions (FAQ)',
      'faq_q1': 'How does Streak work?',
      'faq_a1': 'Completing at least one habit daily increases your streak by 1. Missing a day resets the streak.',
      'faq_q2': 'How do I earn coupons?',
      'faq_a2': 'Unlock coupons by maintaining uninterrupted monthly streaks and reaching milestone badges.',
      'faq_q3': 'Where is my data stored?',
      'faq_a3': 'All data is stored locally in JSON files on your device. No internet required.',
      'logout_btn': 'Log Out',
      'logout_dialog_title': 'Do you want to log out?',
      'logout_dialog_content': 'Your session will be closed and you will be redirected to the login screen.',
      'cancel': 'Cancel',
      'confirm_logout': 'Log Out',

      // Auth / Login / Register
      'welcome_back': 'Welcome Back!',
      'welcome_subtitle': 'Continue tracking your habits.',
      'email': 'Email',
      'password': 'Password',
      'login_btn': 'Log In',
      'no_account': "Don't have an account? Sign Up",
      'register_title': 'Create New Account',
      'register_subtitle': 'Take your first step towards a better life.',
      'name': 'First Name',
      'surname': 'Last Name',
      'birth_date': 'Birth Date (YYYY-MM-DD)',
      'password_again': 'Confirm Password',
      'register_btn': 'Sign Up & Select Mascot',
      'have_account': 'Already have an account? Log In',
      'fill_all_fields': 'Please fill in all fields.',
      'passwords_dont_match': 'Passwords do not match.',

      // Cat Messages
      'cat_great_job': "You're doing great!",
      'cat_with_you': "I'm with you every step of the way!",
      'cat_purr': 'Purr... Take good care of yourself today!',
      'cat_keep_going': 'Small steps lead to giant leaps!',
      'cat_stats_great': 'Your numbers are looking great!',
    },
  };

  static String tr(String key) {
    final lang = AppState.instance.language;
    final dict = _localizedValues[lang] ?? _localizedValues['TR']!;
    return dict[key] ?? key;
  }

  static const Map<String, String> _trToEnHabits = {
    'Koşu Yapmak': 'Running',
    'Yürüyüşe Çıkmak': 'Go for a Walk',
    'Kitap Okumak': 'Read a Book',
    'Günlük Yazmak': 'Daily Journaling',
    'Resim / Boyama': 'Drawing / Painting',
    'Örgü Örmek': 'Knitting / Crafting',
    'Meditasyon Yapmak': 'Meditation',
    '2 Litre Su İçmek': 'Drink 2L Water',
    'Erken Uyanmak': 'Wake Up Early',
    'Gitar / Müzik Pratiği': 'Guitar / Music Practice',
    'Spor Yapmak': 'Working Out',
    'Yürüyüş': 'Walking',
    'Koşu': 'Running',
    'Kitap Okuma': 'Reading',
    'Su İçmek': 'Drink Water',
    'Meditasyon': 'Meditation',
    'Ders Çalışmak': 'Studying',
    'Yazılım / Kodlama': 'Coding / Development',
    'Yabancı Dil': 'Language Practice',
    'Yoga': 'Yoga',
    'Yüzme': 'Swimming',
    'Bisiklet': 'Cycling',
    'Örgü': 'Knitting',
    'Resim': 'Painting',
    'Yemek Pişirmek': 'Cooking',
  };

  static const Map<String, String> _enToTrHabits = {
    'Running': 'Koşu Yapmak',
    'Go for a Walk': 'Yürüyüşe Çıkmak',
    'Read a Book': 'Kitap Okumak',
    'Daily Journaling': 'Günlük Yazmak',
    'Drawing / Painting': 'Resim / Boyama',
    'Knitting / Crafting': 'Örgü Örmek',
    'Meditation': 'Meditasyon Yapmak',
    'Drink 2L Water': '2 Litre Su İçmek',
    'Wake Up Early': 'Erken Uyanmak',
    'Guitar / Music Practice': 'Gitar / Müzik Pratiği',
    'Working Out': 'Spor Yapmak',
    'Walking': 'Yürüyüş',
    'Reading': 'Kitap Okuma',
    'Drink Water': 'Su İçmek',
    'Studying': 'Ders Çalışmak',
    'Coding / Development': 'Yazılım / Kodlama',
    'Language Practice': 'Yabancı Dil',
    'Yoga': 'Yoga',
    'Swimming': 'Yüzme',
    'Cycling': 'Bisiklet',
    'Knitting': 'Örgü',
    'Painting': 'Resim',
    'Cooking': 'Yemek Pişirmek',
  };

  static const Map<String, String> _trToEnCategories = {
    'Spor': 'Fitness',
    'Gelişim': 'Growth',
    'Farkındalık': 'Mindfulness',
    'Sanat': 'Art',
    'Hobi': 'Hobby',
    'Zihin': 'Mind',
    'Sağlık': 'Health',
    'Rutin': 'Routine',
    'Kişisel': 'Personal',
    'Genel': 'General',
  };

  static const Map<String, String> _enToTrCategories = {
    'Fitness': 'Spor',
    'Growth': 'Gelişim',
    'Mindfulness': 'Farkındalık',
    'Art': 'Sanat',
    'Hobby': 'Hobi',
    'Mind': 'Zihin',
    'Health': 'Sağlık',
    'Routine': 'Rutin',
    'Personal': 'Kişisel',
    'General': 'Genel',
  };

  static String translateHabitName(String name) {
    final lang = AppState.instance.language;
    if (lang == 'EN') {
      return _trToEnHabits[name] ?? name;
    } else {
      return _enToTrHabits[name] ?? name;
    }
  }

  static String translateCategory(String category) {
    final lang = AppState.instance.language;
    if (lang == 'EN') {
      return _trToEnCategories[category] ?? category;
    } else {
      return _enToTrCategories[category] ?? category;
    }
  }

  static String getLocalizedHabitName(Map<String, dynamic> habit) {
    final lang = AppState.instance.language;
    if (lang == 'EN') {
      final String? nameEn = habit['nameEn'];
      if (nameEn != null && nameEn.isNotEmpty && nameEn != habit['name']) {
        return nameEn;
      }
      final raw = habit['name'] ?? '';
      final instant = TranslationService.translateInstant(raw);
      if (instant != raw) return instant;
      return translateHabitName(raw);
    } else {
      final String? nameTr = habit['nameTr'];
      if (nameTr != null && nameTr.isNotEmpty) {
        return nameTr;
      }
      return habit['name'] ?? '';
    }
  }

  static String getLocalizedCategory(Map<String, dynamic> habit) {
    final lang = AppState.instance.language;
    if (lang == 'EN') {
      final String? catEn = habit['categoryEn'];
      if (catEn != null && catEn.isNotEmpty) {
        return catEn;
      }
      return translateCategory(habit['category'] ?? 'General');
    } else {
      final String? catTr = habit['categoryTr'];
      if (catTr != null && catTr.isNotEmpty) {
        return catTr;
      }
      return translateCategory(habit['category'] ?? 'Genel');
    }
  }
}
