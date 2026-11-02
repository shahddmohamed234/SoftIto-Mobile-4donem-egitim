import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/urun.dart';

abstract class IUrunServisi {
  Future<List<UrunModel>> urunleriGetir();
}

class CanliApiUrunServisi implements IUrunServisi {
  static const String base_url = "https://fakestoreapi.com/products";
  static const Duration _zamanAsimi = Duration(seconds: 10);
  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      final yanit = await http
          .get(Uri.parse(base_url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Ağ zaman aşımına uğradı.');
            },
          );
      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu Hatası: ${yanit.statusCode}');
      }
    } catch (e) {
      print('Ağ hatası:$e');
      rethrow;
    }
  }

  
  
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
