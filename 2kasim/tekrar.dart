//Mülakat için önemli: Sealed sınıflar dışarıdan extends edilmez switch içinde tüm alt sınıflar tüketilmek zorundadır.

sealed class OdemeDurumu {}

class OdemeBasrili extends OdemeDurumu {
  final ({String referansKodu, double tutar}) veri;
  OdemeBasrili(this.veri);
}

class Odemmebasarisiz extends OdemeDurumu {
  final String hataNedeni;
  Odemmebasarisiz(this.hataNedeni);
}

//abstract : içindeki fonksiyonları dışarıya implements ettiğimizde içindeki fonksiyonlara uyma zorunda

abstract class IBankaServisi {
  Future<OdemeDurumu> odemeYap({required double miktar});
}

mixin GuvenlikDenetimiMixin {
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32; // sağlanırsa true
  }
}

mixin AuditLogMixin{
  void islemKaydet(String mesaj){
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman: $mesaj');
  }
}



class GarantiBankasiServisi with GuvenlikDenetimiMixin,AuditLogMixin implements IBankaServisi{
  final String apiAnahtari;
  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odemeYap ({required double miktar}) async{
    if(!tokenGecerliMi(apiAnahtari)){
      islemKaydet('Ödeme Reddedildi. Geçersiz Api Anahtarı');
      return Odemmebasarisiz('Yetkilendirme hatası: Geçersiz Token');
    }
      await Future.delayed(const Duration(milliseconds: 1000));

      islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLAND');

      return OdemeBasrili((referansKodu: 'GRNT - ${DateTime.now().millisecondsSinceEpoch}', tutar: miktar));

    }
  
}

void odemeSonucunuEkranaBas(OdemeDurumu durum){
  final mesaj = switch(durum){
    OdemeBasrili b=> 'Ödeme Başarılı.Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
    Odemmebasarisiz h=> 'Ödeme Başarısız.Gerekçe: ${h.hataNedeni}',
  };

  print(mesaj);
}

void main(){
  final odemeTipi = GarantiBankasiServisi(apiAnahtari: '1234567890shahdshahdyujwbhdkxqbhsuwd');
  final sonuc = odemeTipi.odemeYap(miktar: 1234);
  print(sonuc);
}