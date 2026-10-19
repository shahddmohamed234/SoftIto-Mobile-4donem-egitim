# Fitness Su Takip Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan ajan (Antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur.Projede üretilen kod satırı burdaki kurallaraUYMAK ZORUNDADIR.

##1.Proje Özeti ve Teknolojileri
-**Uygulama adı:** Susadım ( akıllı su egzersiz ve kalori takibi ,yakılan kaloriye göre içilmesi gereken su miktarını gösteren uygulama)
-**Uygulama iconu:** telefonun ana ekranında olacak logo; su içen su damlası 

-**Hedef Platformları:** İos ve android öncelikli ardından web ve masaüstü platformları

- ** Flutter SDK :** 3.29.0

- ** Dart SDK:** 3.0.0
-**Tasarım dili:** Material 3, Çift Tema Desteği:
  - **Koyu Tema:** Gece spor salonu paleti (Dark Obsidian & Neon Cyan/Lime)
  - **Açık Tema:** Dinamik gündüz spor salonu paleti (Arctic White, Buzul Mavisi & Elektrik Cyan)
  - **Dinamik Geçiş:** Kullanıcı uygulama içerisinden anlık olarak Açık/Koyu mod arasında geçiş yapabilmelidir. Tema durumu `ValueNotifier<ThemeMode>` ile reaktif yönetilecektir.

---


## Mimari Yapı : Özellik Bazlı
kodlar kesinlikle tek bir yerde toplanmayacaktır.Her mödül kendi feature klasöründe kodlanacaktır.


```text
lib/
core/
    core/
        constans/app_colors.dart
        theme/app_theme.dart
        
    feature/
            water_traker/
            controller/
            models/
            view/
            widget/
            water_traker.dart
        workout/
            controller/
            models/
            view/
            widget/


    main.dart        
    
```

#### sadece uygulama başlatma ve tame bölümleri

### 3 Kırmızı çizgiler kod kalite standartları
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

## 4 Geliştirme analiz (0 uyarı ve 0 hata şart):**
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi(0 uyarı ve 0 hata şart):**
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





