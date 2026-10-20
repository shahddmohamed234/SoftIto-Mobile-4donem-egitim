# Girişimcilik Destek ve Takip Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan ajan (Antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur.Projede üretilen kod satırı burdaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojileri
-**Uygulama Adı:** Future Enterpreneur (Geleceğin girişimcilerine hakim olamadıkları hukuki destek, iş planı olmayanlara da iş planı çıkartan ve onaylanıp onaylanmadığını takip edebilen, maddi destek imkanlarını sunan, mentorluk yapabilen, danışmanlık yapabilen, ve süreçlerini takip edebilen bir girişimcinin ihtiyaç duyduğu hemen her şeyi tek bir noktada toplayan bir uygulama)
-**Uygulama Iconu:** kafasının üstünde bir yanan lamba  ve elinde iş çantası ve kravat takan bir beyaz insan figürü

-**Hedef Platformları:** İos ve android öncelikli ardından web ve masaüstü platformları

- **Flutter SDK :** 3.29.0

- ** Dart SDK:** 3.0.0
-**Tasarım dili:** Material 3, Çift Tema Desteği
  - **Açık Tema:** Sky Blue ve Chili Red
  - **Koyu Tema:** Soft Black ve Royal Blue
  - **Dinamik Geçiş:** Kullanıcı uygulama içerisinden anlık olarak Açık/Koyu mod arasında geçiş yapabilmelidir. Tema durumu `ValueNotifier<ThemeMode>` ile reaktif yönetilecektir.


---
## Mimar Yapısı : Özellik Bazlı
kodlar kesinlikle tek bir yerde toplanmayacaktır. Her mödül kendi feature klasöründe kodlanacaktır.


```text
lib/
  core/                       # Tüm uygulama genelinde paylaşılan çekirdek kodlar
        constants/              # Sabitler (AppColors, AppStrings, AppConstants vb.)
        theme/                  # Tema yönetimi (Açık/Koyu tema tanımları,        ValueNotifier<ThemeMode>mantığı)

  features/                   # Projedeki her bir modülün birbirinden izole klasörü
        auth/                   # Kimlik Doğrulama (Kayıt, Giriş, Şifre Sıfırlama)
        data/               # API istekleri, Data kaynakları (Remote/Local), Veri Modelleri (DTO)
        domain/             # İş kuralları (UseCases), Entity'ler ve Repository Arayüzleri
        presentation/       # Ekranlar (Pages/Views), State Management, Feature'a özel widget'lar

    business_plan/          # İş planı oluşturma ve onay durum takibi modülü
        data/
        domain/
        presentation/

    legal_support/          # Hukuki destek sağlama ve talep oluşturma modülü
        data/
        domain/
        presentation/

    funding/                # Maddi destek imkanları görüntüleme ve başvuru modülü
        data/
        domain/
        presentation/

    mentorship/             # Mentorluk ve danışmanlık süreçleri modülü
        data/
        domain/
        presentation/

    dashboard/              # Tüm bu süreçlerin özetini sunan ana ekran (Home)
        data/
        domain/
        presentation/

  main.dart                   # Uygulama giriş noktası (RunApp) ve temel dependency injection başlatıcıları
   
```
   
### sadece uygulama başlatma ve tame bölümleri

### 3 Kırmızı çizgiler kod kalite standartları:
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans Kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyasında yazılacaktır
Büyü build methodları yasaktır 40 satırı geçen build metodları özel widgetlara yazılacaktır.

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR. 
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4 Geliştirme analiz (0 uyarı ve 0 hata şart):

**Statik kod analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* **Birim ve widget testi:**
```bash
flutter test
```

* **Projeyi çalıştırma:**
```bash
flutter run
```

## 5 Ajanın çıktı ve yanıt verme standartları

**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.

**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.

**Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.

**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi Flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.
