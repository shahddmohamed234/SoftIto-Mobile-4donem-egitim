import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Sadece HomeScreen'i içeri alıyoruz

void main() {
  runApp(const BoulderingLogApp());
}

class BoulderingLogApp extends StatelessWidget {
  const BoulderingLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Boulder Günlüğü",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDF0F3), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B2635), // Seçtiğimiz şık bordo renk
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDF0F3), 
          foregroundColor: Color(0xFF4A151E),
          elevation: 0,
        ),
      ),
      // UYGULAMA KESİNLİKLE BURADAN, YANİ ANA EKRANDAN BAŞLAMALI:
      home: const HomeScreen(), 
    );
  }
}