# Dijital Günlük (Anı Defteri)

Bu Flutter uygulaması, kullanıcıların günlük anılarını kaydedebileceği, etiketleyebileceği ve duygu durumlarını takip edebileceği modern bir dijital günlük uygulamasıdır.

Detaylı adım adım proje ve mimari raporuna [README.md](file:///c:/Users/Deneme/OneDrive/Desktop/Github%20SoftIto/SoftIto-Mobile-4donem-egitim/19ekim-odev/README.md) üzerinden de ulaşabilirsiniz.

---

## 🚀 Hızlı Başlangıç

### 1. Bağımlılıkları Yükleme
```bash
flutter pub get
```

### 2. Statik Analiz (0 Hata & 0 Uyarı)
```bash
flutter analyze
```

### 3. Testleri Çalıştırma
```bash
flutter test
```

### 4. Simülatörde / Cihazda Çalıştırma
```bash
flutter run
```

---

## 🏛️ Mimari Özellikler
* **Feature-First Yapı:** `features/diary`, `features/mood_tracker`, `features/settings`
* **Saf State Yönetimi:** `ValueNotifier` & `ValueListenableBuilder` (Dış paketler olmadan)
* **Çift Tema Desteği:** Kağıt Dokusu (Açık Tema) & Gece Okuma (Koyu Tema)
* **Takvim ve Gün Bazlı Günlük:** Kullanıcı takvimden gün seçerek o güne ait anıları görüntüleyebilir ve seçtiği tarihe günlük yazabilir (`ValueNotifier<DateTime>`).
* **Özel İkon:** Tüy kalem ve yaprak silüeti içeren özel launcher icon
