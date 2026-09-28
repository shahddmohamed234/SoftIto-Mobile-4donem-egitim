// 1. Enumları (derleme zaman güvenliği) - Olası seçenekleri sabitleyerek yazım hatalarını önler.
enum HizmetKategorisi {
  ciltYenileme,
  medikalEstetik,
  lazerEpilasyonu,
  Lipo,
} // Kliniğin sunduğu ana hizmet türleri.

enum SeansDurumu {
  bekliyor,
  odadaIslemde,
  tamamlandi,
  iptalEdildi,
} // Bir randevunun geçebileceği aşamalar.

enum OdemeYontemi {
  krediKarti,
  havaleEft,
  nakit,
  klinikPaketKredisi,
} // Kabul edilen geçerli ödeme yöntemleri.

// Danışan (müşteri) Modeli - Müşteri bilgilerini tutacak kalıp sınıfımız.
class Danisan {
  final String id; // Danışana ait benzersiz kimlik numarası (değiştirilemez).
  final String adSoyad; // Danışanın tam adı (değiştirilemez).
  final String telefon; // İletişim numarası (değiştirilemez).
  final bool
  vipUyeMi; // VIP müşteri olup olmadığını belirten doğru/yanlış değeri.
  final List<String> alerjiler; // Danışanın alerjilerini tutan liste (boş olabilir ama null olamaz).
  final String?
  ozelCiltNotu; // Ciltle ilgili özel durumlar (opsiyonel, null olabilir).

  const Danisan({
    // Sınıfın kurucu metodu (Constructor) - Nesne oluştururken verileri alır.
    required this.id, // ID girilmesi zorunlu kılındı.
    required this.adSoyad, // Ad soyad girilmesi zorunlu kılındı.
    required this.telefon, // Telefon girilmesi zorunlu kılındı.
    this.vipUyeMi =
        false, // Belirtilmezse varsayılan olarak VIP değil (false) sayılır.
    this.alerjiler =
        const [], // Belirtilmezse varsayılan olarak boş liste atanır.
    this.ozelCiltNotu, // İsteğe bağlı alan.
  });

  bool get hassasCiltMi => alerjiler.isNotEmpty; // Alerji listesi doluysa otomatik olarak hassas ciltli kabul eden getter.

  // Bilgi özet kartı - Danışanın temel bilgilerini formatlayıp tek bir metin olarak döndürür.
  String get bilgiOzeti {
    final String alerjiBilgisi =
        alerjiler
            .isEmpty // Alerji listesi boş mu diye kontrol ediliyor.
        ? "Kayıtlı Alerji Yok" // Boşsa bu metin yazılır.
        : "Alerjiler : ${alerjiler.join(',')}"; // Doluysa alerjiler araya virgül konularak birleştirilir.
    final String notBilgisi =
        ozelCiltNotu ??
        "Özel Medikal not girilmemiş"; // Not null ise varsayılan metin atanır.
    final String vipRozeti = vipUyeMi
        ? "VIP"
        : "Standart"; // VIP ise "VIP", değilse "Standart" metni seçilir.
    return "$vipRozeti $adSoyad ($telefon | $alerjiBilgisi | Not: $notBilgisi"; // Seçilen tüm bilgiler şık bir metin (string) olarak birleştirilip döndürülür.
  }
}

// Seans (randevu) Modeli - Yapılan her bir işlemi ve randevuyu temsil eden sınıf.
class SeansKaydi {
  final String seansKodu; // Randevuya özel benzersiz kod.
  final Danisan
  danisan; // Randevuyu alan müşterinin (Danisan nesnesinin) ta kendisi.
  final HizmetKategorisi
  kategori; // Hangi kategoriden hizmet alınacağı (Enum'dan).
  final String islemAdi; // Yapılacak spesifik işlemin adı (örn: Yüz temizleme).
  final double birimFiyati; // İşlemin tek bir seanslık fiyatı.
  final int seansSayisi; // Kaç seanslık bir paket alındığı.
  final double
  indirimOrani; // Uygulanan yüzdelik indirim oranı (örn: 10.0 = %10).
  final String? sorumluUzman; // İşlemi yapacak personelin adı (henüz atanmamış olabilir, null alabilir).
  SeansDurumu durum; // Randevunun güncel durumu (bekliyor, tamamlandı vb. - zamanla değişebilir).
  OdemeYontemi?
  odemeTipi; // Ödemenin nasıl yapıldığı (henüz ödenmemişse null olabilir).

