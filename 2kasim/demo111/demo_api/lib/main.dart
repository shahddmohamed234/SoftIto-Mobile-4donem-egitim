
import 'package:flutter/material.dart';
import 'models/urun.dart';
import 'services/api_ile_urun.dart';

void main() {
  runApp(const MyApp());
}

// Uygulamanın başlangıç widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ürün Listesi',
      home: const UrunEkrani(),
    );
  }
}

// Ürünleri gösterecek StatefulWidget
class UrunEkrani extends StatefulWidget {
  const UrunEkrani({super.key});

  @override
  State<UrunEkrani> createState() => _UrunEkraniState();
}

class _UrunEkraniState extends State<UrunEkrani> {

  // API'den gelen ürünleri tutacak liste
  List<UrunModel> urunler = [];

  // Yüklenme durumunu kontrol eder
  bool yukleniyor = true;

  // Hata mesajını tutar
  String? hataMesaji;

  @override
  void initState() {
    super.initState();

    // Sayfa ilk açıldığında API isteği yapılır
    urunleriYukle();
  }

  // API'den ürünleri getiren metot
  Future<void> urunleriYukle() async {

    try {

      final sonuc =
          await CanliApiUrunServisi().urunleriGetir();

      if (!mounted) return;

      setState(() {
        urunler = sonuc;
        yukleniyor = false;
        hataMesaji = null;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        yukleniyor = false;
        hataMesaji = 'Ürünler yüklenemedi: $e';
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Listesi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: yukleniyor

          // 1. Veri yükleniyorsa
          ? const Center(
              child: CircularProgressIndicator(),
            )

          // 2. Hata oluştuysa
          : hataMesaji != null
              ? Center(
                  child: Text(hataMesaji!),
                )

              // 3. Veri geldiyse
              : ListView.builder(
                  itemCount: urunler.length,

                  itemBuilder: (context, index) {

                    final urun = urunler[index];

                    return ListTile(
                      leading: Image.network(
                        urun.resimUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      ),

                      title: Text(urun.baslik),

                      subtitle: Text(
                        '${urun.kategori} - ${urun.fiyat} \$',
                      ),
                    );
                  },
                ),
    );
  }
}
