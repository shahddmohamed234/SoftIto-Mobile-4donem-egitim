# Dijital Günlük Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan ajan (Antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen kod satırı buradaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojileri
- Uygulama adı: Anı Defteri (Kullanıcıların günlük düşüncelerini, duygu durumlarını (mood) ve anılarını kaydedebileceği, etiketleyebileceği dijital günlük uygulaması)
- Uygulama iconu: Telefonun ana ekranında olacak logo; minimal bir tüy kalem ve yaprak veya sade bir not defteri silüeti.
- Hedef Platformları: iOS ve Android öncelikli, ardından web ve masaüstü platformları.
- Flutter SDK: 3.29.0
- Dart SDK: 3.0.0
- Tasarım dili: Material 3, Çift Tema Desteği:
  - Koyu Tema: Gece okuma/yazma paleti (Koyu Gri/Mürekkep Siyahı & Pastel Vurgular)
  - Açık Tema: Kağıt dokusu paleti (Kırık Beyaz, Sıcak Bej & Soft Soft Kırmızı)
  - Dinamik Geçiş: Kullanıcı uygulama içerisinden anlık olarak Açık/Koyu mod arasında geçiş yapabilmelidir. Tema durumu ValueNotifier<ThemeMode> ile reaktif yönetilecektir.
- Takvim Entegrasyonu: Kullanıcı ekran üzerindeki takvimden gün seçebilmeli, seçilen tarihe ait günlükleri filtreleyebilmeli ve doğrudan seçtiği o güne anı kaydedebilmelidir. Seçili tarih durumu ValueNotifier<DateTime> ile reaktif yönetilecektir.

---

## 2. Mimari Yapı: Özellik Bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

lib/
  core/
      constants/app_colors.dart
      theme/app_theme.dart
        
  features/
      diary/
          controllers/
          models/
          views/
          widgets/
      mood_tracker/
          controllers/
          models/
          views/
          widgets/
      settings/
          controllers/
          models/
          views/
          widgets/

  main.dart        

(main.dart sadece uygulama başlatma ve tema bölümlerini içerecektir)

### 3. Kırmızı Çizgiler ve Kod Kalite Standartları
1 - State Yönetim Standartları:
Sayfa düzeyinde ağır setState KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları, textfield focus durumları vb.) StatefulWidget kabul edilir. Ana veri akışı ValueNotifier ile yönetilecektir.

2 - UI ve Performans Kuralları:
Statik tüm widget'larda const zorunludur.
Renk ve metin stilleri kesinlikle tema dosyasında yazılacaktır.
Büyük build metotları yasaktır. 40 satırı geçen build metotları özel widget'lara (widgets/ klasörüne) parçalanacaktır.

3 - Yasaklı Paketler:
Projeye onay almadan harici ağır state paketleri (GetX, Bloc, Riverpod vb.) EKLENMEYECEKTİR. 
Dart'ın ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.

## 4. Geliştirme ve Analiz (0 Uyarı ve 0 Hata Şart):
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

- Statik kod analizi (0 uyarı ve 0 hata şart):
flutter analyze

- Birim ve widget testi:
flutter test

- Projeyi çalıştırma:
flutter run

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

Açıklamalar: Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
Değişiklik Sunumları: Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
Dosya yolları: Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
Doğrulama: Kod yazdıktan sonra kullanıcıya "Şimdi flutter analyze ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.