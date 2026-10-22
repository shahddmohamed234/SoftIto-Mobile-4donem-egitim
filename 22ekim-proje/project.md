# Go On: Motivasyon ve Alışkanlık Takip Uygulaması

## 1. Proje Özeti ve Amacı
"Go On", kullanıcıların her gün faydalı alışkanlıklarını kaydedip, "streak" (seri) mantığıyla düzenli bir yaşam tarzı benimsemelerini sağlayan, oyunlaştırılmış (gamified) bir alışkanlık takip (habit tracker) uygulamasıdır. 
Temel amaç: Kullanıcıyı sıkıcı listelerden kurtararak; 3D animasyonlu bir kedi figürü (her sayfada farklı bir pozu ile ), başarı rozetleri ve gerçek hayatta kullanılabilecek indirim kuponlarıyla motive etmektir.

## 2. Teknik Altyapı ve Sürüm Gereksinimleri
- Flutter SDK: 3.29.0
- Dart SDK: 3.0.0
- Tasarım Dili: Material 3
- Veri Yönetimi: Backend veya dış API kullanılmayacaktır. Tüm veriler (alışkanlıklar, streak günleri, rozetler, kuponlar) cihazda yerel JSON dosyaları (path_provider ve dart:convert) üzerinden yönetilecektir.
- Proje Yönetimi: Çevik (agile) ve iteratif bir geliştirme süreci benimsenecektir.



## 3. Temel Özellikler ve Ekran Hiyerarşisi
Uygulama toplam 9 ana ekrandan oluşmaktadır:

1. Giriş / Kayıt Sayfası:
- Uygulama açıldığında kullanıcıyı karşılayan ekran
- Kullanıcı kayıt olmamışsa kayıt ekranını, kayıt olmuşsa ana sayfayı gösterir. 
- Ad soyad mail eposta adresi şifre alanları bulunur hesabı varsa.
- Kaydı olmayanlar kayıt olurken ad soyad doğum tarihi mail adresi şifre gir tekrar şifre gir ve kayıt ol olacak
 
2. Maskot Seçimi:
- Kullanıcı, uygulamada kendisine yoldaşlık edecek 4 farklı 3D kedi figüründen birini seçer.



3. Ana Sayfa (Bugün Neler Yaptın?):

   - Günlük alışkanlık ekleme formu (Başlık, açıklama ve kaydet butonu).

   - Önceden tanımlanmış hazır öneri listesi (Koşu, Yürüyüş, Kitap Okuma, Yazı Yazma, Boyama, Örgü vb.).

   - Ekranın bir köşesinde kullanıcıyı merakla bekleyen/izleyen 3D kedi figürü.

   - Sayfanın sağ üst köşesinde kalp içinde streak sayısı olacak ve sayı görev yapıldıkça gün olara 1 artacak ve o gün görev yapılmazsa 0 lanacak. 



4. Alışkanlık İstatistikleri:

   - Eklenen alışkanlıkların bir listesi.

   - Her alışkanlığın sol tarafında onu temsil eden bir emoji ve sağında bugüne kadar toplam "kaç kez yapıldığı" bilgisi.

   - "En çok yapılan alışkanlık" vurgusu.



5. Aylık Takvim ve Streak (Seri) Ekranı:

   - Geleneksel takvim görünümü.

   - Alışkanlıkların tamamlandığı her gün için takvim karesine "Kalp" şeklinde streak ikonu basılır.



6. Başarı Rozetleri:

   - Farklı görevler (örn: 7 gün üst üste kitap okuma) tamamlandıkça açılan, her birinin özel ismi olan rozetler.

   - UI Kuralı: Kazanılan rozetler belirgin ve tam renkli, henüz kazanılmayanlar ise şeffaf (opacity: 0.3) görünecektir.



7. Günün Mesajı (Motivasyon):

   - Her gün değişen, görsel detaylarla (çiçek vb.) süslenmiş, düz yazıdan uzak motivasyon sözleri ekranı.



8. Ödül ve Kupon Sayfası:

   - Kesintisiz "Tam Ay Streak" (örneğin tüm Ocak ayı boyunca hedefleri tutturma) yapan kullanıcılara verilen gerçek ödüller.

   - Kıyafet, yemek, konser, sinema gibi indirim kodları.

   - UI Kuralı: Kazanılan aylar tam renkli ve belirgin; şartsız/kazanılmayan aylar şeffaf ve kodsuz görünecektir.



