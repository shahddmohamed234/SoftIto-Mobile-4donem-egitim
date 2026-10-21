# Full Concentrate - Proje Dokümantasyonu ve Mimari Rehber

## 1. Projeye Genel Bakış
**Full Concentrate**, özellikle dikkat dağınıklığı ve odaklanma problemi yaşayan öğrenciler için geliştirilmiş ileri seviye bir Pomodoro ve verimlilik uygulamasıdır. 
Uygulama, standart Pomodoro sayaçlarından farklı olarak **katı odaklanma kuralları** barındırır: Odaklanma seansı sürerken kullanıcının uygulamadan çıkmasını (`WidgetsBindingObserver` ile yaşam döngüsü takibi yaparak) tespit eder ve ekranda **İhlal Kırmızısı** ile uyarı verir. Çıkışa yalnızca otomatik hesaplanan mola sürelerinde izin verilir.

---

## 2. Temel Fonksiyonel Özellikler ve Algoritmalar

### 2.1. Dinamik Mola Hesaplama Denklemi (Equation)
- **Kural:** Pomodoro çalışma süresi en az **25 dakika** olarak belirlenir.
- **Formül:** Mola süresi, çalışma süresine orantılıdır:
  $$\text{Mola (dk)} = \text{round}\left(5 \times \frac{\text{Çalışma Süresi}}{25}\right)$$
- **Örnekler:**
  - 25 dk odaklanma $\rightarrow$ 5 dk mola
  - 30 dk odaklanma $\rightarrow$ 6 dk mola
  - 40 dk odaklanma $\rightarrow$ 8 dk mola
  - 50 dk odaklanma $\rightarrow$ 10 dk mola
  - 60 dk odaklanma $\rightarrow$ 12 dk mola

### 2.2. Katı Çıkış Engeli ve İhlal Uyarı Sistemi
- **Başlamadan Önce:** Ekranda sıcak sarı (`#E9C46A`) kutucuk içerisinde seans bitene kadar çıkılamayacağını bildiren bilgilendirme uyarısı yer alır.
- **Seans Esnasında:** Flutter'ın `WidgetsBindingObserver` sınıfı ile `didChangeAppLifecycleState` dinlenir. Uygulama `paused` veya `inactive` (arka plana atılma / çıkış teşebbüsü) durumuna geçtiğinde:
  - Sayaç otomatik duraklatılır.
  - İhlal bayrağı (`isViolationDetected = true`) ve oturum ihlal sayısı artırılır.
  - Kullanıcı geri döndüğünde ekranda **İhlal Kırmızısı (`#E63946`)** uyarı kartı ve ceza bildirimi gösterilir.
- **Molada:** Çıkış kuralı devre dışıdır; kullanıcı rahatça uygulamayı arka plana atabilir.

### 2.3. Yerel JSON Dosya Yönetimi (JSON File I/O)
- Uygulamada hiçbir harici backend veya uzak API kullanılmaz.
- Veriler `path_provider` aracılığıyla cihazın güvenli yerel uygulama dizininde saklanır:
  - `tasks.json`: Görev başlığı, tarihi (`DD.MM.YYYY`) ve tamamlanma durumu.
  - `sessions.json`: Gerçekleşen odak süreleri, mola süreleri, zaman damgası ve ihlal durumu.
  - `settings.json`: Tema modu, dil seçimi, alarm ses seviyesi ve ton tercihleri.

---

## 3. Ekran Hiyerarşisi (4 Ana Ekran)

1. **Ana Pomodoro Sayacı ve Mola Ekranı (`PomodoroScreen`):**
   - Aktif seçili görevin gösterimi ve görev seçiciye hızlı geçiş butonu.
   - `00:25:00` formatında geri sayım ve dairesel ilerleme çubuğu.
   - **Doğrudan Süre Değiştirme:** Sayacın veya sürenin üzerine dokunularak açılan `DurationPickerDialog`.
   - **25 Dakika Kuralı & Uyarı Sistemi:** 25 dakikanın altında bir süre seçildiğinde veya girildiğinde ekranda beliren kırmızı uyarı banner'ı ve kaydetme kilidi.
   - Başlat, Duraklat, Devam Et ve Bitir butonları.
   - Çalışma bittiğinde yumuşak pembe tonlu Mola Ekranına geçiş (`BreakViewWidget`), sıradaki görev hatırlatması ve "Molayı Erken Bitir" butonu.

2. **Görev Seçici ve Yönetimi Ekranı (`TaskListScreen`):**
   - **Tarih Bazlı Klasörleme (`TaskDateFolderWidget`):** Aynı tarihteki (`DD.MM.YYYY`) görevler bir araya toplanarak açılır/kapanır klasör yapısında (`📁 21.10.2026`) listelenir.
   - Her klasörde o güne ait görev sayısı ve tamamlanma istatistiği gösterilir.
   - Klasör üzerinden doğrudan o güne özel yeni görev ekleyebilme imkanı.
   - Tamamlandı/tamamlanmadı durumunu değiştiren etkileşimli onay kutusu.
   - Yeni görev ekleme modalı (`AddTaskDialog`).
   - "Kaydet ve Pomodoro Sayfasına Git" aksiyon butonu.

3. **Odak Analitiği ve Raporlama Ekranı (`AnalyticsScreen`):**
   - **Günlük, Haftalık ve Aylık** sekmeler (Row butonları).
   - Tarih seçici modal entegrasyonu.
   - `fl_chart` ile gül kurusu renginde sütun grafikleri.
   - Toplam odak süresi, tamamlanan seans ve ihlal sayısını gösteren özet kartlar.
   - Son seans geçmişi listesi.

