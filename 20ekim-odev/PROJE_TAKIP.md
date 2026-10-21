# EasyRent - Proje Geliştirme ve Takip Dokümanı

Bu doküman, "EasyRent (Araç Kiralama Uygulaması)" projesinin gereksinimlerini, [project.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/project.md) ve [SKILLS.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/agents/skills/SKILLS.md) yönergelerine uygun olarak adım adım yapılan tüm işlemleri anlık ve detaylı olarak kayıt altına almak için oluşturulmuştur.

---

## 📌 Proje Genel Bilgileri
- **Uygulama Adı:** EasyRent
- **Konsept:** Günlük, haftalık ve aylık tarifeler sunan, müsaitlik durumunu ve teslim noktalarını harita/istasyon üzerinden gösteren, HGS ve geç teslim cezası takibi yapabilen klasik araç kiralama platformu.
- **Hedef Platformlar:** iOS ve Android.
- **Flutter & Dart:** Flutter 3.29+ / Dart 3.x uyumlu.
- **Tasarım Standartları:** Material Design 3, Çift Tema Desteği:
  - **Açık Tema (Light Mode):** Mavi ağırlıklı ferah tasarım (`#1E88E5`).
  - **Koyu Tema (Dark Mode):** Kırmızı vurgulu ve koyu arka planlı tasarım (`#D32F2F` & `#121417`).
- **Tema Yönetimi:** `ValueNotifier<ThemeMode>` singleton ile anlık Açık/Koyu mod geçişi.
- **State Yönetimi:** Yerel ve reaktif `ValueNotifier` & `ValueListenableBuilder` (sayfa düzeyinde ağır `setState` kesinlikle kullanılmamıştır).
- **Zorunlu Giriş Kapısı (Auth Gate):** Uygulama ilk açıldığında zorunlu Login sayfası açılır; TCKN, Ehliyet ve SMS ("1234") doğrulanmadan ana kabuğa yönlendirme yapılmaz.
- **Tarife & Tarih Senkronizasyonu:** Günlük, Haftalık ve Aylık tarifeler seçilen gün sayısı ve paket avantajına göre tam doğru hesaplanır.
- **Ödeme Güvenliği:** Test kartı numarası (`4543 1234 5678 9012`) gösterilir ve 3D Secure SMS doğrulama kodu (`1234`) ile ödeme onaylanır.
- **Erken Teslim & Süre Uzatma Kuralı:** Erken teslimatta para iadesi yapılmayacağı açıkça belirtilmiştir; süre uzatmak isteyenlerin doğrudan sistem üzerinden uzatabileceği entegre edilmiştir.
- **Kod Standartları:**
  - Feature bazlı mimari (`data/`, `domain/`, `presentation/`).
  - 40 satır `build` metodu sınırı (tüm arayüz atomik `const` bileşenlere ayrılmıştır).
  - Her sınıf, fonksiyon ve önemli kod bloğu için detaylı Türkçe açıklama yorumları eklenmiştir.
  - Statik kod analizinde 0 hata ve 0 uyarı (`flutter analyze`).

---

## 🚀 İşlem Adımları ve Güncel Durum

