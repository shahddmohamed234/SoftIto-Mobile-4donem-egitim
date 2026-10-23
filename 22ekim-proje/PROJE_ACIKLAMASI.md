# Go On: Motivasyon ve Alışkanlık Takip Uygulaması

> **"Küçük adımların gücünü asla küçümse. Her gün atılan bir adım, dağları aşmanı sağlar."**

---

## 1. Proje Özeti ve Amacı

**Go On**, kullanıcıların her gün faydalı alışkanlıklarını kaydedip, "streak" (seri) mantığıyla düzenli ve sağlıklı bir yaşam tarzı benimsemelerini sağlayan, **oyunlaştırılmış (gamified)** yeni nesil bir mobil alışkanlık takip (habit tracker) uygulamasıdır.

Uygulama, sıradan ve sıkıcı yapılacaklar listesi mantığından uzaklaşarak:
- Kullanıcıya her ekranda eşlik eden ve farklı pozlarıyla motive eden **3D kedi maskotu**,
- Belirli kilometre taşlarına ulaşıldığında açılan **özel başarı rozetleri**,
- Kesintisiz tam ay serilerini koruyan kullanıcılara sunulan **gerçek hayat indirim kuponları** (kitap, kahve, konser, sinema, spor giyim vb.)
ile sürekli yüksek bir motivasyon sunar.

---

## 2. Özel Uygulama İkonu (App Icon) ve Görsel Kimlik

Uygulamanın görsel kimliği, yumuşak pastel tonları ve sevimli 3D kil/render estetiğini bir araya getiren özel bir ikonla taçlandırılmıştır.

- **İkon Tasarımı:** Sıcak krem rengi zemin üzerinde sevimli, yuvarlak hatlı 3D kedi figürü, pudra/gül kurusu kalp ve adaçayı yeşili yaprak motifi.
- **Konumlar:**
  - Uygulama içi varlık: `assets/icons/app_icon.png`
  - iOS Simülatör ve Cihaz İkon Seti: `ios/Runner/Assets.xcassets/AppIcon.appiconset/` altındaki tüm çözünürlükler (20x20'den 1024x1024'e kadar) otomatik oluşturulmuştur.

### Renk Paleti (Material 3 - Açık Pastel & Sakin Gece Koyu Tema)
Uygulamada hem gündüz hem gece kullanımına uygun iki zengin tema bulunmaktadır:
- **Açık Pastel Tema:**
  - Zemin (Sıcak Kum / Krem): `#F9F6F0`
  - Ana Vurgu (Adaçayı Yeşili): `#9DB2A1` (Butonlar, onay işaretleri)
  - Streak Kalpleri (Pudra / Gül Kurusu): `#DDA7A5`
  - Rozet ve Kuponlar (Mat Lavanta): `#B5A8CB`
  - Metinler (Koyu Antrasit): `#3A3A3A`
  - Kartlar ve Yüzeyler: `#FFFFFF` ve `#F1EDE6`
- **Sakin Gece (Koyu Tema):**
  - Zemin (Koyu Kömür): `#191A20`
  - Kartlar ve Yüzeyler: `#23242D` ve `#2C2E38`
  - Kenarlıklar: `#373A47`
  - Metinler: `#EDE9E3` (Açık Krem) ve `#A6A4A0` (Muted)
  - Vurgular: Yumuşak Adaçayı `#AEC4B2` ve Gül Kurusu `#E8B6B4`

---

## 3. 3D Kedi Maskotları (Lottie Canlı Vektörel Animasyonlar)

Uygulama ilk açıldığında veya profil ekranından istendiğinde 4 farklı kedi karakterinden biri seçilebilir:

1. **Pamuk (`cat_pamuk.json` / `cat_pamuk.png`):** Sakin, şefkatli ve huzur dolu beyaz tüy yumağı.
2. **Tarçın (`cat_tarcin.json` / `cat_tarcin.png`):** Enerjik, neşeli ve durdurulamaz sarman kedi.
3. **Duman (`cat_duman.json` / `cat_duman.png`):** Derin düşünen, bilge ve huzurlu gri kedi.
4. **Zeytin (`cat_zeytin.json` / `cat_zeytin.png`):** Meraklı, oyuncu ve lavanta fiyonklu smokin kedi.

> **Global Maskot Layout:** Seçilen kedi, `BaseLayoutWithCat` bileşeni sayesinde `lottie: ^3.6.1` ile her sayfanın sağ alt köşesinde sürekli nefes alan, süzülen (`idle`) ve tıklandığında neşeyle zıplayan (`tap bounce`) gerçek vektörel karakter olarak kullanıcıya eşlik eder. Konuşma balonu 4.5 saniyede otomatik kaybolarak arkadaki içerikleri kapatmaz.

