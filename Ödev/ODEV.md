Görev1:

BAŞLA

EĞER kullanıcı giriş yapmamış İSE
    Giriş Ekranı'na yönlendir
DEĞİLSE
    DÖNGÜ (Kullanıcı siparişi tamamlayana kadar)
        Ürünü seç ve sepete ekle
    DÖNGÜ BİTİR

    EĞER cüzdan bakiyesi < sepet tutarı İSE
        "Bakiye Yükle" uyarısı ver
    DEĞİLSE
        Siparişi onayla
        Sepet tutarını bakiyeden düş

BİTİR

Görev2:
1. Sipariş Oluşturma Endpoint'i:
HTTP Metodu: POST
URL / Endpoint: /api/v1/siparisler
Header: Authorization: Bearer <token> , Content-Type: application/json
Örnek Request Body (JSON):
{
  "coffee_type": "americano",
  "size": "large",
  "quantity": 2,
  "total_price": 4.00
}
Başarılı Sonuç HTTP Durum Kodu: 201 Created
Kullanıcı Giriş Yapmamışsa Dönecek HTTP Durum Kodu: 401 Unauthorized

2. Cüzdan Bakiye Sorgulama Endpoint'i:
HTTP Metodu: GET
URL / Endpoint: /api/v1/kullanici/bakiye
Örnek Response (JSON):  
{
    "bakiye": 185.50,
     "para_birimi": "TRY"
}
Sunucuda Beklenmeyen Hata Çıkarsa Dönecek Durum Kodu: 500 Internal Server Error

**MİNİ MÜLAKAT SORUNUN CEVABI:
GET isteği sunucuda herhangi bir değişiklik yapmadan sadece veri okuduğu için eşgüçlüdür (idempotent); POST isteği ise her tetiklendiğinde yeni bir sipariş kaydı oluşturup bakiye düşürdüğü için eşgüçlü değildir.

Görev3:

1.sorunun cevabı:
Bu sınıfta SRP kuralı bozulmuş çünkü sınıf; sepet hesaplama, ödeme alma, veritabanı işlemleri ve SMS atma gibi birbirinden alakasız bütün işleri tek başına yapıyor. Kısacası her şeyi kendisi yaptığı için bir 'God Class' olmuş.

Bunu çözmek için sınıfı görevlerine göre parçalamamız lazım. Bütün kodları tek bir yerde tutmak yerine SepetServisi, OdemeServisi, SiparisRepository ve BildirimServisi diye ayrı ayrı küçük sınıflar açmalıyız ki her sınıf sadece kendi işine baksın.

2.sorunun cevabı:
Bu durum Open/Closed Prensibi'ne (OCP) aykırıdır. Çünkü bu kurala göre yazdığımız kod yeni özellikler eklemeye açık, ama var olan kodu değiştirmeye kapalı olmalıdır.