  SeansKaydi({
    // SeansKaydi nesnesi oluşturmak için kurucu metot.
    required this.seansKodu, // Seans kodu zorunlu.
    required this.danisan, // Müşteri bilgisi zorunlu.
    required this.kategori, // Kategori seçimi zorunlu.
    required this.islemAdi, // İşlem adı zorunlu.
    required this.birimFiyati, // Fiyat zorunlu.
    this.seansSayisi = 1, // Belirtilmezse varsayılan 1 seans kabul edilir.
    this.indirimOrani = 0.0, // Belirtilmezse indirim yok (%0) kabul edilir.
    this.sorumluUzman, // Opsiyonel uzman ataması.
    this.durum = SeansDurumu.bekliyor, // Yeni açılan seans varsayılan olarak "bekliyor" durumundadır.
    this.odemeTipi, // Opsiyonel ödeme tipi kaydı.
  });

  double get brutTutar => birimFiyati * seansSayisi; // İndirimsiz toplam fiyatı hesaplayan getter (birim x miktar).

  double get indirimTutari {
    // Net indirim miktarını (para cinsinden) hesaplayan getter bloğu.
    double toplamOran = indirimOrani; // Parametre olarak gelen indirim oranını bir değişkene alıyoruz.
    if (danisan.vipUyeMi) {
      // Eğer randevuyu alan müşteri VIP ise...
      toplamOran += 10.0; // ...mevcut indirime ekstra %10 daha ekliyoruz.
    }
    return brutTutar * (toplamOran / 100.0); // Brüt tutarın toplam indirim yüzdesine denk gelen kısmını matematiksel olarak hesaplayıp döndürüyoruz.
  }

  double get netTutar => brutTutar - indirimTutari; // Müşterinin kasada ödeyeceği son fiyat (Brüt eksi İndirim).
}

// Yönetim Servisi - Tüm kliniğin datasını ve operasyonlarını yönetecek beyin sınıf.
class KlinikYoneticisi {
  final String subeAdi; // Kliniğin (şubenin) adı.
  final List<SeansKaydi> _seanslar = []; // Sadece bu sınıf içinden erişilebilen (private) boş bir seans listesi başlatılır.
  final Map<String, Danisan> _danisanRehberi = {}; // Sadece bu sınıf içinden erişilebilen (private) ID'ye göre danışan tutan bir sözlük (Map).

  KlinikYoneticisi({
    required this.subeAdi,
  }); // Sınıf başlatılırken şube adının verilmesini zorunlu kılan kurucu.

  // Danışan Kaydetme - Yeni müşteriyi sisteme ekleyen metot.
  void danisanKaydet(Danisan danisan) {
    _danisanRehberi[danisan.id] = danisan; // Sözlüğe anahtar olarak müşterinin ID'sini, değer olarak da nesnenin kendisini ekliyor.
    print(
      // Kaydın başarılı olduğunu konsola (ekrana) yazdırıyor.
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VIP" : "Standart"})", // VIP durumuna göre dinamik mesaj formatı.
    );
  }