4. **Ayarlar Ekranı (`SettingsScreen`):**
   - Türkçe (TR) ve İngilizce (EN) dil değiştirici.
   - Karanlık Mod (Dark Mode) açma/kapama anahtarı.
   - Alarm ses seviyesi kaydırıcısı (`Slider`).
   - Pomodoro ve mola için bağımsız ses tonu seçicileri.

---

## 4. Renk Paleti ve Tasarım Dili

Uygulamanın renk paleti göz yormayacak şekilde özenle seçilmiş, odaklanmayı dağıtan parlak renkler (özellikle çiğ yeşil) kesinlikle elenmiştir:
- **Koyu Bordo (`#721C24`):** Ana odaklanma modu, birincil butonlar ve başlıklar.
- **Gül Kurusu / Koyu Pembe (`#B56576`):** İkincil butonlar, grafik sütunları ve tamamlanan görev göstergeleri.
- **Yumuşak Pembe (`#F5CAC3`):** Mola ekranı rahatlatıcı arka plan geçişi.
- **Açık Pudra (`#F8EDEB`):** Açık tema ana arka planı ve görev kartı zemini.
- **Koyu Antrasit (`#2D2327`):** Yumuşak ve gözü yormayan ana metin rengi.
- **Sıcak Sarı (`#E9C46A`):** Başlamadan önceki çıkış engeli uyarı bildirimi.
- **İhlal Kırmızısı (`#E63946`):** Seans bölünmesi ve çıkış teşebbüsü uyarı rengi.
- **Koyu Mürdüm/Gri (`#1A1114`):** Karanlık tema ana arka planı.
- **Pastel Pembe (`#F4ACB7`):** Karanlık temadaki sayaç ve buton vurgu rengi.

---

## 5. Kırmızı Çizgiler ve Kod Kalite Standartlarına Uyum

1. **State Yönetimi:**
   - Sayfa düzeyinde hantal `setState` kullanılmamış; durum yönetimi Flutter'ın yerel çekirdek API'leri olan `ChangeNotifier` ve `ListenableBuilder` (`TaskController`, `PomodoroController`, `SettingsController`) ile izole edilmiştir.
   - Harici ağır state yönetim paketleri (Bloc, Riverpod vb.) eklenmemiştir.
2. **UI ve Performans:**
   - Tüm statik bileşenlerde `const` anahtar kelimesi eksiksiz kullanılmıştır.
   - Sınıflar içinde satır içi (inline) stil verilmemiş, tüm tema `AppTheme` ve `AppColors` üzerinden merkezi yönetilmiştir.
   - Akış mantığında karmaşık tek satırlık koşullar yerine standart, açık ve okunabilir `if/else` blokları tercih edilmiştir.
3. **Modülerlik:**
   - Hiçbir `build` metodu 40 satırı aşmayacak şekilde alt özel widget sınıflarına ve yardımcı metotlara parçalanmıştır.
4. **Detaylı Yorum Satırları:**
   - Kod tabanındaki tüm dosya, sınıf, fonksiyon ve kritik algoritma satırları ayrıntılı Türkçe açıklamalarla dokümante edilmiştir.

---

## 7. Son Geliştirmeler ve İyileştirmeler

### 1. Zenginleştirilmiş ve Net Analitik Mimarisi
Analitik ekranı kullanıcının odaklanma alışkanlıklarını derinlemesine analiz edebilmesi için 6 temel performans metriğine ve akıllı bir verimlilik motoruna kavuşturuldu:
- **Toplam Çalışma Süresi:** Günlük/Haftalık/Aylık seçilen periyottaki toplam odak dakikası ("X sa Y dk" formatında).
- **Tamamlanan Seans Sayısı:** Başarıyla tamamlanan pomodoro çalışma sayısı.
- **İhlal Sayısı:** Seans esnasında kural dışı uygulamadan çıkış adedi.
- **Ortalama Seans Süresi:** Tek seansta ortalama kaç dakika odaklanıldığı.
- **Odaklanma Başarı Oranı (%):** İhlalsiz seansların toplam seanslara oranı üzerinden hesaplanan disiplin yüzdesi.
- **Toplam Mola Süresi:** Hak edilen ve kullanılan toplam dinlenme süresi.
- **Verimlilik Analiz Özeti (Productivity Insight):** Kullanıcının başarı oranına göre otomatik tavsiye ve geri bildirim üreten akıllı analiz kartı.
- **Zaman Dilimi Filtreleme:** Günlük (saatlik dilimler), Haftalık (günler) ve Aylık (haftalar) sekmelerine göre anında güncellenen istatistikler ve grafikler.

### 2. Eksiksiz İngilizce / Türkçe Yerelleştirme (Localization)
Uygulamanın İngilizce modunda kalan tüm Türkçe metinler temizlendi ve merkezi `AppStrings` mimarisiyle entegre edildi:
- **Süre Ayar Penceresi (DurationPickerDialog):** Başlık, etiketler, 'dk/min' ekleri, hızlı seçim çipleri, 25 dk minimum uyarısı ve dinamik formül bilgisi.
- **İhlal Uyarısı (ViolationWarningWidget):** 'Anladım, Odaklanmaya Devam Et' / 'I Understand, Keep Focusing' butonu.
- **Sayaç Ekranı:** Süre değiştirme rozeti ('Change Duration'), formül bilgisi ('25 min Study = 5 min Break (Auto Calculated)').
- **Görev Klasörleri:** Tarihli klasörlerin altındaki adet ve tamamlanma göstergeleri ('2 Tasks • 0 Completed').
- **Ayarlar Ekranı:** Pomodoro ve mola alarm zil seçeneklerinin (Klasik Çan / Classic Bell vb.) kullanıcı diline göre dinamik çevirisi.
- **Hata Mesajları:** Görev başlığı zorunluluğu uyarısı.
