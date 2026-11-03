import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/urun.dart';
//sözleşme sınıfı: içinde ne varsa tamamen ona uymak zorundayız başka bir sınıfa implements ettiğmizde
abstract class IUrunServisi {
  Future<List<UrunModel>> urunleriGetir();
}

//IUrunservisi sözleşmesini uygulayan sınıf
class CanliApiUrunServisi implements IUrunServisi {
  static const String base_url = "https://fakestoreapi.com/products";
  static const Duration _zamanAsimi = Duration(seconds: 10); // aşım zamanı 10 saniye olarak ayarlandı
  @override
  Future<List<UrunModel>> urunleriGetir() async {
    //internet bağlantısı ve sunucu hatalarını yakalayan try catch
    try {
      final yanit = await http
          .get(Uri.parse(base_url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Ağ zaman aşımına uğradı.');
            },
          ); // get isteği gönderdik, url metnini uriye çevirdik, await ile sunucudan geri dönüş bekler tamamlazmnazsa (timeout) zaman aşımına uğrar ve  ağ zaman aşımına uğradı hatası fırlatır

      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList(); //eğer isteğimiz 200 başarılı bir şekide dönerse sunucudan gelen her json metni listeye dönüşür, map ile, ve işlem sonucu yeni bir liste oluşur
      } else { // 200 doşında kod geleirse hata oluşturur
        throw Exception('Sunucu Hatası: ${yanit.statusCode}');
      }
    } catch (e) { // ve yakalanan hatayı yazdırır
      print('Ağ hatası:$e');
      rethrow;
    }
  }

  
  // belirli bir idye sahip ürünü apiden çağırır ürün bulunmazsa null döer
  Future<UrunModel?> urunGetirById(int id) async {
    try {
      final uri = Uri.parse('$base_url/products/$id');

      final yanit = await http.get(uri).timeout(_zamanAsimi);

      if (yanit.statusCode == 200) {
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);

        final Map<String, dynamic> jsonHaritasi =
            jsonDecode(cozulmusGovde) as Map<String, dynamic>;

        return UrunModel.fromJson(jsonHaritasi);
      } else {
        return null;
      }
    } catch (hata) {
      return null;
    }
  }
}
