name: flutter-feature-scaffold
description: Flutter projesinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken CLEAN UI ve reaktif State kurallarına tam uyulmasını garanti altına alır.

---

## Bağlı Kaynaklar ve Ekler

- State ve Veri Akış Referansı: state_flow.md
- Otomasyon Scripti: generate_feature.sh
- Eksiksiz Örnek Ekran: sample_screen.dart

---

## Temel Kurallar

1. Asla Tek Dosyada Toplama:
   UI (views/), State Controller (controllers/), Model (models/) ve Kart/Alt bileşenler (widgets/) dosyaları ayrı ayrı açılmalıdır.
2. State Yönetimi:
   Basit ve reaktif durumlar için ValueNotifier ve ValueListenableBuilder kullanılmalıdır.
   Sayfa düzeyinde ağır setState kesinlikle kullanılmamalıdır.
3. Const Zorunluluğu:
   Statik ve değişmeyen tüm widget'larda const kullanımı zorunludur.
4. 40 Satır Kuralı:
   build metotları 40 satırı geçemez; büyük arayüzler atomik alt widget'lara parçalanmalıdır.
5. Çift Tema Uyumluluğu:
   Renk ve tipografi değerleri doğrudan sabit kodlanmaz; Theme.of(context) veya AppColors paletinden alınır.
6. Takvim ve Gün Bazlı Günlük:
   Arayüzde takvim bileşeni yer almalı; kullanıcı gün seçtiğinde seçilen güne ait anılar listelenmeli ve yeni anı o tarihe kaydedilebilmelidir. Seçili tarih durumu ValueNotifier<DateTime> ile reaktif yönetilmelidir.

---

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adını (örn: diary veya mood_tracker), lib/features/<feature_name> altına kur:

lib/features/<feature_name>/
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    views/
        <feature_name>_screen.dart
    widgets/
        <feature_name>_card.dart

---

### Adım 2: Controller Dosyasını Yaz
controllers/diary_controller.dart içinde iş mantığını ve ValueNotifier tanımlarını oluştur:

```dart

import 'package:flutter/foundation.dart';
import '../models/diary_model.dart';

class DiaryController {
  final ValueNotifier<List<DiaryEntry>> entries = ValueNotifier<List<DiaryEntry>>([]);

  void addEntry(String title, String content, String mood) {
    final newEntry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      mood: mood,
      createdAt: DateTime.now(),
    );
    
    // Referansın değişmesi için yeni bir liste atıyoruz
    entries.value = [...entries.value, newEntry];
  }

  void deleteEntry(String id) {
    entries.value = entries.value.where((entry) => entry.id != id).toList();
  }

  void dispose() {
    entries.dispose();
  }
}

---

### Adım 3: Model Dosyasını Oluşturma
models/diary_model.dart dosyasını copyWith, fromJson ve toJson metotlarını içerecek şekilde immutable olarak tanımla:

```dart
import 'package:flutter/foundation.dart';

@immutable
class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final String mood;
  final DateTime createdAt;

  const DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
  });

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? mood,
    DateTime? createdAt,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mood: json['mood'] as String? ?? 'nötr',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
```

---

### Adım 4: View (Ekran) Dosyasını Oluşturma
views/diary_screen.dart dosyasında ValueListenableBuilder kullanarak izole rebuild mekanizmasını kur:
```dart
import 'package:flutter/material.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_model.dart';
import '../widgets/diary_card.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late final DiaryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DiaryController();
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
        title: const Text('Anı Defterim'),
      ),
      body: ValueListenableBuilder<List<DiaryEntry>>(
        valueListenable: _controller.entries,
        builder: (context, entries, _) {
          if (entries.isEmpty) {
            return const Center(child: Text('Henüz bir anı eklemedin.'));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return DiaryCard(
                entry: entry,
                onDelete: () => _controller.deleteEntry(entry.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.addEntry('Yeni Gün', 'Bugün harika bir gündü...', 'Mutlu');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
---

### Adım 5: Widget Dosyasını Oluşturma
widgets/diary_card.dart dosyasında modüler, const ve tema duyarlı UI kartları oluştur:

```dart
import 'package:flutter/material.dart';
import '../models/diary_model.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;

  const DiaryCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(entry.title, style: theme.textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            entry.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
```

---

### Adım 6: Clean Architecture Kurallarına Uyum
- Separation of Concerns: Her katmanın tek bir sorumluluğu olmalıdır.
- DRY (Don't Repeat Yourself): Kod tekrarından kaçınılmalıdır.
- Reusability: Widget'lar ve kontrolcüler bağımsız tekrar kullanılabilir olmalıdır.
- Testability: Controller iş mantığı saf Dart birim testleriyle (UI bağımlılığı olmadan) test edilebilmelidir.

---

## Sık Sorulan Sorular (SSS)

Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
Cevap: Yeni bir ekran, işlev modülü veya özellik eklerken dosya yapısının ve state mimarisinin bozulmaması için bu yetenek kullanılmalıdır.

Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
Cevap: Yalnızca tek bir satırlık renk düzeltmesi veya var olan bir widget'taki ufak metin değişikliklerinde tüm modülü baştan üretmeye gerek yoktur.