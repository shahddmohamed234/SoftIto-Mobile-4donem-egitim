import 'package:flutter/material.dart';
import '../models/boulder_model.dart';
import 'add_climb_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Boulder> rotalarim = []; // Başlangıçta boş

  Color _getHoldColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'sarı': return Colors.yellow.shade700;
      case 'kırmızı': return Colors.red;
      case 'mavi': return Colors.blue;
      case 'yeşil': return Colors.green;
      case 'siyah': return Colors.black;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boulder Rotası', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(rotalarim: rotalarim),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. ÜSTTEKİ BÜYÜK "HERO" KART
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terrain, color: Colors.white70, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "Güncel Tırmanış Durumu", 
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "${rotalarim.length} Kayıtlı Rota",
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Küçük adımlar, yüksek zirveler.",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),

          // 2. LİSTE KISMI
          Expanded(
            child: rotalarim.isEmpty
                ? Center(
                    child: Text(
                      "Henüz tırmanış kaydetmedin.\nHemen bir rota ekle!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: rotalarim.length,
                    itemBuilder: (context, index) {
                      final rota = rotalarim[index];
                      return Card(
                        elevation: 0, // Gölgeleri kaldırdık, daha modern oldu
                        color: Colors.white, // Kartlar beyaz
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getHoldColor(rota.holdColor).withOpacity(0.2),
                            child: Text(
                              rota.grade,
                              style: TextStyle(
                                color: _getHoldColor(rota.holdColor) == Colors.black ? Colors.black : _getHoldColor(rota.holdColor), 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          title: Text(rota.locations, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${rota.attempts} Deneme • ${rota.date.day}/${rota.date.month}"),
                          trailing: rota.isFlashed 
                              ? const Icon(Icons.star, color: Colors.amber) 
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final yeniRota = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddClimbScreen()),
          );
          if (yeniRota != null) {
            setState(() {
              rotalarim.add(yeniRota);
            });
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tırmanış Ekle"),
      ),
    );
  }
}