  void randevuOlustur(SeansKaydi seans) {
    // Yeni bir seansı sisteme ekleyen metot.
    _seanslar.add(
      seans,
    ); // Dışarıdan gelen seans nesnesini özel listemize ekliyor.
    print(
      // Kaydın başarılı olduğunu konsola yazdırıyor.
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}", // Kimin hangi işlemi yaptıracağını gösteriyor.
    );
  }

  void seansTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    // Seansı bitirip ödeme alan metot (İsimlendirilmiş parametreler kullanıyor).
    for (var seans in _seanslar) {
      // Kayıtlı tüm seanslar içinde döngü başlatıyor.
      if (seans.seansKodu == seansKodu) {
        // Eğer aradığımız kodla listedeki kod eşleşirse doğru seansı bulduk demektir.
        seans.durum = SeansDurumu.tamamlandi; // Seansın durumunu Enum üzerinden 'tamamlandi' olarak güncelliyor.
        seans.odemeTipi = odeme; // Yapılan ödeme yöntemini seansa kaydediyor.
        print(
          // İşlemin bittiğini konsola haber veriyor.
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})", // Tutarı 2 ondalıklı göstererek ödeme tipini yazdırıyor.
        );
        return; // İşlem bittiği için metottan çıkış yapıyor (Döngüyü boşuna döndürmeye devam etmiyor).
      }
    }
    print(
      "Hata [$seansKodu] kodlu seans bulunamadı",
    ); // Eğer döngü biter ve hiçbir eşleşme bulunmazsa hata mesajı veriyor.
  }

  void seansIptalEt(String seansKodu, {String? iptalNedeni}) {
    // Randevuyu iptal eden metot (iptalNedeni isteğe bağlı).
    for (var seans in _seanslar) {
      // Tüm seansları tarıyor.
      if (seans.seansKodu == seansKodu) {
        // Gelen kod eşleşirse...
        seans.durum =
            SeansDurumu.iptalEdildi; // Durumu iptal edildi olarak değiştiriyor.
        print(
          // İptal işlemini konsola yazdırıyor.
          "Seans İptal Edildi [${seans.seansKodu}] : ${iptalNedeni ?? "Gerekçe Belirtilmedi"}", // Neden null ise varsayılan metni kullanıyor.
        );
        return; // İşlem bitince fonksiyondan çıkıyor.
      }
    }
  }

  // Finansal Rapor metotları (fonksiyonel dart) - Kasa hesaplamaları.
  double get toplamTahsisEdilenCiro =>
      _seanslar // Sadece tamamlanmış seansların toplam parasını hesaplayan getter.
          .where(
            (s) => s.durum == SeansDurumu.tamamlandi,
          ) // Listeyi filtreliyor: Sadece durumu 'tamamlandi' olanları alıyor.
          .fold(0.0, (toplam, s) => toplam + s.netTutar); // Kalanların net tutarlarını 0.0'ın üzerine toplayarak kümülatif bir sonuç çıkarıyor.

  double get beklenenPotansiyelCiro =>
      _seanslar // Henüz bitmemiş ama içeride parası bekleyen seansları hesaplayan getter.
          .where(
            // Filtreleme başlıyor...
            (s) => // Her bir seans (s) için...
                s.durum ==
                    SeansDurumu.bekliyor || // ...durumu bekliyor VEYA (||)...
                s.durum == SeansDurumu.odadaIslemde, // ...odada işlemde olanları seçiyor (iptal edilenleri ve bitenleri almıyor).
          )
          .fold(
            0.0,
            (toplam, s) => toplam + s.netTutar,
          ); // Seçilenlerin net tutarını toplayarak muhtemel geliri hesaplıyor.

  // Kategori bazlı seans dağılımı - Hangi işlemden kaç tane satılmış istatistiği.
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    // Geriye Kategori->Sayı haritası döndüren fonksiyon.
    final Map<HizmetKategorisi, int> dagilim =
        {}; // Sonuçları tutacak boş bir sözlük (Map) oluşturuluyor.
    for (var kat in HizmetKategorisi.values) {
      // Enum'daki mevcut tüm kategorileri sırayla dönüyor.
      dagilim[kat] =
          0; // Her kategori için başlangıç değerini haritada 0 olarak atıyor.
    }
    for (var s in _seanslar) {
      // Mevcut alınan tüm randevuları (seansları) sırayla dönüyor.
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1; // O seansın kategorisini haritada bulup değerini 1 artırıyor (Sayaç mantığı).
    }
    return dagilim; // Doldurulan istatistik haritasını geri döndürüyor.
  }

  Set<String> gorevliUzmanKadrosu() {
    // Benzersiz (tekrarsız) uzman isimlerini çıkaran fonksiyon.
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet(); // Seanslardaki uzmanları al, null olmayan String'leri filtrele ve Set'e çevir.
  }

  // Uzmansız kalan seanslar - Ataması yapılmamış randevuları listeler.
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return _seanslar.where((s) => s.sorumluUzman == null).toList(); // Uzmanı atanmamış (null olan) seansları filtreleyip liste olarak döndürür.
  }

  // Gün sonu raporu - Tüm günün özetini düzgün bir tablo formatında konsola basar.
  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi"); // Başlık yazdırır.
    print(
      "-------------------------------------------",
    ); // Ayraç çizgisi yazdırır.
    print(
      // Tablonun başlık sütunlarını hizalayarak yazdırır.
      "${'Kod'.padRight((10))}| " // 'Kod' yazısını 10 karaktere tamamlayacak kadar sağına boşluk ekler.
      "${'Danışan'.padRight((16))}| " // 'Danışan' yazısını 16 karaktere tamamlar.
      "${'İşlem'.padRight((20))}| " // 'İşlem' yazısını 20 karaktere tamamlar.
      "${'Uzman'.padRight((18))}| " // 'Uzman' yazısını 18 karaktere tamamlar.
      "${'Tutar'.padRight((10))}| " // 'Tutar' yazısını 10 karaktere tamamlar.
      "${'Durum'}| ", // En sona Durum sütununu yazar.
    );
    print(
      "---------------------------------------------",
    ); // Alt çizgi yazdırır.

    for (var s in _seanslar) {
      // Tüm seansları tek tek dolaşarak satırları oluşturur.
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor"; // Uzman atanmamışsa (null) metni "Nöbetçi Bekliyor" yapar.
      final String durumRozeti = switch (s.durum) {
        // Dart 3'ün harika Switch Expression'ı ile enum durumuna göre metin atar.
        SeansDurumu.tamamlandi => "Tamamlandı", // Tamamlandıysa bu metni seç.
        SeansDurumu.odadaIslemde => "İşlemde", // İşlemdeyse bu metni seç.
        SeansDurumu.bekliyor => "Bekliyor", // Bekliyorsa bu metni seç.
        SeansDurumu.iptalEdildi => "İptal", // İptal ise bu metni seç.
      };

      print(
        // Bulunan her seansın verilerini yukarıdaki sütun genişliklerine (padRight) uygun olarak ekrana basar.
        "${s.seansKodu.padRight((10))}| " // Seans kodu 10 hane.
        "${s.danisan.adSoyad.padRight((10))}| " // İsim 10 hane
        "${s.islemAdi.padRight((10))}| " // İşlem 10 hane
        "${uzman.padRight((10))}| " // Uzman 10 hane
        "${s.netTutar.toStringAsFixed(2).padRight((10))}| " // Tutar ondalıklı sayıya çevrilip 10 haneye tamamlanır.
        "${durumRozeti}| ", // Son sütuna durum eklenir.
      );
    }

    print("-----------------------------------------"); // Rapor alt çizgisi.
    print("Finansal Özet:"); // Finans bölümü başlığı.
    print(
      // Kasadaki mevcut gerçekleşmiş parayı yazar.
      "* Gerçekleşen (kasadaki net ciro) : ${toplamTahsisEdilenCiro.toStringAsFixed(2)}",
    );
    print(
      // Gelecek olan muhtemel parayı yazar.
      "* Bekleyen Potansiyel Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    print(
      "* Toplam Seans : ${_seanslar.length} Randevu",
    ); // Listedeki toplam eleman sayısını ekrana basar.
    print("------------------------------------------------"); // Bölüm ayırıcı.
    print("Aktif Uzmanlar"); // Uzman listesi başlığı.
    final uzmanlar = gorevliUzmanKadrosu(); // Tekrarsız uzmanlar kümesini (Set) değişkene alır.
    if (uzmanlar.isEmpty) {
      // Eğer set boşsa...
      print("Kayıtlı Uzman Bulunamadı"); // ...uzman yok mesajı verir.
    } else {
      // Kümede veri varsa...
      print(
        "${uzmanlar.join(',')}",
      ); // ...uzman isimlerini virgülle birleştirip yazdırır.
    }
    final uzmansizlar =
        uzmansizSeanslariGetir(); // Ataması yapılmamış seansları listeye alır.
    if (uzmansizlar.isNotEmpty) {
      // Eğer bu liste boş değilse (uzmansız seans varsa)...
      print(
        // ...dikkat/uyarı mesajı basar.
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      for (var u in uzmansizlar) {
        // Hangi seansların uzmansız olduğunu tek tek ekrana basar.
        print(
          "->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})",
        ); // Uzmansız seansın kodu, danışanı ve işlemi.
      }
    }
    print("-------------------------"); // Raporun son çizgisi.
  }
}

