//ürünlerin benzersiz id'lerini tutar (id,başlık,görsel.etc)
class UrunModel {
  final int id;
  final String baslik;
  final String resimUrl;
  final double fiyat;
  final String kategori;
//object oluşturmak için constructor oluşturduk, object oluşturulurken required yani bu nesneleri kullanmak zorundayız
  const UrunModel({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
  });
//JSON'dakileri urunmodel objectlerine dönüştürmek için factory kullanıyoruz
//map ile jsondan strings olarak gelir ve sonra dynamic yani herhangi bir veri türü algılayacak 
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id: json['id'] as int? ?? 0, // jsondan çekilen int null ise 0 dödürür
      baslik: json['title'] as String? ?? 'İsimsiz Ürün', //jsondan çekilen string null ise isimsiz ğrğn olarak döner
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,//jsondan çekilen double null ise 0.0 dndürür
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150', // jsondan çekilen string null ise url adresi döner
      kategori: json['category'] as String? ?? 'Genel', // jsondan çekilen string null ise genel olarak döner
    );
  }

// urunlerin varolan haliyle kopyalanır copywith ile saklanır
  UrunModel copyWith({
    //parametrelere yeni dğer vermek zorunlu değil
    int? id,
    String? baslik,
    double? fiyat,
    String? resimUrl,
    String? kategori,
  }) {
    //buradaki dönen parametrelere yeni bir değer atanmadıysa eski haliyle kalır
    return UrunModel(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      fiyat: fiyat ?? this.fiyat,
      resimUrl: resimUrl ?? this.resimUrl,
      kategori: kategori ?? this.kategori,
    );
  }
}
