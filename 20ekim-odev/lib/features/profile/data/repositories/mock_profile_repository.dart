import '../models/faq_item_model.dart';

/// MockProfileRepository: Kullanıcı profil sayfası için SSS ve
/// kiralama sözleşme kurallarını sağlayan sahte veri deposudur.
class MockProfileRepository {
  static final MockProfileRepository instance = MockProfileRepository._();
  MockProfileRepository._();

  // Kiralama kuralları ve sıkça sorulan sorular listesi
  final List<FaqItemModel> _faqs = const [
    FaqItemModel(
      question: 'Kiralama süresini uzatmak istersem ne yapmalıyım?',
      answer: 'Kiralama sürenizi uzatmak için şubeye gitmenize gerek yoktur. Rezervasyonlarım sayfasından "Süre Uzat" butonuna basarak doğrudan sistem üzerinden anında gün bazlı uzatabilirsiniz.',
    ),
    FaqItemModel(
      question: 'Erken teslimat durumunda ücret iadesi yapılır mı?',
      answer: 'Hayır. Rezervasyon sözleşmesi ve şirket politikamız gereğince aracı rezerve edilen tarihten önce erken teslim etmeniz durumunda kalan günler için KESİNLİKLE ÜCRET İADESİ YAPILMAZ.',
    ),
    FaqItemModel(
      question: 'Kiralama için minimum yaş ve ehliyet süresi nedir?',
      answer: 'Ekonomik araçlar için en az 21 yaş ve 2 yıllık geçerli ehliyet, lüks ve SUV araçlar için en az 25 yaş ve 3 yıllık ehliyet gereklidir.',
    ),
    FaqItemModel(
      question: 'HGS ve köprü geçiş ücretleri nasıl tahsil edilir?',
      answer: 'Tüm araçlarımızda HGS mevcuttur. Geçişler teslimat sırasında kontrol edilerek otomatik olarak ekstrenize yansıtılır ve sistemden kartınızla ödenebilir.',
    ),
    FaqItemModel(
      question: 'Kilometre sınırı var mı?',
      answer: 'Günlük kiralamalarda 300 km/gün, haftalık ve aylık paketlerde ise sözleşmede belirtilen adil kullanım kotası geçerlidir.',
    ),
  ];

  /// SSS listesini simüle edilmiş gecikmeyle döner
  Future<List<FaqItemModel>> getFaqs() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _faqs;
  }
}