9. Ayarlar ve Profil:

   - Ad, Soyad, Mail bilgileri.

   - Dil seçeneği (TR/EN), Tema seçeneği, SSS (Sıkça Sorulan Sorular) ve Çıkış Yap butonu.



## 4. Kullanıcı Arayüzü (UI), Renk Paleti ve Kedi Mantığı

Göz yormayan, sakinleştirici ve motive edici pastel tonlar kullanılacaktır. Parlak/fosforlu renkler yasaktır.

- Zemin Rengi (Sıcak Kum/Krem): #F9F6F0

- Ana Vurgu (Adaçayı Yeşili): #9DB2A1 (Butonlar, progress barlar)

- Streak Kalpleri (Pudra/Gül Kurusu): #DDA7A5

- Rozet ve Kuponlar (Mat Lavanta): #B5A8CB

- Metinler (Koyu Antrasit): #3A3A3A

- Kedi Mantığı: Kullanıcının seçtiği tek bir kedi vardır, ancak bu kedi her sayfada içeriğe uygun farklı bir pozisyonda (örneğin takvimde uyurken, ana sayfada izlerken) yer alacaktır.



## 5. Veri Modeli Tasarımı (JSON Yapısı)

- user.json: Kedi seçimi, ad, soyad, dil, tema.

- habits.json: id, name, emoji, category, totalCount.

- streaks.json: date (YYYY-MM-DD formatında kalp atılacak günler).

- badges_and_coupons.json: id, type (badge/coupon), title, isUnlocked.



## 6. Mimari Yapısı (Clean Architecture)

Kodlar feature-based (özellik bazlı) olarak ayrılacaktır:



lib/

  core/

        constants/              # Sabitler (Öneri listeleri, kedi animasyon yolları)

        theme/                  # Pastel Material 3 teması

        utils/                  # JSON dosya servisleri

  features/

        auth/                   # Giriş, kayıt, 4 kedi arasından seçim

        home/                   # Ana sayfa (Alışkanlık ekleme ve öneriler)

        statistics/             # Alışkanlık liste ve sayaçları (emojili)

        calendar/               # Kalpli aylık takvim streakleri

        rewards/                # Rozetler ve Kuponlar (Şeffaflık mantığıyla)

        motivation/             # Günün görsel motivasyon mesajları

        profile/                # Profil, SSS, ayarlar

  main.dart



## 7. Kırmızı Çizgiler ve Kod Kalite Standartları

Projenin her aşamasında aşağıdaki katı kurallara uyulacaktır:



1. State Yönetimi:

   - Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.

   - Sadece yerel arayüz durumunu yöneten (animasyon vb.) durumlarda StatefulWidget kabul edilir.

2. UI ve Performans:

   - Statik tüm widget'larda `const` zorunludur.

   - Renk ve metin stilleri kesinlikle sınıf içine yazılmayacak, `ThemeData` dosyasından çekilecektir.

   - Büyük `build` metotları yasaktır. 40 satırı geçen build metotları parçalanıp özel/alt widget'lara çıkarılacaktır.

   - Inline tek satırlık karmaşık `if` yapıları yerine, standart okunaklı `if/else` blokları tercih edilecektir.

3. Yasaklı Paketler:

   - Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR. Dart/Flutter yerel çekirdek API'leri esastır.



## 8. Geliştirme ve Analiz Süreçleri (0 Uyarı ve 0 Hata Şartı)

Yazılan her koddan sonra projenin şu komutları başarıyla (0 hata, 0 uyarı) geçtiği teyit edilmelidir:

- Statik Kod Analizi: `flutter analyze`

- Birim ve Widget Testi: `flutter test`

- Projeyi Çalıştırma: `flutter run`



## 9. Ajanın Çıktı ve Yanıt Verme Standartları

- Açıklamalar: Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.

- Değişiklik Sunumları (Diff): Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.

- Dosya Yolları: Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link (örn: [home_view.dart](lib/features/home/presentation/home_view.dart)) ver.

- Doğrulama: Kod yazıldıktan sonra kullanıcıya mutlak suretle "Şimdi flutter analyze komutu ile kontrol edebilirsin" şeklinde doğrulama yönergeleri sunulacaktır.