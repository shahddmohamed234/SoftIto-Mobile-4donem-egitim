Const
1) Ne işe yarar: İçine girelen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden Kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez CPU ve pil tasarrufu sağlar.


final
1) Ne işe yarar: çalışma zamanında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler
** const ve final farkı: const derlenirken bilinmek zorunda (const pi =3.14) final ise çalışma anında
belirlene bilir(final saat = Datetime.now())--Model sınıflarında alanlar her zaman final olmalıdır.-- **


late
1) ne işe yarar: değişken tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlatılacağı zaman kullanılır. 


required
1) Ne işe yarar: isimlendirilmiş parametrelerde o parametrenin (değişkenin) zorunlu olduğunu belirtir.


@override
1) Ne işe yarar: alt sınıfın üst sınıftan devraldığı metodu ezdiğini belirtir.
2) faydası: eğer üst metod adını yanlış yazarsanız (örnek builds yazarsanız) derleyici @override sayesinde bunu anında hata olarak yakalar.


Null-aware operatörler (? ?? !)
?. - place?.title -> eğer place null ise hata vermez direkt null olarak döner.
?? - if null : final id _ state.userId ?? 10; _> Sol taraf null ise sağdaki (hardcode olan değer) otomatik olarak atanır.
! (null/force): final id = state.userId ! -> Bu kod derleyici "bana güven bu değer o anda kesinlikle null değil" der. Eğer null gelir ise uygulama anında çöker. (ÇOK DİKKATLİ KULLANILMALI)


Spread operatörü (...)
1) ne ise yarar: bir listenin elemanlarını tel tek çıkartıp bulunduğu üst listenin içine ekler. Colum ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p)=>_buildCard(p))






initState()
1) ne zamnan çalışır: Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır.
2) Ne yapar : ScrollController başlatmaları ve ilk api istekleri burda kurulur.
Kural: içinde doğrudan BuilContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır


didChangeDependencies()
1) Ne zaman çalışır : initState()'ten hemen sonra ve widget dinlediği bir (örn: Theme.of(context)) değiştiğinde otomatik tetikler.
2) Ne yapar: BuildContext güvenli bir şekilde erişerek tema veya ekran boyutu bağımlılıkları ile ilgili ilk yüklemler burada yapılır.



build(BuildContext context)
1) Ne zaman çalışır: Sayfa ilk açıldığında, setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır.
Kural: build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği ya da controller başlatma yapılmamalıdır. Sadece UI döndürülmelidir.

dipose()
1) Ne zaman çalışır: widget hafızadan atılmadan hemen önce son bir kez çalışır.
2) Ne yapılır: _controoler.dispose()  stream dinleyecilerin iptalleri burada yapılır.
super.dispose()'un mutlaka son satırda çalıştırılması gerekir.


setState((){})
1) Arka planda ne yapar: State'in bağlı olduğu StatefulElement nesnesine "ben değiştim, build et" sinyali yollar.
2) Nerede kullanılır: sayfa genelini çizdirmez. Sadece onu dinleyen küçük ValueListenableBuilder'a sinyal gönderilir.
** veriyi değişirtiri, değişen veriy egöre tekrar boyamasını ister


ValueNotifier<T>
1) Arka planda ne iş yapar: ChangeNotifier sınıfından türer. Belleğinde tek bir nesne referansı tutar (T_value)
2) Tetikleme Değer atandığında (set value(T value)), eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağrılır. addListener((){})