| Adım | İşlem | Durum | Detay |
| :--- | :--- | :---: | :--- |
| **1** | Takip Dokümanının Oluşturulması | ✅ Tamamlandı | `PROJE_TAKIP.md` dosyası oluşturuldu ve süreç planlandı. |
| **2** | Flutter Projesinin Başlatılması | ✅ Tamamlandı | `flutter create --org com.easyrent --project-name easy_rent .` çalıştırıldı. |
| **3** | Telefon Ana Ekran Logosu (AppIcon) | ✅ Tamamlandı | Araba anahtarı ve kiralama sembollü logo üretilip iOS AppIcon setine (20x20'den 1024x1024'e) PNG formatında yerleştirildi. |
| **4** | Core Katmanı (Tema, Renkler & Kontrolcü) | ✅ Tamamlandı | `app_colors.dart`, `app_theme.dart` (Mavi/Kırmızı M3 çift tema) ve `theme_controller.dart` (`ValueNotifier<ThemeMode>`) yazıldı; her kod satırına açıklama yorumları eklendi. |
| **5** | Zorunlu Açılış Girişi (`features/auth`) | ✅ Tamamlandı | Başlangıçta oturum null yapıldı; TCKN, Ehliyet No ve SMS ("1234") doğrulanmadan başka sayfaya geçit vermeyen Auth Gate kuruldu. |
| **6** | Doğru Tarife Fiyatlandırması (`home`) | ✅ Tamamlandı | `calculateTotal` fonksiyonu ile Günlük, Haftalık ve Aylık tarife seçimlerinin takvimle tam senkron çalışması sağlandı. |
| **7** | Harita Teslim Noktaları Gösterimi (`home`) | ✅ Tamamlandı | Harita pinleri, istasyon koordinatları ve teslim alma noktaları görselleştirildi. |
| **8** | Test Kartı & 3D Secure SMS Ödemesi | ✅ Tamamlandı | Kiralama diyaloğunda test kartı (`4543 1234 5678 9012`) gösterildi; banka SMS doğrulama kodu (`1234`) ile ödeme güvenceye alındı. |
| **9** | Geri Teslimat Takibi & Erken Teslim İadesizliği | ✅ Tamamlandı | Kalan süre sayacı eklendi; erken teslimatta para iadesi yapılmayacağı kırmızı uyarıyla vurgulandı; sistemden süre uzatma bildirildi. |
| **10** | Şartname Dokümanlarının Güncellenmesi | ✅ Tamamlandı | [project.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/project.md) ve [SKILLS.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/agents/skills/SKILLS.md) yeni kurallara göre güncellendi. |
| **11** | Kod Açıklama Yorumları | ✅ Tamamlandı | Tüm dosyalardaki sınıflara, fonksiyonlara ve kod bloklarına detaylı Türkçe yorumlar eklendi. |
| **12** | Statik Kod Analizi (`flutter analyze`) | ✅ Tamamlandı | **0 hata ve 0 uyarı** ile doğrulandı (`No issues found!`). |
| **13** | Birim & Widget Testleri (`flutter test`) | ✅ Tamamlandı | `test/widget_test.dart` güncellendi ve tüm testler başarıyla geçti (`All tests passed!`). |
| **14** | iOS Simülatöründe Çalıştırma | ✅ Tamamlandı | `iPhone 18 Pro` iOS simülatöründe derlendi, yüklendi ve ekran doğrulaması alındı. |

---

## 📂 Oluşturulan ve Düzenlenen Dosyalar

1. **Yönergeler & Takip:**
   - [project.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/project.md): Güncellenen proje kılavuzu.
   - [SKILLS.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/agents/skills/SKILLS.md): Güncellenen mimari scaffold ve iş kuralları.
   - [PROJE_TAKIP.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/PROJE_TAKIP.md): Tüm adımları listeleyen anlık takip dokümanı.

2. **Core (Çekirdek & Tema):**
   - [app_colors.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/core/constants/app_colors.dart): Açık ve koyu tema için Mavi ve Kırmızı palet sabitleri (yorum satırlı).
   - [theme_controller.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/core/theme/theme_controller.dart): `ValueNotifier<ThemeMode>` singleton reaktif tema yöneticisi (yorum satırlı).
   - [app_theme.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/core/theme/app_theme.dart): Material 3 Açık (Mavi) ve Koyu (Kırmızı) stilleri (yorum satırlı).

3. **Kimlik Doğrulama (`features/auth`):**
   - [user_model.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/auth/data/models/user_model.dart): TCKN, Ehliyet No, Tel vb. kullanıcı modeli.
   - [mock_auth_repository.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/auth/data/repositories/mock_auth_repository.dart): Başlangıç oturumu kapalı; SMS ("1234") servisi.
   - [auth_controller.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/auth/presentation/controllers/auth_controller.dart): Durum kontrolcüsü.
   - [auth_text_field.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/auth/presentation/widgets/auth_text_field.dart): Validasyonlu girdi bileşeni.
   - [sms_verification_dialog.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/auth/presentation/widgets/sms_verification_dialog.dart): 4 haneli SMS onay kutusu.
   - [login_screen.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/auth/presentation/pages/login_screen.dart): Zorunlu açılış giriş ekranı (40 satır kuralına uygun).

