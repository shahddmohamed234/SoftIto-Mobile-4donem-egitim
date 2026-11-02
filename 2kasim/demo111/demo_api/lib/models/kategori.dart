
enum Kategori {

  hepsi,

  elektronik,

  taki,

  erkekGiyim,
  kadinGiyim,

}


extension KategoriExtension on Kategori {
 
  String get gorunenAd {

    switch (this) {
      
      case Kategori.hepsi:
       
        return 'Tümü';

      case Kategori.elektronik:
   
        return 'Elektronik';
   
      case Kategori.taki:

        return 'Takı & Mücevher';

      case Kategori.erkekGiyim:

        return 'Erkek Giyim';

      case Kategori.kadinGiyim:
        // 'Kadın Giyim' metnini döndürür
        return 'Kadın Giyim';
    // Switch bloğu kapanışı
    }
  // gorunenAd getter kapanış parantezi
  }

  // FakeStore REST API'sinden gelen İngilizce ham metni enum türüne dönüştüren fabrika metodu
  static Kategori apiMetnindenUret(String apiMetni) {
    // Gelen ham metni küçük harfe çevirerek eşleştirme yapan switch yapısı
    switch (apiMetni.toLowerCase().trim()) {
      // FakeStore API 'electronics' kategorisi
      case 'electronics':
        // elektronik enum değerini döndürür
        return Kategori.elektronik;
      // FakeStore API 'jewelery' kategorisi
      case 'jewelery':
        // taki enum değerini döndürür
        return Kategori.taki;
      // FakeStore API 'men\'s clothing' kategorisi
      case "men's clothing":
        // erkekGiyim enum değerini döndürür
        return Kategori.erkekGiyim;
      // FakeStore API 'women\'s clothing' kategorisi
      case "women's clothing":
        // kadinGiyim enum değerini döndürür
        return Kategori.kadinGiyim;
      // Beklenmeyen veya bilinmeyen bir kategori geldiğinde devreye giren varsayılan durum
      default:
        // Güvenli varsayılan olarak elektronik atanır
        return Kategori.elektronik;
    // Switch bloğu kapanışı
    }
  // apiMetnindenUret metodu kapanış parantezi
  }
// Extension tanımının kapanış parantezi
}