---

## 4. Uygulama Ekranları ve Özellikleri (9 Ana Ekran)

### 1. Giriş / Kayıt Ekranı (`login_view.dart`)
- Kaydı olan kullanıcılar için e-posta ve şifre ile hızlı giriş.
- Yeni kullanıcılar için Ad, Soyad, Doğum Tarihi, E-posta, Şifre ve Şifre Tekrar alanlarıyla kayıt formu.
- Başarılı kaydın hemen ardından kullanıcıyı Maskot Seçim ekranına yönlendirir.

### 2. Maskot Seçim Ekranı (`mascot_selection_view.dart`)
- 4 farklı 3D kedinin görselleri, kişilik özellikleri ve kullanıcıya özel selamlama mesajları listelenir.
- Kullanıcı dilediği kediyi seçip onaylayarak ana uygulamaya geçer.

### 3. Ana Sayfa - "Bugün Neler Yaptın?" (`home_view.dart`)
- **Tarih Rozeti:** Sayfa başında canlı takvim ikonu ve geçerli tarih (TR: `23 Ekim Cuma` / EN: `Friday, 23 Oct`).
- **Kalpli Streak Sayacı:** Sağ üst köşede pudra/gül kurusu kalp içinde mevcut kesintisiz gün serisi.
- **Alışkanlık Ekleme Formu:** Başlık, açıklama ve emoji seçimiyle anında yeni alışkanlık kaydetme. Yeni eklenen alışkanlık doğrudan tamamlanmış olarak sayılır ve seriyi anında artırır.
- **Hazır Popüler Öneriler Modalı (`DraggableScrollableSheet`):** Koşu, Yürüyüş, Kitap Okuma, Meditasyon, 2 Litre Su, Erken Uyanma gibi önerilerden tek tıkla ekleme.
- **Günün Alışkanlıkları ve Günlük Sıfırlanma:** Gece yarısı geçildiğinde dünün alışkanlıkları otomatik olarak yeni günde yapılmamışa döner. Tamamlanan alışkanlıklarda üzeri çizili yazı yerine temiz yeşil onay kutusu (`check_circle`) yer alır. İki yönlü dil desteği ile Türkçe eklenen alışkanlıklar İngilizceye geçildiğinde otomatik çevrilir.

### 4. Alışkanlık İstatistikleri (`statistics_view.dart`)
- Tüm alışkanlıkların emojili listesi ve toplam yapılma sayıları (`totalCount`).
- **"En Çok Yapılan Alışkanlık"** altın yıldızlı özel vitrin kartı.

### 5. Aylık Takvim ve Streak Ekranı (`calendar_view.dart` & `calendar_day_widget.dart`)
- Aylık ızgara takvim görünümü.
- Görevlerin başarıyla yapıldığı günlerde pudra kalp ikonu (`#DDA7A5`), diğer günlerde ise standart gün numarası gösterilir.
- Ay değiştirme navigasyonu ve toplam seri özeti.

### 6. Başarı Rozetleri (`rewards_view.dart` & `reward_badge_widget.dart`)
- "İlk Adım", "3 Günlük Işıltı", "Kitap Kurdu Kedicik", "Erken Kalkan Pati", "Su Şampiyonu", "Efsanevi Seri" gibi rozetler.
- **Şeffaflık Kuralı:** Kazanılmış rozetler tam renkli (`opacity: 1.0`), kilitli rozetler ise soluk (`opacity: 0.3`) görünür.

### 7. Günün Mesajı / Motivasyon (`motivation_view.dart`)
- Çiçek ve doğa motifleriyle süslenmiş özel kart.
- Her gün değişen veya butona basıldığında yenilenen derin motivasyon sözleri ve yazar/etiket bilgisi.
- Günlük alışkanlık ipuçları.

### 8. Ödül ve Kupon Sayfası (`rewards_view.dart`)
- Kesintisiz serileri sürdüren kullanıcılara özel gerçek dünya indirim kuponları (Kitap, Kahve, Sinema, Decathlon Spor Giyim, Konser).
- Açılan kuponlarda indirim kodu ve tek dokunuşla panoya kopyalama özelliği (`Clipboard`). Kilitli kuponlar şeffaf ve kilit ikonlu.

### 9. Ayarlar ve Profil (`profile_view.dart`)
- Kullanıcı adı, soyadı, e-posta bilgisi.
- Mevcut maskotu görüntüleme ve tek tıkla maskot değiştirme akışı.
- Dil seçeneği (TR / EN) ve Tema seçeneği (Açık Pastel / Sakin Gece).
- Sıkça Sorulan Sorular (SSS) akordeon menüsü.
- Onay pencereli Çıkış Yap butonu.

