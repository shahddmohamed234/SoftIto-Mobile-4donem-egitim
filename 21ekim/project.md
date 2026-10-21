# Gelişmiş Odaklanma ve Pomodoro Zamanlayıcı: Full Concentrate

## 1. Proje Özeti
Öğrencilerin dikkatini dağıtmadan çalışma sürelerini yönetmelerini sağlayan, görev listesiyle entegre çalışan ve detaylı günlük, haftalık, aylık odaklanma analitiği sunan bir verimlilik uygulamasıdır.

## 2. Proje Amacı
Öğrencilerin dikkatini dağıtmadan çalışma sürelerini yönetmek. Pomodoro süresince uygulamadan çıkışı engelleyerek tam konsantrasyon sağlamak.

## 3. Tahmini Ekran ve Sayfa Sayısı
4 Ana Ekran:
1. Ana Pomodoro Sayacı ve Mola Ekranı
2. Görev Listesi Ekranı
3. Raporlar ve Odak Analitiği Ekranı
4. Ayarlar Ekranı

## 4. Temel Özellikler
- **Özelleştirilebilir Süreler:** Çalışma süreleri en az 25 dakika olarak belirlenir ve mola süreleri çalışma süresine orantılı bir denkleme (equation) göre sistem tarafından otomatik eklenir (örn: 25 dk çalışma için 5 dk mola).
- **Görev Yönetimi:** Öğrencinin günlük görevlerini listeye eklemesi ve her pomodoronun hangi görev için yapıldığının seçilmesi.
- **Katı Odaklanma Modu (Çıkış Engeli):** Başlamadan önce sarı yazıyla kullanıcı bilgilendirilir; pomodoro başladığı andan itibaren bitene kadar uygulamadan çıkış yapılamaz. Kullanıcı pomodoro devam ederken uygulamadan çıkmaya çalışırsa sistem bunu engelleyerek **kırmızı renkli bir uyarı mesajı** gösterir. Sadece mola sürelerinde çıkışa izin verilir.
- **Gelişmiş Alarm Sistemi:** Pomodoro ve mola bitimlerinde bildirim gelmesi ve özel olarak seçilmiş ses tonlarıyla alarm çalması.
- **Detaylı Raporlama:** Günlük, haftalık ve aylık raporların tarih bazlı olarak grafiklerle sunulması.
- **Kişiselleştirme:** Karanlık mod (Dark mode) desteği, TR/EN dil seçenekleri, alarm ses seviyesi ve ses tonu ayarları.

## 5. Hedef Kitle
Odaklanma problemi yaşayan öğrenciler.

---

## 6. Proje Geliştirme ve Detay Alanı

### 6.1. Kullanılacak Teknolojiler & Kütüphaneler
- **Frontend:** Flutter & Dart (Clean Architecture ve SOLID prensiplerine uygun tasarlanacaktır)
- **Backend / Veri Depolama:** Backend veya dış API kullanılmayacaktır. Tüm veriler cihazda **Yerel JSON Dosyaları** (`path_provider` ve `dart:convert` kütüphaneleri) üzerinden okunup yazılacaktır. Basit kullanıcı tercihleri (dil, tema) için `SharedPreferences` kullanılacaktır.
- **Ek Kütüphaneler:** Grafikler için `fl_chart`, yerel alarmlar ve bildirimler için `flutter_local_notifications`, ses ayarları için `audioplayers`, dil desteği için `easy_localization`.

### 6.2. Sayfa Hiyerarşisi ve Akış Planı
- [x] **Sayfa 1 (Ana Pomodoro Sayacı):** Seçilen görevin gösterimi, geri sayım arayüzü (00:25:00), Başlat/Durdur/Bitir butonları. Pomodoro bittiğinde mola arayüzüne geçiş (Erken bitir butonu ve bir sonraki görev bilgisi).
- [x] **Sayfa 2 (Görev Seçici):** DD.MM.YYYY formatında tarihli görevlerin listelendiği, yeni görev eklenebilen ve "Kaydet ve pomodoro sayfasına git" butonu barındıran arayüz.
- [x] **Sayfa 3 (Odak Analitiği):** Günlük, haftalık ve aylık rapor sekmelerinin liste (row) şeklinde sunulması. Tıklandığında tarih seçilebilen, detaylı analiz ve grafiklerin açıldığı alt ekranlar.
- [x] **Sayfa 4 (Ayarlar):** Dil ayarı, Tema ayarı (Karanlık Mod), Ses ayarı (Ses tonu kaydırıcısı, pomodoro ve mola ses tonu seçimi).

