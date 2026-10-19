---
name: flutter-feature-scaffold
description: Flutter projesinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken **CLEAN UI** ve **reaktif State** kurallarına tam uyulmasını garanti altına alır.

---

## Bağlı Kaynaklar ve Ekler

- 📖 **State ve Veri Akış Referansı:** [state_flow.md](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/19ekim-3/.agents/skills/references/state_flow.md)
- 🚀 **Otomasyon Scripti:** [generate_feature.sh](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/19ekim-3/.agents/skills/script/generate_feature.sh)
- 💡 **Eksiksiz Örnek Ekran:** [sample_screen.dart](file:///Users/d1-5/Desktop/SoftIto-Mobile-4donem-egitim/19ekim-3/.agents/skills/examples/sample_screen.dart)

---

## Temel Kurallar

1. **Asla Tek Dosyada Toplama:**
   UI (`views/`), State Controller (`controllers/`), Model (`models/`) ve Kart/Alt bileşenler (`widgets/`) dosyaları ayrı ayrı açılmalıdır.
2. **State Yönetimi:**
   Basit ve reaktif durumlar için `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır.
   Sayfa düzeyinde ağır `setState` kesinlikle kullanılmamalıdır.
3. **Const Zorunluluğu:**
   Statik ve değişmeyen tüm widget'larda `const` kullanımı zorunludur.
4. **40 Satır Kuralı:**
   `build` metotları 40 satırı geçemez; büyük arayüzler atomik alt widget'lara parçalanmalıdır.
5. **Çift Tema Uyumluluğu:**
   Renk ve tipografi değerleri doğrudan sabit kodlanmaz; `Theme.of(context)` veya `AppColors` paletinden alınır.

---

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adını (örn: `water_tracker` veya `workout`), `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>/
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    views/
        <feature_name>_screen.dart
    widgets/
        <feature_name>_card.dart
```

> **İpucu:** Bu yapıyı otomatik kurmak için scripti çalıştırabilirsiniz:
> ```bash
> .agents/skills/script/generate_feature.sh <feature_name>
> ```

---

### Adım 2: Controller Dosyasını Yaz
`controllers/<feature_name>_controller.dart` içinde iş mantığını ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final int dailyGoalWater = 2000; // 2 litre

  void addWater() {
    currentWater.value += 250;
  }

  void resetWater() {
    currentWater.value = 0;
  }

  void dispose() {
    currentWater.dispose();
  }
}
```

---

### Adım 3: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson` ve `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla:

```dart
import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String name;
  final String email;
  final String profileImage;
  final int level;
  final int coins;

  const UserProfile({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.level,
    required this.coins,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? profileImage,
    int? level,
    int? coins,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      level: level ?? this.level,
      coins: coins ?? this.coins,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      level: json['level'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'level': level,
      'coins': coins,
    };
  }
}
```

---

### Adım 4: View (Ekran) Dosyasını Oluşturma
`views/<feature_name>_screen.dart` dosyasında `ValueListenableBuilder` kullanarak izole rebuild mekanizmasını kur:

```dart
import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takibi'),
      ),
      body: Center(
        child: ValueListenableBuilder<int>(
          valueListenable: _controller.currentWater,
          builder: (context, currentWater, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mevcut Su: $currentWater ml',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _controller.addWater,
                  child: const Text('250 ml Ekle'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _controller.resetWater,
                  child: const Text('Sıfırla'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

---

### Adım 5: Widget Dosyasını Oluşturma
`widgets/<feature_name>_card.dart` dosyasında modüler, `const` ve tema duyarlı UI kartları oluştur:

```dart
import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final int level;
  final int coins;

  const UserProfileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.level,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            Text(subtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Seviye: $level'),
                Text('Puan: $coins'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Adım 6: Clean Architecture Kurallarına Uyum
- **Separation of Concerns:** Her katmanın tek bir sorumluluğu olmalıdır.
- **DRY (Don't Repeat Yourself):** Kod tekrarından kaçınılmalıdır.
- **Reusability:** Widget'lar ve kontrolcüler bağımsız tekrar kullanılabilir olmalıdır.
- **Testability:** Controller iş mantığı saf Dart birim testleriyle (UI bağımlılığı olmadan) test edilebilmelidir.

---

## Sık Sorulan Sorular (SSS)

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran, işlev modülü veya özellik eklerken dosya yapısının ve state mimarisinin bozulmaması için bu yetenek kullanılmalıdır.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
**Cevap:** Yalnızca tek bir satırlık renk düzeltmesi veya var olan bir widget'taki ufak metin değişikliklerinde tüm modülü baştan üretmeye gerek yoktur.