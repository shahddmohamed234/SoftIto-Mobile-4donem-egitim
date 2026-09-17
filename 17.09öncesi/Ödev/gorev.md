3.
a) Ekran görüntüsü ve ekran kaydı

Ekran görüntüsünün alınmaması ve ekran kaydın engellemesi veri sızıntısını önler ve casus yazılımlara (Malware) karşı korur.

Android'un savunma mekanizması: WindowsManager.FLAG_SECURE
IOS'ın savunma mekanizması: UIScreen.isCaptured

Bu savunma mekanizmalar ekranı siyah/beyaz yapar ya da blur olarak görünmesini sağlar.

b) Overlay saldırıları

Bu tür saldırya Gölgeleme Saldırısı denir. Örneğin, bir oyun oynarken aniden belirlenen 'Hediyeni Al!!!' butonu belirler ve ona tıkladığımızda arka planda yani gölgesinde 1000$ havale yap butonu olur ve bankadan o parayı havale eder, banka arka planda çalışmıyorsa da telefon verilerini çalabilir saldırgan. Bunu önlemek için Android'de 'filterTouchesWhenObscured' gibi kodlar kullanır.

c) Root / Jailbreak

Root/Jailbreak yapılmış bir cihazın fabrika kısıtlamarı kırılıp kullanıcının erişimine açılıyor ve kullanıcıya 'Süper Kullanıcı' yetkisi veriliyor ve bu cihazı daha riskli bir hâle getirir. 
Örneğin bir uygulamaya her seferinde giriş yapmamak için session tokenimizi bir veritabanında depolar. Root'lu cihazlarda saldırganın yazdığı zararlı bir uygulama veya cihaza sızan bir kişi, root yetkisiyle bir dosya yöneticisi açar, doğrudan bu gizli klasöre girer ve içindeki veritabanı dosyasını saniyeler içinde kopyalar.

d) SQLite ve şifreleme

Standart SQLITE dosyası verileri diske direkt düz metin yazdığı için herhangi bir şifreleme olmaz ve cihaz için ciddi bir risk oluşturur.

SQLCIPHER ile şifrelemiş dosyalar 256-bit AES askeri düzeyinde bir şifreli blokla şifrelenir. tam dosya şifreleme sağlar ve çalıns abile anahtar olmadan dosya hiç okunamaz tamamen çöp olur saldırgana.

e) Access Token ve Refresh Token

Gerçek hayattan örnek vererek anlatacak olursam; access token otelde giriş anahtarımız gibidir günlük kullanımında sürekli kullanırız. Refresh token ise otelin resepsiyonunda duran kimlıik veya pasaporttur; giriş anahtarımızın (access token) süresi dolduğunda, yenisini çıkarmak için resepsiyona yni bir anahtar çıkartmak için bu kimliği kullannırız.

Access token 15 dakikalık (araştırırken da 1 saate kadar uzayabildiğini okudum) bir ömrü var o da güvenlik risklerini en aza indirmek ve yetkisiz erişim süresini sınırlamak için kısa süreli tasarlanır.
Refresh token ise kullanıcının her seferinde kullanıcı adı ve şifre girmesine gerek kalmadan yeni bir access token alabilmesi için uzun süreli tasarlanmıştır. Kullanıcının gizli bilgilerini içerdiği için daha güvenli bir yerde saklanmalıdır keystore/keychain depolama alanları gibi.

Kullanıcı çıkış yaptığında refresh token iptal edilir (REVOKE) o da sistem güvenliğini sağlamak için kritik bir güvenlik uygulamasıdır.