### 6.3. Veri Modeli ve Bileşen Tasarımı (JSON Yapısı)
Veriler yerel dosya sisteminde JSON formatında tutulacak ve uygulamanın açılışında belleğe alınacaktır. Her modelin `fromJson` ve `toJson` metotları oluşturulacaktır.
- **Task Model (`tasks.json`):** `id`, `title`, `date`, `isCompleted`
- **PomodoroSession Model (`sessions.json`):** `id`, `taskId`, `workDuration`, `breakDuration`, `timestamp`
- **Settings Model (`settings.json` veya SharedPreferences):** `languageCode`, `isDarkMode`, `pomodoroVolume`, `pomodoroSoundType`, `breakSoundType`

### 6.4. Proje Takvimi ve Teslim Aşamaları
Proje geliştirme sürecinde sarmal (spiral) model kesinlikle kullanılmayacak, çevik (agile) ve iteratif bir yaklaşım benimsenecektir.
- **Aşama 1 (Tasarım & JSON Altyapısı):** UI bileşenlerinin kodlanması, model sınıflarının oluşturulması ve JSON dosya okuma/yazma (File I/O) servislerinin test edilmesi.
- **Aşama 2 (Temel Fonksiyonlar & Sayaç):** Görevlerin JSON dosyasına kaydedilmesi, pomodoro sayacı ve mola otomatik hesaplama denkleminin (`equation`) sisteme entegre edilmesi.
- **Aşama 3 (Test & İyileştirme):** Uygulamadan çıkış engeli senaryosunun test edilmesi, alarm seslerinin çalması ve JSON verileriyle grafiklerin doğrulanması.
- **Aşama 4 (Final Teslim):** Tüm veri akışının yerel JSON mimarisi üzerinden hatasız çalıştığının teyit edilip projenin derlenmesi.

### 6.5. Notlar & Karşılaşılan Zorluklar
- *Zorluk 1:* Pomodoro süresince kullanıcının uygulamadan çıkış yapmasını engellemek mobil işletim sistemlerinde (iOS/Android) ekstra sistem izinleri gerektirebilir veya uygulama arka plana atıldığında sayacı durdurup ceza verme mekanizması ile çözülebilir.
- *Zorluk 2:* Mola sürelerinin artışını belirleyecek formülün (25 dakikada bir 5 dakika artış vb.) esnek ve hatasız kodlanması.
- *Zorluk 3:* Tüm veri işlemlerinin JSON üzerinden yürütülmesi sebebiyle, eşzamanlı dosya yazma işlemlerinde veri kaybını önleyecek asenkron (async/await) bir yerel depolama servisi yazılması gereklidir.

## 7. Mimari Yapısı : Özellik Bazlı
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe, daha önce karar verdiğimiz yerel JSON altyapısına ve Clean Architecture standartlarına uygun olarak kodlanacaktır.

```text
lib/
  core/                       # Uygulama genelinde paylaşılan ortak kodlar ve araçlar
        constants/              # Sabit değerler, ikon yolları ve mola hesaplama denklemleri
        theme/                  # Karanlık mod (Dark mode) ve bordo/pembemsi renk paleti yönetimi
        utils/                  # path_provider ile JSON dosya okuma/yazma (File I/O) servisleri
        localization/           # TR ve EN dil çeviri dosyalarının yönetimi

  features/                   # İzole modül klasörleri
        tasks/                  # Görev Yönetimi: DD.MM.YYYY tarihli görev listesi, yeni görev ekleme
            data/                 
            domain/
            presentation/
        pomodoro/               # Ana Sayaç: En az 25 dk çalışma, çıkış engeli, sarı uyarı ve mola ekranı
            data/                 
            domain/
            presentation/
        analytics/              # Odak Analitiği: Günlük, haftalık ve aylık rapor listeleri
            data/
            domain/
            presentation/
        settings/               # Ayarlar: Dil değişimi, tema seçimi, alarm seviyesi ayarları
            data/                 
            domain/
            presentation/

  main.dart                   # Uygulama giriş noktası ve servislerin başlatılması

```


