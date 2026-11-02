class UrunModel {
  final int id;
  final String baslik;
  final String resimUrl;
  final double fiyat;
  final String kategori;

  const UrunModel({
    required this.id,
    required this.baslik,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
  });

  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id: json['id'] as int? ?? 0,
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      kategori: json['category'] as String? ?? 'Genel',
    );
  }

  UrunModel copyWith({
    int? id,
    String? baslik,
    double? fiyat,
    String? resimUrl,
    String? kategori,
  }) {
    return UrunModel(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      fiyat: fiyat ?? this.fiyat,
      resimUrl: resimUrl ?? this.resimUrl,
      kategori: kategori ?? this.kategori,
    );
  }
}
