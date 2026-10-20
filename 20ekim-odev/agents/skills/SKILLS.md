---
name: easyrent-feature-scaffold
description: EasyRent araç kiralama projesinde feature bazlı (Data, Domain, Presentation) kod yazmak için gerekli klasör yapısını ve mimariyi oluşturur. API kullanılmadan yerel mock verilerle çalışır. Form validasyonları, Material 3 (Kırmızı/Mavi) tema uyumu, ValueNotifier reaktif state mimarisi, 40 satır build kuralı ve her kod bloğuna açıklama yorumu zorunluluğunu tanımlar.
---

# EasyRent Feature Scaffold (Kapsamlı Modüler Geliştirme İskeleti)

Bu yetenek, EasyRent projesinde yeni bir modül geliştirirken CLEAN UI, Reaktif State ve katı proje standartlarına tam uyum sağlamak için kullanılır. Ajan bu yönergelere KESİNLİKLE uymak zorundadır.

## 1. Temel Kurallar ve Kırmızı Çizgiler
1. **Mimari Yapı:** Kodlar asla tek dosyada toplanmaz. Her özellik `features/<feature_name>/` altında `data/`, `domain/`, ve `presentation/` katmanlarına ayrılmalıdır.
2. **API Yok Kuralı (ÖNEMLİ):** Projede harici API kullanılmayacaktır. Tüm `data/` katmanları sahte (mock) nesneler dönmeli, veri çekme işlemleri `Future.delayed` ile simüle edilmelidir.
3. **Zorunlu Açılış Girişi (Auth Gate):** Uygulama başlatıldığında kesinlikle Giriş (Login) ekranı gelmelidir. TCKN, Ehliyet ve SMS ("1234") doğrulaması yapılmadan ana ekrana geçilemez.
4. **40 Satır Kuralı:** Hiçbir `build` metodu 40 satırı geçemez. Büyük arayüzler `widgets/` klasörü altında atomik bileşenlere (`const` widget) parçalanmalıdır.
5. **State Yönetimi:** Ağır `setState` KULLANILAMAZ. Durum yönetimi için yalnızca `ValueNotifier` ve `ValueListenableBuilder` kullanılacaktır.
6. **Tema ve Renk Paleti:** Statik renk verilmesi yasaktır. Material Design 3 Dark/Light tema yönetimi kullanılacaktır. Tema paleti Kırmızı ve Mavi ağırlıklıdır; renkler `Theme.of(context)` üzerinden çekilmelidir.
7. **Kullanıcı Etkileşimi:** Tüm bilgi, uyarı ve hata mesajları için mutlaka Diyaloglar (Dialog) ve Bildirimler (SnackBar) kullanılmalıdır.
8. **Form Validasyonu:** Tüm giriş alanlarında Form Yönetimi ve Validasyonlar eksiksiz uygulanmalıdır.
9. **Açıklayıcı Yorum Satırları:** Kod dosyalarındaki her sınıf, fonksiyon ve önemli kod bloğu için ne işe yaradığını açıklayan net Türkçe yorum satırları eklenmelidir.

## 2. EasyRent Proje Modülleri ve İş Kuralları
- **Auth (Kimlik Doğrulama) Modülü:**
  - Login Ekranı: TCKN, Ad-Soyad, Doğum Tarihi, Ehliyet No ve Telefon No alanları içermelidir.
  - Doğrulama: Bilgiler girildikten sonra küçük bir kutuda SMS ile gelen doğrulama kodu ("1234") girilecek yapı kurulmalıdır. Başarılı olmadan ana sayfaya geçilemez.

- **Home (Ana Sayfa ve Araç Seçimi) Modülü:**
  - Tarih seçme alanı takvim üzerinden yapılmalıdır.
  - Tarife ve Tarih Tutarlılığı: Günlük (`gün * günlük_fiyat`), Haftalık (`seçilen gün ve hafta katsayısına göre paket fiyatı`) ve Aylık fiyatlandırma takvimle tam senkron çalışmalıdır.
  - Aracı alma ve teslim etme noktaları zengin harita görseli üzerinden gösterilmelidir.
  - Ödeme Güvenliği: Kiralarken test kart numarası (`4543 1234 5678 9012`) gösterilmeli ve 3D Secure SMS doğrulama kodu (`1234`) ile ödeme onaylanmalıdır.

- **Reservations (Rezervasyonlarım ve Geri Teslimat Takibi) Modülü:**
  - Aktif, biten, onay bekleyen rezervasyonlar listelenmelidir.
  - **Geri Teslimat Takibi:** Kalan süre sayacı, teslim istasyonu bilgisi sunulmalıdır.
  - **Erken Teslim Kuralı:** Erken teslimat yapmak isteyen kullanıcılara *"Erken teslimatta rezervasyon şartları gereğince ücret iadesi yapılmayacaktır"* uyarısı gösterilir.
  - **Sistemden Süre Uzatma:** Kullanıcılar şubeye gitmeden doğrudan sistem üzerinden gün bazlı kiralama sürelerini uzatabilirler.
  - HGS ve geç teslimat ekstra ücretleri diyalog üzerinden ödenmelidir.

- **Profile (Profil Bilgisi) Modülü:**
  - Müşteri bilgileri, anlık Açık/Koyu mod değiştirici, çıkış butonu, SSS ve kiralama kuralları listelenmelidir.