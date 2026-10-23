import 'dart:convert';
import 'dart:io';

class TranslationService {
  static final Map<String, String> _cache = {};

  static final Map<String, String> _dictionary = {
    // Habits, Verbs, Activities
    'sigara içmeme': 'Quit Smoking',
    'sigara içmemek': 'No Smoking',
    'sigara': 'Smoking',
    'tırmanış': 'Climbing',
    'tırmanma': 'Climbing',
    'yüzme': 'Swimming',
    'yüzmek': 'Swimming',
    'koşu': 'Running',
    'koşmak': 'Running',
    'koşu yapmak': 'Running',
    'yürüyüş': 'Walking',
    'yürümek': 'Walking',
    'yürüyüşe çıkmak': 'Go for a Walk',
    'kitap okumak': 'Reading',
    'kitap okuma': 'Reading',
    'kitap': 'Book',
    'okumak': 'Reading',
    'su içmek': 'Drink Water',
    '2 litre su içmek': 'Drink 2L Water',
    'su': 'Water',
    'erken kalkmak': 'Wake Up Early',
    'erken uyanmak': 'Wake Up Early',
    'erken yatmak': 'Sleep Early',
    'uyku': 'Sleep',
    'uyu': 'Sleep',
    'meditasyon': 'Meditation',
    'meditasyon yapmak': 'Meditation',
    'yoga': 'Yoga',
    'yoga yapmak': 'Yoga Practice',
    'spor': 'Workout',
    'spor yapmak': 'Working Out',
    'antrenman': 'Training',
    'fitness': 'Fitness',
    'şınav': 'Push-ups',
    'şınav çekmek': 'Push-ups',
    'mekik': 'Sit-ups',
    'mekik çekmek': 'Sit-ups',
    'barfiks': 'Pull-ups',
    'esneme': 'Stretching',
    'streç': 'Stretching',
    'bisiklet': 'Cycling',
    'bisiklete binmek': 'Cycling',
    'kodlama': 'Coding',
    'yazılım': 'Software Development',
    'yazılım / kodlama': 'Coding / Development',
    'programlama': 'Programming',
    'ders çalışmak': 'Studying',
    'ders çalışma': 'Studying',
    'ders': 'Study',
    'ödev': 'Homework',
    'ödev yapmak': 'Do Homework',
    'yabancı dil': 'Language Practice',
    'ingilizce': 'English Practice',
    'ingilizce çalışmak': 'Study English',
    'almanca': 'German Practice',
    'ispanyolca': 'Spanish Practice',
    'fransızca': 'French Practice',
    'resim': 'Painting',
    'resim yapmak': 'Painting',
    'resim / boyama': 'Drawing / Painting',
    'çizim': 'Drawing',
    'çizim yapmak': 'Drawing',
    'örgü': 'Knitting',
    'örgü örmek': 'Knitting',
    'el işi': 'Crafting',
    'müzik': 'Music',
    'müzik dinlemek': 'Listening to Music',
    'müzik pratiği': 'Music Practice',
    'gitar': 'Guitar Practice',
    'gitar çalmak': 'Guitar Practice',
    'gitar / müzik pratiği': 'Guitar / Music Practice',
    'piyano': 'Piano Practice',
    'piyano çalmak': 'Piano Practice',
    'keman': 'Violin Practice',
    'şarkı söylemek': 'Singing',
    'günlük': 'Journaling',
    'günlük yazmak': 'Daily Journaling',
    'yazı yazmak': 'Writing',
    'blog yazmak': 'Blog Writing',
    'temizlik': 'Cleaning',
    'ev temizliği': 'House Cleaning',
    'oda toplamak': 'Tidying Room',
    'bulaşık yıkamak': 'Wash Dishes',
    'çamaşır': 'Laundry',
    'yemek': 'Meal',
    'yemek pişirmek': 'Cooking',
    'yemek yapma': 'Cooking',
    'yemek yapmak': 'Cooking',
    'sağlıklı beslenme': 'Healthy Eating',
    'diyet': 'Dieting',
    'şekersiz': 'Sugar-free',
    'şeker yememek': 'No Sugar',
    'abur cubur yememek': 'No Junk Food',
    'kahve azaltma': 'Reduce Coffee',
    'kahve': 'Coffee',
    'çay': 'Tea',
    'yeşil çay': 'Green Tea',
    'meyve yemek': 'Eat Fruit',
    'sebze yemek': 'Eat Vegetables',
    'diş fırçalamak': 'Brushing Teeth',
    'diş ipi': 'Flossing',
    'vitamin': 'Take Vitamins',
    'ilaç': 'Take Medication',
    'cilt bakımı': 'Skincare',
    'nemlendirici': 'Moisturizer',
    'güneş kremi': 'Sunscreen',
    'duş almak': 'Take a Shower',
    'soğuk duş': 'Cold Shower',
    'nefes': 'Breathing',
    'nefes egzersizi': 'Breathing Exercise',
    'para biriktirmek': 'Saving Money',
    'para biriktirme': 'Saving Money',
    'bütçe': 'Budgeting',
    'yatırım': 'Investing',
    'tasarruf': 'Saving',
    'sosyal medya detoksu': 'Social Media Detox',
    'ekran süresini azaltmak': 'Reduce Screen Time',
    'telefon bırakma': 'Put Phone Down',
    'podcast dinlemek': 'Listen to Podcast',
    'belgesel izlemek': 'Watch Documentary',
    'çiçek sulamak': 'Water Plants',
    'bitki bakımı': 'Plant Care',
    'hayvan beslemek': 'Pet Care',
    'köpek gezdirmek': 'Walk the Dog',
    'kedi sevmek': 'Pet the Cat',
    'gülümsemek': 'Smile More',
    'şükretmek': 'Gratitude',
    'pozitif düşünmek': 'Positive Thinking',
    'arkadaşlarla vakit geçirmek': 'Time with Friends',
    'aile ile vakit geçirmek': 'Family Time',
    'dinlenmek': 'Rest & Relax',
  };