InheritedWidget
1) Ne yapar : Widget ağacında alttaki childların, aradaki onlarca widget baypas ederek, üst widgetin verisine (state'ine) doğrudan erişmesisini sağlayan soyut bir widgettir.

Material 3 Tasarımı Dili Renk algoritması ve temalar

primary: Ana marka rengimiz
onPrimary: Ana rengin üstüne yazılacak yazı rengi(okunabilirlik açısından)
primaryContainer: Ana rengin yumuşak pastel arka plan tonu
onPrimaryContainer: Ana rengin yumuşak pastel arka plan tonunun üstüne yazılacak yazı (okunabilirlik açısından)
surface: Sayfa arka plan tuvali
onSurface: Sayfa üstündeki ana metin rengi
outlineVariant: İnce sınır ve ayrım cizgilerinin rengi


ThemeMode.system
color: Colors.black.withOpacity(186) //kesinlikle 1 ile 255 sayıları arasında tam sayı olarak girilmelidir **Bu kullanım güncelde istenmiyor**

color:Colors.blackwithValues(alpha:186/255) //double sayı olarak girilmelidir **Güncel ve doğru yöntemdir**


Arayüz Düzen ve Liste Bileşenleri

Expanded ve Flexible
Expanded: Kalan bol alanın TAMAMINI kaplamaya zorlar.
Flexible: Kalan bol alanı paylaştırır. (flex:1, flex:2)
Flex: yan yana iki expanded varsa birine flex2 diğerine flex1 verir bı sayede ekran boyutuna göre otomatik olarak ayarlar.


Stack ve Positioned.
Ne yapar: Widget'ları z ekseininde üst üstüe bindirir.
Positioned: Yalnızca bir Stack içinde çalışır.
top1:10 , right:10 vererek bir resmin sağ üst köşesine bildirim rözeti eklemenizi sağlar.



ListView.builder
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.
ListView.builder ise Geri Dönüşümlü Görünüm alanı Mantığını kullanarak ekranda sadece o an eğer 5 kart görünecekse sadece 5 kartı ram belleğe yükler. Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir.


shrinkWrap: true
Bir ListView  başka bir dikey kaydırıcının (singleChildScrollView) içine konursa Vertical viewPort hatası verir
shrinkWrap true verilerek bu çözebilir ancak: ListView'un sonsuza kayma (sonsuz scroll) özelliği kaybolur.
**Sadece 3 5 elemanınız varsa bunu kullanmalısınız**



InkWell ve GestureDetector
GestureDetector: Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ.
InkWell: tıklandığı an parmağın altında dışa doğru yayılan bir su dalgası efekti verir.

Önemli Kural: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır. Aksi takdirde su dalgası arkada tuvali göremediği için hiçbir şekilde görünmez.


Form Mimarisi

GlobalKey<FormState>

Widget içindeki Form düğümüne doğrudan dışarıdan erişilemiyor. Bu yüzden Widgetin en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz.

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFromFiled validator bloklarını sırayla çalıştırır.

validator :(String ? value)

fonksiyonda bşr hata bulursa geriye String olarak hata metni döndürür.
Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir.
Eğer veri geçerliyse null döner. Flutter için bu alanda hata yok demektir.Null gelmesi

Animasyon Motoru

AnimatedContainer: Genişlik yükseklik padding margin border renk  ve gölge oynatır.
AnimatedOpacity: Görünürlüğü 0.0 ile 1.0 arasında yumuşakça soldurur.
AnimatedScale: Widget merkezinden dışarıya doğru büyütüp küçültür.
AnimatedAlign: Widget kutunun içinde sağdan sola yukarıdan aşağıya karşı konumunu değiştirir.


Curves
İvmelenme Karakterleri

Curves.linear: Sabit hız (robotik hareketler)
Curves.easeInout: Yavaş başlar ortadan hızlanır yavaşça durur.
Curves.bounceOut: Hedefe çarptığında top gibi 2 3 kez yaylanarak seker
Curves.elasticOut: Lastik gibi ileri geri titreyerek yerine oturur.

GoRouter

ShellRouter: alt taraftaki menü, navigasyon bar
sayfasının geri kalanı goRouter olarak geçiyor


context.go('/profil): Route Yönlendirmesidir. Rota tablosunsa hiyerarşiyi takip eder sayfayı temizleyebilir.

context.push('/profil/5): Stack Yönlendrmesidir. Kullanıcı nereded gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler

context.pop() sayfanın en üstteki yığınını kapatır.

state.pathParameters['id']: Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır

/profil?user=berat
state.uri.queryParameters['user'] : Opsiyonelik filtreleme ya da arama zamanlarında kullanılır

Cihaz içi Yerel depolama mimarileri
1) SharedPreferences:
- Küçük Kullanıcı Ayarları
- Düşük güvenirlik 
- Okuma yazma hızları: Okuma hızı orta / yazma hızı yavaş

2) FlutterSecureStoragee:
- Şifre token vb. saklama
- En yüksek güvence
- Orta

3) Hive/Isar:
- Yüksek performanslı nesne depolama
- Orta (isteğe bağlı şifreleme açılabilir)
- Aşırı hızlı