## 8. Kullanıcı Arayüzü (UI) ve Renk Paleti
- Uygulamanın genel teması, odaklanmayı artırmak ve göz yorgunluğunu azaltmak amacıyla bordo ve pembemsi tonlardan oluşmaktadır. Arayüzde dikkat dağıtıcı veya yorucu renkler (örneğin parlak yeşil) kullanılmayacaktır.

### 8.1. Ana Renkler (Çalışma ve Odaklanma Modu)
- Koyu Bordo (#721C24 veya #800020): Ana Pomodoro sayacında, "Başlat" butonlarında ve aktif görev vurgularında kullanılacaktır.
- Gül Kurusu / Koyu Pembe (#B56576): İkincil butonlar, görev listesindeki tamamlanmış görev işaretleri ve analiz ekranındaki grafik sütunları.

### 8.2. Mola ve Rahatlama Renkleri
- Yumuşak Pembe (#F5CAC3): Mola ekranı başladığında arayüzün bürüneceği rahatlatıcı geçiş rengi.

- Açık Pudra (#F8EDEB): Açık tema (Light Mode) genel arkaplanı ve tarihli (DD.MM.YYYY) görev kartlarının zemin rengi.

### 8.3. Metin ve Uyarılar
- Koyu Antrasit (#2D2327): Ana metinler ve görev başlıkları (tam siyah yerine okumayı yumuşatan antrasit tonu).

- Sıcak Sarı (#E9C46A): Pomodoro başlamadan önce öğrenciyi uygulamadan çıkılamayacağı konusunda bilgilendiren uyarı yazısı.

- İhlal Kırmızısı (#E63946 veya #D90429): Odaklanma seansı devam ederken kullanıcının uygulamadan çıkmaya çalışması durumunda ekranda belirecek olan sert uyarı ve ceza metni rengi.

### 8.4. Karanlık Mod (Dark Mode) Uyumu
- Koyu Mürdüm/Gri (#1A1114): Karanlık mod (Dark mode) aktif edildiğinde ana arkaplan rengi.

- Pastel Pembe (#F4ACB7): Koyu zemin üzerinde sayaç yazıları, ikonlar ve "Erken bitir" butonu gibi alanların görünürlüğünü sağlamak için kullanılacak vurgu rengi.

## 9. Kırmızı Çizgiler ve Kod Kalite Standartları
Proje geliştirme sürecinde kod kalitesini korumak için aşağıdaki kurallara kesinlikle uyulacaktır:

State Yönetim Standartları:

Sayfa düzeyinde ağır setState kullanımları kesinlikle yasaktır.

Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları, sayaç tetiklemeleri vb.) durumlarda StatefulWidget kullanılması kabul edilir.

UI ve Performans Kuralları:

Statik tüm widget'larda const kullanımı zorunludur.

Class (sınıf) içlerinde inline styling (satır içi stil) yapılmayacaktır. Renk ve metin stilleri kesinlikle tema dosyasında yönetilecektir.

Karmaşık tek satırlık (inline) koşullar yerine, akış şemalarında her zaman standart ve okunaklı if/else blokları tercih edilecektir.

Büyük build metotları yasaktır. 40 satırı geçen build metotları, okunabilirliği korumak adına özel widget'lara (custom widget) çıkarılacaktır.

Yasaklı Paketler:

Projeye onay almadan harici ve ağır state management paketleri eklenmeyecektir.

Uygulamanın temel işlevleri için Dart ve Flutter'ın yerel çekirdek API'lerini kullanmak esastır.