void main() {
  // Dart uygulamasının çalışmaya başladığı ana giriş noktası.
  print("Klinik Yönetim Sistemi Başlatılıyor...."); // Sistem açılış mesajı.
  final yonetici = KlinikYoneticisi(
    subeAdi: "SoftIto Bağcılar Şubesi",
  ); // Yönetici nesnesini ilgili şube ismiyle ayağa kaldırır.

  // Danışanları oluşturalım - Örnek müşteri verileri tanımlanıyor.
  final d1 = Danisan(
    // Ahmet Yılmaz için yeni bir Danışan nesnesi oluşturulur.
    id: "DAN-101", // Müşteri no.
    adSoyad: "Ahmet Yılmaz", // Müşteri adı.
    telefon: "0555 555 55 55", // İletişim.
    vipUyeMi: true, // VIP müşteri olarak işaretlenmiş.
    alerjiler: ["Retinol,Aspirin"], // Alerji listesi eklenmiş.
    ozelCiltNotu: "Cilt Bariyeri Hassas", // Özel cilt notu düşülmüş.
  );
  final d2 = Danisan(
    // Ahmet Yılan için standart bir Danışan nesnesi oluşturulur.
    id: "DAN-102", // Müşteri no.
    adSoyad: "Ahmet Yılan", // Müşteri adı.
    telefon: "0555 523 35 11", // İletişim.
    vipUyeMi: false, // VIP değil (standart üye).
    alerjiler: ["Retinol"], // Sadece retinol alerjisi var.
  ); // OzelCiltNotu girilmemiş, otomatik null olur.
  final d3 = Danisan(
    // Shahd Ragab için Danışan nesnesi.
    id: "DAN-103", // Müşteri no.
    adSoyad: "Shahd Ragab", // Müşteri adı.
    telefon: "0555 555 55 55", // İletişim.
    vipUyeMi: true, // VIP üye.
    alerjiler: [], // Alerjisi yok (boş liste).
    ozelCiltNotu: "Cilt Bariyeri Hassas ve Kuru", // Özel not.
  );
  final d4 = Danisan(
    // Merva Çolak için Danışan nesnesi.
    id: "DAN-104", // Müşteri no.
    adSoyad: "Merva Çolak", // Müşteri adı.
    telefon: "0523 565 12 44", // İletişim.
    vipUyeMi: true, // VIP üye.
    alerjiler: ["Retinol,Aspirin,Asitler"], // Alerji listesi.
  );

  yonetici.danisanKaydet(
    d1,
  ); // Oluşturulan 1. müşteriyi klinik sisteminin rehberine kaydeder.
  yonetici.danisanKaydet(d2); // 2. müşteriyi kaydeder.
  yonetici.danisanKaydet(d3); // 3. müşteriyi kaydeder.
  yonetici.danisanKaydet(d4); // 4. müşteriyi kaydeder.

  print("Danışan güvenlik kontrolü"); // Konsolda bilgi bloğu ayırıcı metni.
  print(d1.bilgiOzeti); // Ahmet Yılmaz'ın "bilgiOzeti" getter'ını çalıştırıp formatlı metni ekrana basar.
  print(d2.bilgiOzeti); // Ahmet Yılan'ın formatlı özetini ekrana basar.
  print("--------------------------------"); // Ayraç çizgisi.

  // Randevular oluşturuluyor - Müşterilere seans kayıtları bağlanıyor.
  final seans1 = SeansKaydi(
    // 1. Seans objesi (Ahmet Yılmaz için).
    seansKodu: "SNS-2026-1", // Benzersiz işlem kodu.
    danisan: d1, // d1 referansını (Ahmet Yılmaz'ı) bu randevuya bağlar.
    kategori: HizmetKategorisi.Lipo, // Lipo kategorisi.
    islemAdi: "Lipo gerisini bilmiyorum", // İşlemin manuel girilen adı.
    birimFiyati: 6500.0, // Tek seans 6500 TL.
    seansSayisi: 2, // Toplam 2 seans yapılacak.
    indirimOrani:
        5.0, // Özel %5 indirim (Vip olduğu için class içinde %15'e çıkacak).
    sorumluUzman: "Sümeyye Arab", // İşlemi yapacak kişi atanmış.
  ); // Durum varsayılan olarak "bekliyor" olur.

  final seans2 = SeansKaydi(
    // 2. Seans objesi (Ahmet Yılan için).
    seansKodu: "SNS-2026-2", // Kod.
    danisan: d2, // Randevu sahibi d2.
    kategori: HizmetKategorisi.ciltYenileme, // Cilt yenileme kategorisi.
    islemAdi: "Sivrex ile yüz temizleme", // İşlem detayı.
    birimFiyati: 2500.0, // Fiyat.
    seansSayisi: 5, // Toplam 5 seans.
    indirimOrani: 15.0, // %15 indirim girilmiş.
    sorumluUzman: "null", // Buraya dikkat! null değeri yerine String olarak "null" metni yazılmış (Yani atama var sayılır).
  );

  final seans3 = SeansKaydi(
    // 3. Seans objesi (Shahd Ragab için).
    seansKodu: "SNS-2026-3", // Kod.
    danisan: d3, // Müşteri nesnesi bağlandı.
    kategori: HizmetKategorisi.lazerEpilasyonu, // Lazer.
    islemAdi: "Tüm Vücut", // İşlem.
    birimFiyati: 25000.0, // Fiyat.
    seansSayisi: 15, // Miktar.
    indirimOrani:
        0.0, // İndirim yok (ama Vip olduğu için arka planda +%10 olacak).
    sorumluUzman: "Tuba Aydın", // Uzman atanmış.
  );

  final seans4 = SeansKaydi(
    // 4. Seans objesi (Merva Çolak için).
    seansKodu: "SNS-2026-4", // Kod.
    danisan: d4, // Müşteri.
    kategori: HizmetKategorisi.medikalEstetik, // Kategori.
    islemAdi: "Burun Estetiği", // İşlem.
    birimFiyati: 1500.0, // Fiyat.
    seansSayisi: 3, // Miktar.
    sorumluUzman: "Alaaddin Odabaşı", // Uzman atanmış.
  );

  yonetici.randevuOlustur(
    seans1,
  ); // Oluşturulan 1. seansı yöneticinin (sistemin) listesine kaydeder.
  yonetici.randevuOlustur(seans2); // 2. seansı kaydeder.
  yonetici.randevuOlustur(seans3); // 3. seansı kaydeder.
  yonetici.randevuOlustur(seans4); // 4. seansı kaydeder.
  print("Seanslar Gönderiliyor"); // Ekrana bilgilendirme metni basar.

  // Seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);
  yonetici.seansTamamla(
    // 1 nolu seansı bitirmek için metodu çağırır.
    seansKodu: "SNS-2026-1", // Hangi kodlu işlemi tamamlayacağını belirtir.
    odeme: OdemeYontemi
        .krediKarti, // Ödemenin kredi kartıyla alındığını belirtir (Enum'dan).
  );

  // Seans 2 başarıyla tamamlanıyor (nakit ödeme);
  yonetici.seansTamamla(
    seansKodu: "SNS-2026-2",
    odeme: OdemeYontemi.nakit,
  ); // 2 nolu işlemi bulup nakit ödendi olarak durumunu günceller.

  // Seans 4 iptal ediliyor (İptal nedeni varışlı)
  yonetici.seansIptalEt(
    // İptal metodunu çağırır.
    "SNS-2026-04", // Buraya dikkat: Kod SNS-2026-4 olarak kayıtlıydı, buraya 04 yazıldığı için sistem bunu bulamayacak ve iptal edemeyecek.
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi", // İptalin nedenini kayda geçer.
  );

  yonetici.gunSonuRaporuYazdir(); // Programın en sonunda bütün bu işlemlerin sonucunu görmek için sistemden gün sonu tablosunu talep eder.
}
