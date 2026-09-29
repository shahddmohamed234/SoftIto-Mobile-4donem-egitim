//1. Cihaz Tiplerini Oluşturun
enum CihazTipleri { sensor, gateway, edgeServer, router }

//8. Cihaz Erişilemiyorsa Exception Fırlatın
class CihazErisilemezException implements Exception {
  final String mesaj;
  CihazErisilemezException(this.mesaj);

  @override
  String toString() => "CihazErisilemezException: $mesaj";
}

//2. IoTCihaz Sınıfını Oluşturun
class IotCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipleri tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  final Set<String> acikPortlar;
  final bool sslSertikasiGecerliMi;

  final bool cihazAcikMi;

  IotCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    this.sslSertikasiGecerliMi =false,
    this.cihazAcikMi = true,
  });

  //Güvenlik açığı kontrolü
  bool get guvenliAcigiVarMi =>
      !sslSertikasiGecerliMi || acikPortlar.contains("23/TELNET");

  void baglantiKur() {
    if (!cihazAcikMi) {
      throw CihazErisilemezException(
        "$cihazAdi (Seri No: $seriNo) kapalı durumda",
      );
    }
    print("Bağlantı başarılı: $cihazAdi");
  }
}

//6.Seri Numarasına Göre Cihaz Bulma
({String cihazAdi, CihazTipleri tip, bool alarmDurumu}) cihazBilgisiBul({
  required List<IotCihaz> cihazListesi,
  required String arananSeriNo,
}) {
  for (var cihaz in cihazListesi) {
    if (cihaz.seriNo == arananSeriNo) {
      bool alarm = cihaz.guvenliAcigiVarMi || cihaz.cpuYukYuzdesi > 85.0;
      return (cihazAdi: cihaz.cihazAdi, tip: cihaz.tip, alarmDurumu: alarm);
    }
  }

  throw Exception("$arananSeriNo seri numaralı cihaz ağda bulunamadı");
}

//7. Cihaz Tipine Göre İzolasyon Bölgesi
String izolasyonBolgesi(CihazTipleri tip) {
  return switch (tip) {
    CihazTipleri.sensor => "ZONE-S",
    CihazTipleri.gateway => "ZONE-G",
    CihazTipleri.edgeServer => "ZONE-E",
    CihazTipleri.router => "ZONE-R",
    _ => "Tanınmayan Bir Cihaz",
  };
}

void main() {
  print("IoT Ağ Yönetim Paneli");
  print("-----------------------------------");

  //3. Cihazları Oluşturun
  List<IotCihaz> agCihazlari = [
    IotCihaz(
      seriNo: "SN-100",
      cihazAdi: "Giriş Sensörü",
      tip: CihazTipleri.sensor,
      cpuYukYuzdesi: 15.5,
      bellekMb: 128,
      acikPortlar: {"80/HTTP"},
      sslSertikasiGecerliMi: true,
    ),

    IotCihaz(
      seriNo: "SN-200",
      cihazAdi: "Ana Gateway",
      tip: CihazTipleri.gateway,
      cpuYukYuzdesi: 92.0,
      bellekMb: 1024,
      acikPortlar: {"443/HTTPS"},
      sslSertikasiGecerliMi: true,
    ),

    IotCihaz(
      seriNo: "SN-300",
      cihazAdi: "Kenar Sunucu",
      tip: CihazTipleri.edgeServer,
      cpuYukYuzdesi: 45.0,
      bellekMb: 4096,
      acikPortlar: {"443/HTTPS", "23/TELNET"},
      sslSertikasiGecerliMi: true,
    ),

    IotCihaz(
      seriNo: "SN-400",
      cihazAdi: "Şube Router",
      tip: CihazTipleri.router,
      cpuYukYuzdesi: 30.0,
      bellekMb: 512,
      acikPortlar: {"443/HTTPS"},
      sslSertikasiGecerliMi: false,
    ), 

    IotCihaz(
      seriNo: "SN-500",
      cihazAdi: "Arka Sensör",
      tip: CihazTipleri.sensor,
      cpuYukYuzdesi: 5.0,
      bellekMb: 128,
      acikPortlar: {},
      sslSertikasiGecerliMi: true,
      cihazAcikMi: false,
    ), 

    IotCihaz(
      seriNo: "SN-600",
      cihazAdi: "Yedek Router",
      tip: CihazTipleri.router,
      cpuYukYuzdesi: 20.0,
      bellekMb: 512,
      acikPortlar: {"443/HTTPS", "22/SSH"},
      sslSertikasiGecerliMi: true,
    ), 
  ];

  //4. Riskli Cihazları Bulun

  print("Riskli Cihazlar Raporu");
  final riskliCihazlar = agCihazlari.where((c)=> c.guvenliAcigiVarMi || c.cpuYukYuzdesi >85.0).toList();
  for(var cihaz in riskliCihazlar){
    print("⚠️  ${cihaz.cihazAdi} (SN: ${cihaz.seriNo}) riskli olarak işaretlendi");
  }

  //5. Toplam Bellek Kullanımını Hesaplayın
  print("\n Ağ Kaynak Kullanımı");
  final toplamBellek = agCihazlari.fold(0, (toplam,cihaz)=>toplam + cihaz.bellekMb);
  print("Toplam Cihaz Belleği: $toplamBellek MB");

  //6.Seri Numarasına Göre Cihaz Bulma
  print("\n Cihaz Arama");
  String aranan = "SN-300";
  try{
    final aramaSonucu = cihazBilgisiBul(cihazListesi: agCihazlari, arananSeriNo: aranan);
    final (:cihazAdi ,:tip, :alarmDurumu) = aramaSonucu;
    print("Bulunan: ${cihazAdi} | Tip ${tip.name} | Alarm: ${alarmDurumu ? 'AKTİF' : 'NORMAL'}");
  }catch (e){
    print("Arama Hatası: $e");
  }
// 7. Cihaz Tipine Göre İzolasyon Bölgesi
print("\nİzolasyon Bölge");
for(var cihaz in agCihazlari){
  print("${cihaz.cihazAdi.padRight(15)}: ${izolasyonBolgesi(cihaz.tip)}");
}

// 8. Cihaz Erişilemiyorsa Exception Fırlatın (try-catch)
  print("\nBAĞLANTI TESTİ");
  for (var cihaz in agCihazlari) {
  try{
    cihaz.baglantiKur();
  } on CihazErisilemezException catch (e){
    print("Hata: ${e.mesaj}");
  } catch (e){
    print("Beklenmeyen Hata: $e");
  }
}

}
