# Dijital Günlük (Anı Defteri) - Proje ve Kurulum Rehberi

Bu döküman, **19 Ekim Ödevi** kapsamında geliştirilen **Anı Defteri (Dijital Günlük)** uygulamasının kurulumunu, mimarisini, ikon tasarımını, karşılaşılan sorunları ve Android Studio simülatöründe çalıştırma aşamalarını adım adım açıklamaktadır.

---

## 1. Proje Özeti ve Hedefleri

* **Uygulama Adı:** Anı Defteri (Dijital Günlük)
* **Paket/Proje Adı:** `dijital_gunluk` (`com.softito.dijitalgunluk.dijital_gunluk`)
* **Tasarım Dili:** Google Material 3
* **Çift Tema Desteği:** 
  * **Açık Tema:** Kağıt Dokusu (Kırık Beyaz `#FBF9F5`, Sıcak Bej `#FFFDF9`, Soft Terracotta Kırmızı `#B84A39`)
  * **Koyu Tema:** Gece Okuma (Mürekkep Siyahı `#14161B`, Koyu Gri `#1C1F26`, Pastel Vurgular `#E5887B`)
  * **Dinamik Geçiş:** `ValueNotifier<ThemeMode>` ile anlık, reaktif tema değişimi.
* **Takvim ve Gün Bazlı Günlük:** Kullanıcı ekran üzerindeki takvimden dilediği günü seçerek o güne ait anıları filtreleyebilir ve yeni anıları seçtiği tarihe doğrudan kaydedebilir. Tarih seçimi `ValueNotifier<DateTime>` ile reaktif yönetilir.
* **Uygulama İkonu:** Minimal tüy kalem ve yaprak silüeti.
* **Kalite Kriterleri:** 
  * Sayfa düzeyinde ağır `setState` kullanılmaması
  * `ValueNotifier` & `ValueListenableBuilder` reaktif state akışı
  * Dış state paketleri (GetX, Bloc, Riverpod) olmadan saf Flutter çekirdeği
  * Statik widget'larda `const` zorunluluğu
  * 40 satırı geçen `build` metotlarının atomik widget'lara parçalanması
  * `flutter analyze` çıktısında **0 hata, 0 uyarı** şartı
  * `flutter test` test paketinin hatasız geçmesi

---

## 2. Mimari Yapı (Feature-First)