4. **Ana Sayfa & Araç Kiralama (`features/home`):**
   - [car_model.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/data/models/car_model.dart): `calculateTotal` fonksiyonu ile tarife-tarih tutarlı fiyat hesaplayıcı.
   - [rental_station_model.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/data/models/rental_station_model.dart): Koordinatlı teslim istasyonları modeli.
   - [mock_car_repository.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/data/repositories/mock_car_repository.dart): Müsait araç ve istasyon sahte verileri.
   - [home_controller.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/controllers/home_controller.dart): Takvim, istasyon ve tarife seçim kontrolcüsü.
   - [date_range_picker_card.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/widgets/date_range_picker_card.dart): Takvim üzerinden gün seçimi kartı.
   - [rate_toggle_bar.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/widgets/rate_toggle_bar.dart): Günlük/Haftalık/Aylık fiyat sekmeleri.
   - [station_locations_sheet.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/widgets/station_locations_sheet.dart): Harita pinleri ve teslim noktası seçim paneli.
   - [payment_reservation_dialog.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/widgets/payment_reservation_dialog.dart): Test kartı (`4543 1234 5678 9012`) ve 3D Secure SMS (`1234`) onay diyaloğu.
   - [car_card.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/widgets/car_card.dart): Araç kiralama kartı.
   - [home_screen.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/home/presentation/pages/home_screen.dart): Ana araç keşif ve listeleme ekranı.

5. **Rezervasyon Yönetimi (`features/reservations`):**
   - [reservation_model.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/data/models/reservation_model.dart): Rezervasyon durumu, geri teslimat süresi, ceza ve HGS modeli.
   - [mock_reservation_repository.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/data/repositories/mock_reservation_repository.dart): Aktif/biten rezervasyonlar, sistemden süre uzatma ve iadesiz erken teslim.
   - [reservations_controller.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/presentation/controllers/reservations_controller.dart): Rezervasyon durum kontrolcüsü.
   - [penalty_hgs_dialog.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/presentation/widgets/penalty_hgs_dialog.dart): HGS ve geç teslim cezası ödeme diyaloğu.
   - [extend_rental_dialog.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/presentation/widgets/extend_rental_dialog.dart): Sistemden kiralama süresini uzatma diyaloğu.
   - [reservation_card.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/presentation/widgets/reservation_card.dart): Geri teslimat takibi (kalan süre sayacı) ve aksiyon kartı.
   - [reservations_screen.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/reservations/presentation/pages/reservations_screen.dart): Erken teslim iadesizlik uyarılı rezervasyonlar ekranı.

6. **Profil & Ayarlar (`features/profile`):**
   - [faq_item_model.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/data/models/faq_item_model.dart): SSS ve kurallar modeli.
   - [mock_profile_repository.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/data/repositories/mock_profile_repository.dart): Erken teslimatta ücret iadesi yapılmayacağı ve sistemden uzatma kuralları.
   - [profile_controller.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/presentation/controllers/profile_controller.dart): Profil kontrolcüsü.
   - [profile_user_card.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/presentation/widgets/profile_user_card.dart): Sürücü profili ve ehliyet bilgi kartı.
   - [theme_switch_tile.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/presentation/widgets/theme_switch_tile.dart): Anlık Koyu (Kırmızı) / Açık (Mavi) geçiş anahtarı.
   - [faq_rules_expansion_card.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/presentation/widgets/faq_rules_expansion_card.dart): Kiralama kuralları akordiyon listesi.
   - [profile_screen.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/features/profile/presentation/pages/profile_screen.dart): Profil ana ekranı.

7. **Uygulama Giriş Noktası & Test:**
   - [main.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/lib/main.dart): Auth Gate ile zorunlu Login kapısı ve sekmeli navigasyon (`NavigationBar`).
   - [widget_test.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/test/widget_test.dart): Açılışta zorunlu LoginScreen karşılamasını doğrulayan test.
   - [calculation_test.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/20ekim-odev/test/calculation_test.dart): Fiyatlandırma, iki yönlü tarife senkronizasyonu, aynı gün kiralama ve süre uzatma birim testleri.