  /// Instant synchronous translation using dictionary and memory cache
  static String translateInstant(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;
    final lower = trimmed.toLowerCase();

    if (_cache.containsKey(lower)) return _cache[lower]!;
    if (_dictionary.containsKey(lower)) return _dictionary[lower]!;

    // Check partial phrases or words
    for (final entry in _dictionary.entries) {
      if (lower == entry.key) {
        return entry.value;
      }
    }
    return text;
  }

  /// Asynchronous translation that checks dictionary, cache, or queries translation API
  static Future<String> translateTrToEn(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;

    final lower = trimmed.toLowerCase();
    if (_cache.containsKey(lower)) {
      return _cache[lower]!;
    }
    if (_dictionary.containsKey(lower)) {
      return _dictionary[lower]!;
    }

    // Try online translation API (MyMemory)
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final encoded = Uri.encodeComponent(trimmed);
      final uri = Uri.parse('https://api.mymemory.translated.net/get?q=$encoded&langpair=tr|en');
      final request = await client.getUrl(uri).timeout(const Duration(seconds: 3));
      final response = await request.close().timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final json = jsonDecode(body) as Map<String, dynamic>;
        final responseData = json['responseData'] as Map<String, dynamic>?;
        if (responseData != null) {
          final translated = responseData['translatedText'] as String?;
          if (translated != null &&
              translated.isNotEmpty &&
              !translated.toLowerCase().contains('quota exceeded')) {
            final cleaned = _capitalizeWords(translated.trim());
            _cache[lower] = cleaned;
            client.close();
            return cleaned;
          }
        }
      }
      client.close();
    } catch (_) {
      // Ignore network errors and proceed to fallback
    }

    // Fallback: Word-by-word dictionary translation
    final words = lower.split(RegExp(r'\s+'));
    final translatedWords = <String>[];
    for (final w in words) {
      if (_dictionary.containsKey(w)) {
        translatedWords.add(_dictionary[w]!);
      } else {
        translatedWords.add(w);
      }
    }
    final result = _capitalizeWords(translatedWords.join(' '));
    _cache[lower] = result;
    return result;
  }

  static String _capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
