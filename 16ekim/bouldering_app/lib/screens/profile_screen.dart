import 'package:flutter/material.dart';
import '../models/boulder_model.dart';

class ProfileScreen extends StatelessWidget {
  // Ana ekrandan buraya tırmanış listemizi göndereceğiz ki istatistik hesaplayabilelim
  final List<Boulder> rotalarim;

  const ProfileScreen({super.key, required this.rotalarim});

  @override
  Widget build(BuildContext context) {
    // Basit istatistik hesaplamaları
    int toplamRota = rotalarim.length;
    int flashSayisi = rotalarim.where((rota) => rota.isFlashed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profil Fotoğrafı (Yer tutucu ikon)
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person, 
                size: 50, 
                color: Theme.of(context).colorScheme.primary
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Boulder Sporcusu", 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            // İstatistik Kartları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _istatistikKarti(context, "Toplam Rota", toplamRota.toString()),
                _istatistikKarti(context, "Flash Sayısı", flashSayisi.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // İstatistikleri şık bir kutu içinde göstermek için yardımcı widget
  Widget _istatistikKarti(BuildContext context, String baslik, String deger) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Column(
          children: [
            Text(
              deger,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              baslik, 
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}