// SSS veri modelini içeri aktarır
import '../models/faq_item_model.dart';

/// MockProfileRepository: Kullanıcı profil sayfası için SSS ve
/// kiralama sözleşme kurallarını sağlayan sahte veri deposudur.
class MockProfileRepository {
  // Singleton deseni: Tüm uygulama boyunca tek bir örnek üzerinden hizmet verir
  static final MockProfileRepository instance = MockProfileRepository._();

  // Dışarıdan yeni nesne oluşturulmasını engelleyen gizli kurucu metot
  MockProfileRepository._();

  // Uygulama kiralama kuralları ve sıkça sorulan sorular sabit veri listesi
  final List<FaqItemModel> _faqs = const [
    // 1. Soru: Süre uzatma kuralı
    FaqItemModel(
      question: 'Kiralama süresini uzatmak istersem ne yapmalıyım?',
      answer: 'Kiralama sürenizi uzatmak için şubeye gitmenize gerek yoktur. Rezervasyonlarım sayfasından "Süre Uzat" butonuna basarak doğrudan sistem üzerinden anında gün bazlı uzatabilirsiniz.',
    ),
    // 2. Soru: Erken teslimatta iade yapılmama kuralı
    FaqItemModel(
      question: 'Erken teslimat durumunda ücret iadesi yapılır mı?',
      answer: 'Hayır. Rezervasyon sözleşmesi ve şirket politikamız gereğince aracı rezerve edilen tarihten önce erken teslim etmeniz durumunda kalan günler için KESİNLİKLE ÜCRET İADESİ YAPILMAZ.',
    ),
    // 3. Soru: Yaş ve ehliyet gereksinimi
    FaqItemModel(
      question: 'Kiralama için minimum yaş ve ehliyet süresi nedir?',
      answer: 'Ekonomik araçlar için en az 21 yaş ve 2 yıllık geçerli ehliyet, lüks ve SUV araçlar için en az 25 yaş ve 3 yıllık ehliyet gereklidir.',
    ),
    // 4. Soru: HGS ve otoyol geçiş ücreti kuralları
    FaqItemModel(
      question: 'HGS ve köprü geçiş ücretleri nasıl tahsil edilir?',
      answer: 'Tüm araçlarımızda HGS mevcuttur. Geçişler teslimat sırasında kontrol edilerek otomatik olarak ekstrenize yansıtılır ve sistemden kartınızla ödenebilir.',
    ),
    // 5. Soru: Kilometre adil kullanım sınırı kuralı
    FaqItemModel(
      question: 'Kilometre sınırı var mı?',
      answer: 'Günlük kiralamalarda 300 km/gün, haftalık ve aylık paketlerde ise sözleşmede belirtilen adil kullanım kotası geçerlidir.',
    ),
  ];

  /// SSS ve kurallar listesini simüle edilmiş kısa bir gecikmeyle döner
  Future<List<FaqItemModel>> getFaqs() async {
    // 200 ms sahte yerel disk/ağ okuma gecikmesi
    await Future.delayed(const Duration(milliseconds: 200));
    // Sabit kurallar listesini döndürür
    return _faqs;
  }
}
