

// Ürün servisi işlemlerini tanımlayan soyut sözleşme (interface) sınıfı
import '../models/urun.dart';

abstract class IUrunServisi {
  // Tüm ürünlerin listesini asenkron olarak sunucudan veya bellekten getiren metot
  Future<List<UrunModel>> urunleriGetir();

  // Belirli bir ID'ye sahip tek bir ürünü asenkron olarak getiren metot
  Future<UrunModel?> urunGetirById(int id);
// IUrunServisi soyut sınıfının kapanış parantezi
}