---

## 5. Mimari Yapı (Feature-Based Clean Architecture)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # Sabitler, maskotlar, öneriler, sözler
│   ├── presentation/
│   │   └── layouts/
│   │       └── base_layout_with_cat.dart # Global animasyonlu maskot wrapper'ı
│   ├── state/
│   │   └── app_state.dart              # Yerel reaktif durum yönetimi (ChangeNotifier)
│   ├── theme/
│   │   └── app_theme.dart              # Material 3 Pastel renk ve tema sistemi
│   └── utils/
│       └── json_storage_service.dart   # Yerel JSON dosya depolama servisi
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── login_view.dart         # Giriş ve kayıt ekranı
│   │       └── mascot_selection_view.dart # 4 kedi arasından maskot seçimi
│   ├── calendar/
│   │   └── presentation/
│   │       ├── calendar_view.dart      # Aylık takvim ekranı
│   │       └── widgets/
│   │           └── calendar_day_widget.dart # Kalpli gün kutucuğu
│   ├── home/
│   │   └── presentation/
│   │       └── home_view.dart          # Ana sayfa ve alışkanlık formu
│   ├── motivation/
│   │   └── presentation/
│   │       └── motivation_view.dart    # Çiçekli motivasyon sözleri
│   ├── navigation/
│   │   └── presentation/
│   │       └── app_navigation_scaffold.dart # Alt navigasyon çubuğu
│   ├── profile/
│   │   └── presentation/
│   │       └── profile_view.dart       # Profil, ayarlar ve SSS
│   ├── rewards/
│   │   └── presentation/
│   │       ├── rewards_view.dart       # Rozet ve kupon listesi
│   │       └── widgets/
│   │           └── reward_badge_widget.dart # Opaklık mantıklı rozet kartı
│   └── statistics/
│       └── presentation/
│           └── statistics_view.dart    # Sayaçlar ve en çok yapılan alışkanlık
└── main.dart                           # Uygulama başlangıcı ve Auth Gate
```

---

## 6. Veri Modeli ve Yerel JSON Saklama

Uygulamada harici backend veya internet bağımlılığı bulunmamaktadır. Tüm veriler `path_provider` ile cihazın yerel belgeler dizininde JSON dosyaları halinde saklanır:
- `user.json`: Kullanıcı adı, e-posta, seçilen kedi kimliği, dil ve tema tercihleri.
- `habits.json`: Kullanıcının eklediği alışkanlıklar, emojiler, kategoriler, yapılma sayaçları ve bugünkü durum.
- `streaks.json`: Kalp kazanılan tüm geçmiş tarihler (`YYYY-MM-DD`) ve güncel seri sayısı.
- `badges_and_coupons.json`: Kilitli/açılmış başarı rozetleri ve indirim kodları.

---

## 7. Kod Kalite Standartları ve Doğrulama

Proje, dokümandaki katı "Kırmızı Çizgiler" kurallarına %100 sadık kalınarak geliştirilmiştir:
- [x] **Ağır setState Yasağı:** State güncellemeleri `AppState` (ChangeNotifier / ListenableBuilder) üzerinden yönetilmektedir.
- [x] **Build Metodu Boyut Limiti:** Tüm `build` metotları 40 satırın altındadır; alt bileşenler modüler metotlara parçalanmıştır.
- [x] **Inline Ternary (? :) Yerine Standart if/else:** Rozet opaklığı, takvim günleri ve form durumlarında standart ve temiz `if/else` blokları kullanılmıştır.
- [x] **Merkezi Tema Desteği:** Renkler bileşen içerisine gömülmemiş, `app_theme.dart` ve `Theme.of(context)` üzerinden türetilmiştir.
- [x] **Const Kullanımı:** Tüm statik widget'larda `const` tanımlamaları eksiksizdir.
- [x] **Statik Analiz (`flutter analyze`):** 0 hata, 0 uyarı ile tamamlanmıştır.
- [x] **Birim & Widget Testi (`flutter test`):** Tüm testler başarıyla geçmiştir.

---

## 8. Çalıştırma Komutları

Uygulamayı dilediğiniz zaman terminalden aşağıdaki komutlarla test edebilir ve çalıştırabilirsiniz:

```bash
# Kod analizi (0 hata ve 0 uyarı garantisi)
flutter analyze

# Birim ve Widget testleri
flutter test

# iOS Simülatörde çalıştırma
flutter run -d D69E64F0-6832-405A-ACE9-FD4E95A5D40D
```
