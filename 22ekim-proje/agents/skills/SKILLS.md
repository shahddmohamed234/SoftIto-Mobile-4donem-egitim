# Go On: Teknik Beceriler ve Uygulama Mimarisi



Bu doküman, "Go On" projesindeki kritik UI özelliklerinin (şeffaflık, kedi animasyonları, takvim streak mantığı) belirlenen katı kod kalite standartlarına (Clean Architecture, inline if yasağı, büyük build metodu yasağı) göre nasıl uygulanacağını gösterir.


## 1. Rozet ve Kupon Şeffaflık Mantığı (Opacity)



Kazanılmış rozetler ve kuponlar belirgin renkte, henüz kazanılmayanlar ise şeffaf (soluk) görünecektir. Kod okunabilirliğini artırmak için inline koşullar yerine standart if/else blokları kullanılır. Renkler sınıf içine yazılmaz, temadan çekilir.



// lib/features/rewards/presentation/widgets/reward_badge_widget.dart
```dart

import 'package:flutter/material.dart';



class RewardBadgeWidget extends StatelessWidget {

  final String badgeName;

  final bool isUnlocked;

  

  const RewardBadgeWidget({

    Key? key,

    required this.badgeName,

    required this.isUnlocked,

  }) : super(key: key);



  @override

  Widget build(BuildContext context) {

    double badgeOpacity;

    

    // Kırmızı Çizgi Kuralı: Standart if/else kullanımı (inline ternary yasaktır)

    if (isUnlocked) {

      badgeOpacity = 1.0; 

    } else {

      badgeOpacity = 0.3; 

    }



    return Opacity(

      opacity: badgeOpacity,

      child: _buildBadgeContent(context),

    );

  }



  // Kırmızı Çizgi Kuralı: Build metodu 40 satırı geçmemesi için parçalandı

  Widget _buildBadgeContent(BuildContext context) {

    // Renkler temadan çekiliyor (Mat Lavanta - #B5A8CB)

    final Color badgeColor = Theme.of(context).colorScheme.secondary;

    

    return Column(

      mainAxisSize: MainAxisSize.min,

      children: [

        Icon(Icons.star_rounded, color: badgeColor, size: 48),

        const SizedBox(height: 8),

        Text(

          badgeName, 

          style: Theme.of(context).textTheme.bodyMedium,

        ),

      ],

    );

  }

}
```




## 2. Her Sayfada 3D Kedi Gösterimi (Global Maskot Layout)



Kullanıcının başta seçtiği 4 kediden biri, uygulamanın her sayfasında uygun bir köşede yer alacaktır. Her sayfada kodu tekrar yazmak yerine, sayfaları sarmalayan bir Base/Wrapper Scaffold kullanılır.



// lib/core/presentation/layouts/base_layout_with_cat.dart
```dart

import 'package:flutter/material.dart';



class BaseLayoutWithCat extends StatelessWidget {

  final Widget child;

  final Alignment catAlignment; // Sayfaya göre pozisyon değişebilir



  const BaseLayoutWithCat({

    Key? key,

    required this.child,

    this.catAlignment = Alignment.bottomRight, // Varsayılan konum sağ alt

  }) : super(key: key);



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Sıcak Kum (#F9F6F0)

      body: Stack(

        children: [

          child, // Asıl sayfa içeriği

          _buildCatAnimation(),

        ],

      ),

    );

  }



  Widget _buildCatAnimation() {

    return Align(

      alignment: catAlignment,

      child: const Padding(

        padding: EdgeInsets.all(16.0),

        // Burada Lottie veya Rive animasyonu kullanılacaktır

        child: SizedBox(

          width: 80,

          height: 80,

          child: Placeholder(color: Colors.grey), 

        ),

      ),

    );

  }

}
```




## 3. Takvim Kalp Streak Kontrolü



Aylık takvimde tamamlanan günler için pudra/gül kurusu (#DDA7A5) renginde kalp ikonu basılacaktır. Veriler JSON'dan çekilir ve build metodu şişirilmeden arayüze aktarılır.



// lib/features/calendar/presentation/widgets/calendar_day_widget.dart
```dart

import 'package:flutter/material.dart';



class CalendarDayWidget extends StatelessWidget {

  final int dayNumber;

  final bool isStreakCompleted;



  const CalendarDayWidget({

    Key? key,

    required this.dayNumber,

    required this.isStreakCompleted,

  }) : super(key: key);



  @override

  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.all(4.0),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(8),

      ),

      child: Center(

        child: _buildDayContent(context),

      ),

    );

  }



  Widget _buildDayContent(BuildContext context) {

    if (isStreakCompleted) {

      // Streak başarılıysa Pudra rengi kalp gösterilir

      return const Icon(

        Icons.favorite, 

        color: Color(0xFFDDA7A5),

        size: 24,

      );

    } else {

      // Tamamlanmayan gün için standart metin

      return Text(

        dayNumber.toString(),

        style: Theme.of(context).textTheme.bodyLarge,

      );

    }

  }

}
```




## 4. Uygulama Teması (Pastel Renk Paleti)



UI ve Performans kuralları gereği, renkler widget'ların içine gömülmez, ThemeData üzerinden merkezi olarak yönetilir.



// lib/core/theme/app_theme.dart
```dart

import 'package:flutter/material.dart';



final ThemeData appTheme = ThemeData(

  useMaterial3: true,

  // Zemin Rengi: Sıcak Kum / Krem

  scaffoldBackgroundColor: const Color(0xFFF9F6F0),

  cardColor: Colors.white,

  colorScheme: const ColorScheme.light(

    // Ana Vurgu: Adaçayı Yeşili

    primary: Color(0xFF9DB2A1),

    // Rozet ve Kupon Vurgusu: Mat Lavanta

    secondary: Color(0xFFB5A8CB),

    // Streak ve Hata vb. için tamamlayıcı renkler

    tertiary: Color(0xFFDDA7A5), // Pudra / Gül Kurusu

  ),

  textTheme: const TextTheme(

    // Metinler: Koyu Antrasit (Sert siyah yasak)

    bodyLarge: TextStyle(color: Color(0xFF3A3A3A), fontSize: 16),

    bodyMedium: TextStyle(color: Color(0xFF3A3A3A), fontSize: 14),

  ),

);
```
