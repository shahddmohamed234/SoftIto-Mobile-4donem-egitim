---
name: flutter-feature-scaffold
description: Flutter projesinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)
Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken **CLEAN UI** ve **Reaktif State** kurallarına tam uyum sağlar.


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


## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen mödül adını (örn: `business_plan` veya `legal_support` ) `lib/features/<feature_names` altına kur:

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

### Adım 2: Controller Dosyasını Yaz
`controllers/<feature_name>_controller.dart` içinde iş mantığını ve `ValueNotifier` tanımlarını oluştur:

```dart
import 'package:flutter/foundation.dart';

class FeatureNameController {
 final ValueNotifier<bool> _isProcessing = ValueNotifier<bool>(false);
 final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);
 ValueNotifier<String?> get errorMessage => _errorMessage;
 ValueNotifier<bool> get isProcessing => _isProcessing;

 void setProcessing(bool value) {
  _isProcessing.value = value;
 }
 void setErrorMessage(String? message) {
  _errorMessage.value = message;
 }
 void setSuccessMessage(String? message) {
  _successMessage.value = message;
 }
 void dispose() {
  _isProcessing.dispose();
  _errorMessage.dispose();
  _successMessage.dispose();
 }

    
}
```

### Adım 3: Model Dosyasını Yaz
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson` ve `toJson` metotlarını içerecek şekilde `immutable` olarak tanımla:

```dart
import 'package:flutter/foundation.dart';

@immutable
class UserProfile{
    final String name;
    final String email;
    final String profileImageUrl;
    final String role;
    final bool isVerified;

    const UserProfile({required this.name,required this.email,required this.profileImageUrl,required this.role,required this.isVerified});
    
    factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      role: json['role'],
      isVerified: json['isVerified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'isVerified': isVerified,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
    String? role,
    bool? isVerified,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

```

### Adım 4: View (Ekran) Dosyasını Oluşturma
`views/<feature_name>_screen.dart` dosyasında `ValueListenableBuilder` kullanarak izole rebuild mekanizmasını kur:

```dart
import 'package:flutter/material.dart';
import '../controllers/feature_name_controller.dart';
import 'widgets/<feature_name>_card.dart';

class FeatureNameScreen extends StatefulWidget {
 const FeatureNameScreen({super.key});
 @override
 State<FeatureNameScreen> createState() => _FeatureNameScreenState();
}

class _FeatureNameScreenState extends State<FeatureNameScreen> {
 late final FeatureNameController _controller;
 @override
 void initState() {
 super.initState();
 _controller = FeatureNameController();
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
title: const Text('Feature Name'),
 ),
 body: Center(
 child: Column(
 children: [
 ValueListenableBuilder<bool>(
 valueListenable: _controller.isProcessing,
 builder: (context, isProcessing, _) {
 if (isProcessing) {
 return const CircularProgressIndicator();
 }
 return const SizedBox.shrink();
 },
 ),
 ValueListenableBuilder<String?>(
 valueListenable: _controller.errorMessage,
 builder: (context, errorMessage, _) {
 if (errorMessage != null) {
 return Text(
 errorMessage,
 style: const TextStyle(
 color: Colors.red,
 ),
 );
 }
 return const SizedBox.shrink();
 },
 ),
 const FeatureNameCard(),
 ],
 ),
 ),
 );
 }
}
```

---

### Adım 5 : Widget Dosyasını oLuşturma
`widgets/<feature_name>_card.dart` dosyasında modüler, `const` ve tema duyarlı UI kartları oluştur:

```dart
import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String role;
  final bool isVerified;
  const UserProfileCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png'),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          role,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        if (isVerified) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                'Verified',
                style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ] else ...[
          Text(
            'Not Verified',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
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

    