Proje dizini `project.md` ve `SKILLS.md` yönergeleri uyarınca özellik bazlı (feature-based) olarak yapılandırılmıştır:

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_colors.dart          # Kağıt ve gece paletleri, duygu renkleri
│   └── theme/
│       └── app_theme.dart           # Material 3 Açık ve Koyu Tema yapılandırması
├── features/
│   ├── diary/                       # Günlük ve Anı Modülü
│   │   ├── controllers/
│   │   │   └── diary_controller.dart
│   │   ├── models/
│   │   │   └── diary_model.dart
│   │   ├── views/
│   │   │   └── diary_screen.dart
│   │   └── widgets/
│   │       ├── diary_card.dart
│   │       ├── diary_editor_sheet.dart
│   │       └── diary_empty_view.dart
│   ├── mood_tracker/                # Duygu Durum Takip Modülü
│   │   ├── controllers/
│   │   │   └── mood_tracker_controller.dart
│   │   ├── models/
│   │   │   └── mood_entry_model.dart
│   │   ├── views/
│   │   │   └── mood_tracker_screen.dart
│   │   └── widgets/
│   │       ├── mood_card.dart
│   │       ├── mood_selector_card.dart
│   │       └── mood_stats_card.dart
│   └── settings/                    # Ayarlar ve Tema Yönetim Modülü
│       ├── controllers/
│       │   └── settings_controller.dart
│       ├── models/
│       │   └── settings_model.dart
│       ├── views/
│       │   └── settings_screen.dart
│       └── widgets/
│           ├── about_card.dart
│           └── theme_switch_card.dart
└── main.dart                        # Sadece başlatma, reaktif tema dinleyicisi ve navigasyon
```

---

## 3. Adım Adım Geliştirme Süreci

### Adım 1: Projenin Başlatılması
`19ekim-odev/` dizini altında Flutter projesi komut satırı ile oluşturuldu:
```bash
flutter create --org com.softito.dijitalgunluk dijital_gunluk
```

### Adım 2: Renk ve Tema Sisteminin Kurulması
* [app_colors.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/core/constants/app_colors.dart) dosyası içinde açık kağıt tonları, koyu mürekkep tonları ve 6 temel ruh haline (Mutlu, Huzurlu, Enerjik, Düşünceli, Üzgün, Yorgun) ait özel renkler tanımlandı.
* [app_theme.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/core/theme/app_theme.dart) dosyasında `lightTheme` ve `darkTheme` oluşturularak `useMaterial3: true`, özel kart sınırları, başlık stilleri ve navigasyon temaları ayarlandı.

### Adım 3: Günlük (Diary) Modülünün Geliştirilmesi
* **Model:** [diary_model.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/diary/models/diary_model.dart) sınıfı `@immutable` olarak tanımlandı. `copyWith`, `fromJson` ve `toJson` metotları hazırlandı; anılara etiket (`tags`) desteği eklendi.
* **Controller:** [diary_controller.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/diary/controllers/diary_controller.dart) saf Dart sınıfı olarak yazıldı. `ValueNotifier<List<DiaryEntry>>` kullanılarak `addEntry`, `updateEntry` ve `deleteEntry` işlevleri referans yenileme esasıyla uygulandı.
* **Görünüm & Bileşenler:** [diary_screen.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/diary/views/diary_screen.dart) içinde `ValueListenableBuilder` ile izole dinleme sağlandı. Kartlar [diary_card.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/diary/widgets/diary_card.dart), boş durum [diary_empty_view.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/diary/widgets/diary_empty_view.dart) ve anı ekleme/düzenleme bottom sheet formu [diary_editor_sheet.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/diary/widgets/diary_editor_sheet.dart) modüllerine ayrılarak 40 satır kuralına sadık kalındı.

### Adım 4: Duygu Durum (Mood Tracker) Modülünün Geliştirilmesi
* **Model:** [mood_entry_model.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/mood_tracker/models/mood_entry_model.dart)
* **Controller:** [mood_tracker_controller.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/mood_tracker/controllers/mood_tracker_controller.dart) duyguların listesini ve her bir duygunun toplam sayısını hesaplayan `getMoodCounts()` fonksiyonunu yönetir.
* **Görünüm:** [mood_tracker_screen.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/mood_tracker/views/mood_tracker_screen.dart)
* **Alt Widget'lar:** Hızlı duygu seçimi için [mood_selector_card.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/mood_tracker/widgets/mood_selector_card.dart), oran çubukları için [mood_stats_card.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/mood_tracker/widgets/mood_stats_card.dart) ve liste kartları için [mood_card.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/mood_tracker/widgets/mood_card.dart).

### Adım 5: Ayarlar ve Dinamik Tema Geçişi
* **Controller:** [settings_controller.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/settings/controllers/settings_controller.dart) içerisinde `ValueNotifier<ThemeMode> themeMode` tanımlandı.
* **Görünüm:** [settings_screen.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/settings/views/settings_screen.dart)
* [theme_switch_card.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/settings/widgets/theme_switch_card.dart) widget'ı üzerinden kullanıcı hem Switch butonuyla hem de Açık/Koyu kartlarına dokunarak anlık tema geçişi yapabilir.
* [about_card.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/features/settings/widgets/about_card.dart) ile uygulama logosu ve sürüm bilgileri gösterilmektedir.

### Adım 6: Uygulama İkonu ve Android Başlatıcı Yapılandırması
1. Minimal tüy kalem ve yaprak silüeti içeren özel logo üretildi.
2. Varlık dizinine `assets/icon/app_icon.png` (512x512) kaydedildi ve `pubspec.yaml`'a eklendi.
3. Android başlatıcı ikonları için bicubic enterpolasyon ile `mipmap` çözünürlükleri üretilerek yerleştirildi:
   * `mipmap-mdpi`: 48x48
   * `mipmap-hdpi`: 72x72
   * `mipmap-xhdpi`: 96x96
   * `mipmap-xxhdpi`: 144x144
   * `mipmap-xxxhdpi`: 192x192
4. [AndroidManifest.xml](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/android/app/src/main/AndroidManifest.xml) dosyasında uygulama etiketi `android:label="Anı Defteri"` olarak ayarlandı.

### Adım 7: Giriş Noktası ve Navigasyon
* [main.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/lib/main.dart) sadece `WidgetsFlutterBinding`, kontrolcülerin başlatılması, `ValueListenableBuilder<ThemeMode>` dinleyicisi ve Material 3 `NavigationBar` tab yapısını barındıracak şekilde sade tutuldu.

---

## 4. Karşılaşılan Sorunlar ve Çözümleri

Geliştirme ve statik analiz sürecinde tespit edilen problemler ve çözümleri:

1. **CardTheme Tür Uyuşmazlığı (Flutter 3.47 Güncellemesi):**
   * *Sorun:* `ThemeData.cardTheme` parametresi yeni Flutter sürümünde `CardThemeData?` beklemekteyken `CardTheme` widget sınıfı verildiği için tip hatası verdi.
   * *Çözüm:* `AppTheme` içerisindeki `CardTheme(...)` tanımları `CardThemeData(...)` olarak güncellendi.

2. **Linter 'unnecessary_underscores' Uyarısı:**
   * *Sorun:* ListView ve Image builder'larında birden fazla alt tire kullanımı (`(_, __)` veya `(_, __, ___)`) `unnecessary_underscores` linter kuralına takıldı.
   * *Çözüm:* Parametreler `(context, index)` ve `(context, error, stackTrace)` şeklinde açık ve temiz isimlendirildi.

3. **Android Simülatör Port & ADB Erişimi:**
   * *Sorun:* Sistem PATH üzerinde doğrudan `adb` tanımlı olmadığından terminal komutları ilk çağrıda bulunamadı.
   * *Çözüm:* Android SDK platform-tools dizinindeki doğrudan adb yolu (`C:\Users\Deneme\AppData\Local\Android\sdk\platform-tools\adb.exe`) kullanılarak simülatör portu (`emulator-5554`) ve süreçler eksiksiz yönetildi.

---

## 5. Doğrulama ve Çalıştırma Sonuçları

### 1. Statik Kod Analizi (`flutter analyze`)
```bash
flutter analyze
```
**Sonuç:** `No issues found! (0 error, 0 warning)`

### 2. Birim ve Widget Testleri (`flutter test`)
[widget_test.dart](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/dijital_gunluk/test/widget_test.dart) dosyasındaki tüm testler:
* `DiaryController Tests: Başlangıç anıları mevcut ve addEntry anı ekler` -> **GEÇTİ**
* `MoodTrackerController Tests: Duygu ekleme ve istatistik hesaplama doğru çalışır` -> **GEÇTİ**
* `SettingsController Tests: Tema değiştirme işlevi beklendiği gibi çalışır` -> **GEÇTİ**
* `Widget Tests: Uygulama açılır ve tablar arası geçiş yapılabilir` -> **GEÇTİ**

**Sonuç:** `00:01 +4: All tests passed!`

### 3. Android Studio Simülatöründe Çalıştırma (`flutter run`)
* Android Studio hazır cihazı olan **Pixel 8** (`emulator-5554`, Android 17 / API 37) ayağa kaldırıldı.
* `flutter run -d emulator-5554` komutu ile debug APK derlendi ve simülatöre yüklendi.
* Simülatör üzerinde şu işlevler canlı olarak test edilip onaylandı:
  1. **Uygulama İkonu & Başlatıcı:** Android ana ekranında ve uygulama menüsünde "Anı Defteri" logosunun ve adının doğru göründüğü doğrulandı.
  2. **Anı Listesi & Detaylar:** Varsayılan anıların, duygu rozetlerinin ve `#etiket` chiplerinin kağıt dokusu temasıyla kusursuz listelendiği görüldü.
  3. **Duygu Takibi:** Dağılım çubuklarının ve hızlı his kaydetme bileşeninin çalıştığı teyit edildi.
  4. **Dinamik Tema Geçişi:** Ayarlar sekmesinde Koyu Mod tetiklendiğinde uygulamanın gecikmesiz gece okuma/mürekkep paletine geçtiği doğrulandı.
