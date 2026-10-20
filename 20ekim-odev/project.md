# EasyRent Araç Kiralama Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan ajan (Antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen kod satırı buradaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojileri
- **Uygulama Adı:** EasyRent (Klasik araba kiralama sistemi mantığı ile çalışan, modele göre günlük, haftalık ve aylık fiyatlandırma sunan, araç müsaitlik durumunu gösteren bir platform).
- **Uygulama Iconu:** Araba anahtarı ve kiralama sembolünü içeren minimalist bir figür (telefon ana ekranı AppIcon ve uygulama içi).
- **Hedef Platformları:** iOS ve Android öncelikli.
- **Flutter SDK:** 3.29.0+
- **Dart SDK:** 3.0.0+
- **Tasarım dili:** Material Design 3, Çift Tema Desteği.
- **Renk Paleti:** Kırmızı ve Mavi.
- **Açık Tema:** Mavi ağırlıklı ferah tasarım.
- **Koyu Tema:** Kırmızı vurgulu ve koyu arka planlı tasarım.
- **Dinamik Geçiş:** Kullanıcı uygulama içerisinden anlık olarak Açık/Koyu mod arasında geçiş yapabilmelidir. Tema durumu `ValueNotifier<ThemeMode>` ile reaktif yönetilecektir.
- **Veri Yönetimi (ÖNEMLİ):** Şu aşamada harici bir API KULLANILMAYACAKTIR. Tüm veriler (araçlar, kullanıcı işlemleri, rezervasyonlar) uygulama içerisinde oluşturulacak yerel mock (sahte) veriler üzerinden yönetilecektir.

## 2. Zorunlu İş Mantığı ve Ekran Akışları
1. **Açılışta Zorunlu Giriş:** Uygulama ilk açıldığında mutlaka Giriş (Login) ekranı gelmelidir. TCKN, Ad-Soyad, Ehliyet No ve Telefon girilip SMS kodu (1234) doğrulanmadan kesinlikle ana kabuğa yönlendirilmeyecektir.
2. **Doğru Tarife & Tarih Fiyatlandırması:** 
   - Günlük: Gün sayısı * Günlük fiyat.
   - Haftalık: 7 gün ve katları paket mantığı veya haftalık indirimli birim fiyattan hesaplama; kullanıcı haftalık seçtiğinde en az 7 günlük kiralama paketi baz alınır.
   - Aylık: 30 günlük paket mantığı baz alınarak doğru orantılı hesaplanır.
3. **Kiralama Güvenliği ve Test Kartı (SMS Onayı):**
   - Kiralama adımında kullanıcıya test kart numarası (`4543 1234 5678 9012`), SKT ve CVV gösterilir.
   - Ödeme yap butonuna basıldığında banka 3D Secure / SMS ödeme doğrulama kodu (`1234`) kutusu açılır, kod girilmeden kiralama tamamlanmaz.
4. **Erken Teslim İadesizlik Kuralı:** Rezervasyon bitiş tarihinden önce erken teslim etmek isteyen kullanıcılara sistemde açıkça *"Erken teslimatta rezervasyon şartları gereğince ücret iadesi yapılmayacaktır"* uyarısı gösterilir.
5. **Sistem Üzerinden Süre Uzatma:** Kullanıcılar şubeye gitmeden doğrudan uygulama üzerinden kiralama süresini gün bazlı uzatabilir.
6. **Harita Üzerinden İstasyon Gösterimi:** Aracı alma ve teslim etme noktaları zengin harita görseli, koordinatlar ve konum pinleri üzerinden gösterilir.
7. **Geri Teslimat Takibi:** Rezervasyonlarım ekranında kalan gün/saat, teslim edilecek istasyon, erken teslim ve süre uzatma aksiyonları dinamik olarak izlenir.

## 3. Mimari Yapısı : Özellik Bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

lib/
  core/                       # Uygulama genelinde paylaşılan kodlar
        constants/
        theme/                  # Material 3 ve Dark/Light yönetimi

  features/                   # İzole modül klasörleri
        auth/                   # Login: TCKN, Ad-Soyad, Doğum tarihi, Ehliyet No, Telefon ve SMS ile doğrulama
            data/                 # (Sadece lokal mock data modelleri)
            domain/
            presentation/
        home/                   # Ana Sayfa: Tarih seçimi, günlük/haftalık/aylık fiyat tarifeleri ve müsait araç listesi. Harita teslim noktaları.
            data/
            domain/
            presentation/
        reservations/           # Rezervasyonlarım: Geri teslimat takibi, süre uzatma, erken teslim (iadesiz), ceza ve HGS ekstra ödemeleri.
            data/
            domain/
            presentation/
        profile/                # Profil Bilgisi: Ayarlar, çıkış, SSS, kurallar.
            data/
            domain/
            presentation/

  main.dart                   # Uygulama giriş noktası (Auth yönlendirmeli)

## 4. Kırmızı Çizgiler Kod Kalite Standartları
1. **State Yönetim Standartları:** Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR. Durum yönetimi için `ValueNotifier` kullanılacaktır.
2. **UI ve Performans Kuralları:** Statik tüm widget'larda `const` zorunludur. Renk/metin stilleri tema dosyasından alınacaktır. `build` metodları 40 satırı geçmeyecektir. Temel UI elemanları, etkileşimler, diyaloglar ve bildirimler eksiksiz kullanılacaktır.
3. **API ve Dış Kaynak Kuralı:** Hiçbir dış API veya uzak sunucu bağlantısı kurulmayacaktır. Uygulama tamamen çevrimdışı ve mock verilerle çalışacaktır.
4. **Kod Açıklama Yorumları:** Kod dosyalarındaki her sınıf, fonksiyon ve önemli kod bloğu için ne yaptığını açıklayan net Türkçe yorum satırları bulunmalıdır.
5. **Yasaklı Paketler:** Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.

## 5. Geliştirme Analizi (0 uyarı ve 0 hata şart)
- Statik kod analizi: `flutter analyze`
- Birim ve widget testi: `flutter test`
- Projeyi çalıştırma: `flutter run`
