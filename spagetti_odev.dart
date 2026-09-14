// 1. SRP ve LSP ÇÖZÜMÜ
class Urun {
  String id;
  String ad;
  double fiyat;
  int stok;
  String tip;

  Urun(this.id, this.ad, this.fiyat, this.stok, this.tip);
}

abstract class Kargolanabilir {
  double kargoUcretiHesapla();
}

class FizikselUrun extends Urun implements Kargolanabilir {
  FizikselUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "FIZIKSEL");

  @override
  double kargoUcretiHesapla() {
    return 29.90;
  }
}

class DijitalUrun extends Urun {
  DijitalUrun(String id, String ad, double fiyat, int stok)
      : super(id, ad, fiyat, stok, "DIJITAL");
}

// 2. ISP ÇÖZÜMÜ 
abstract class IVeritabaniIslemleri {
  void siparisKaydet(String orderId, double tutar);
}

abstract class IOdemeIslemleri {
  void odemeYap(double tutar); 
}

abstract class IBildirimIslemleri {
  void mailGonder(String email, String mesaj);
  void smsGonder(String tel, String mesaj);
}

abstract class IKargoIslemleri {
  void kargoGonder(String orderId, String adres);
}

abstract class IFaturaIslemleri {
  void faturaYazdir(String orderId);
}

class SqliteVeritabani implements IVeritabaniIslemleri {
  @override
  void siparisKaydet(String orderId, double tutar) {
    print("DB calistirildi: INSERT INTO siparisler VALUES ('$orderId', $tutar)");
  }
}

class SmtpMailServisi {
  void mailAt(String to, String body) {
    print("SMTP Mail gonderildi: " + to);
  }
}

class NetgsmSmsServisi {
  void smsYolla(String gsm, String text) {
    print("SMS iletildi: " + gsm);
  }
}

// 3. OCP ÇÖZÜMÜ (
abstract class OdemeYontemi {
  void odemeYap(double tutar);
}

class KrediKartiOdeme implements OdemeYontemi {
  @override
  void odemeYap(double tutar) => print("$tutar TL Kredi kartindan POS ile cekildi.");
}

abstract class Kupon {
  double indirimUygula(double tutar);
}

class Indirim10 implements Kupon {
  @override
  double indirimUygula(double tutar) => tutar * 0.90;
}


class SiparisYoneticisi {
  SqliteVeritabani db = SqliteVeritabani();
  SmtpMailServisi mailci = SmtpMailServisi();
  NetgsmSmsServisi smsci = NetgsmSmsServisi();

  void siparisTamamla(
      String orderId,
      List<Urun> sepet,
      OdemeYontemi odemeYontemi, // OCP için string yerine interface oldu
      String musteriAdi,
      String email,
      String tel,
      String adres,
      Kupon? kupon) { // OCP için string yerine interface oldu
    
    double toplam = 0;

    for (var i = 0; i < sepet.length; i++) {
      if (sepet[i].stok <= 0) {
        print("Hata: " + sepet[i].ad + " tukenmis!");
        return;
      }
      toplam += sepet[i].fiyat;

      // LSP Çözümünün kullanıldığı yer
      if (sepet[i] is Kargolanabilir) {
        toplam += (sepet[i] as Kargolanabilir).kargoUcretiHesapla();
      }
      sepet[i].stok--;
    }

    // OCP Çözümü (
    if (kupon != null) {
      toplam = kupon.indirimUygula(toplam);
    }

    double kdv = toplam * 0.20;
    double sonTutar = toplam + kdv;

    // OCP Çözümü 
    odemeYontemi.odemeYap(sonTutar);
    
    db.siparisKaydet(orderId, sonTutar);
    print("Fatura PDF cikarildi: $orderId");
    mailci.mailAt(email, "Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL");
    smsci.smsYolla(tel, "Siparisiniz onaylandi: $orderId");
    print("MNG Kargo takip fis basildi: $adres");
  }
}

void main() {
  var siparisci = SiparisYoneticisi();

  // Fiziksel ve Dijital ürün ayrımı yapıldı
  var urun1 = FizikselUrun("1", "Kablosuz Mouse", 450.0, 5);
  var urun2 = DijitalUrun("2", "Flutter Kursu E-Kitap", 150.0, 100);

  var sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    "SP-9921",
    sepet,
    KrediKartiOdeme(), // OCP arayüzü
    "Selahaddin",
    "selahaddin@kodvance.com",
    "05551112233",
    "Kadikoy / Istanbul",
    Indirim10(), // OCP arayüzü
  );
}