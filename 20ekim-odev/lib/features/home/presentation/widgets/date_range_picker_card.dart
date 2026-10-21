// Flutter malzeme tasarımı ve tarih seçici sınıflarını içeri aktarır
import 'package:flutter/material.dart';

/// DateRangePickerCard: Kullanıcının kiralama başlangıç ve bitiş tarihlerini
/// takvim üzerinden kolayca seçmesini sağlayan tıklanabilir kart bileşenidir.
class DateRangePickerCard extends StatelessWidget {
  // Seçili olan tarih aralığı
  final DateTimeRange dateRange;

  // Yeni tarih aralığı seçildiğinde çalışan geri çağırım fonksiyonu
  final ValueChanged<DateTimeRange> onDateChanged;

  // DateRangePickerCard sabit kurucu metodu
  const DateRangePickerCard({
    super.key,
    // Tarih aralığı parametresi zorunludur
    required this.dateRange,
    // Tarih değişim geri çağırımı zorunludur
    required this.onDateChanged,
  });

  /// Flutter'ın standart tarih aralığı seçici (DateRangePicker) penceresini açar
  void _selectDates(BuildContext context) async {
    final now = DateTime.now();
    // Saat ve dakika bileşenlerini sıfırlayarak bugünün saf tarihini al (Assertion hatasını önler)
    final today = DateTime(now.year, now.month, now.day);
    // Ekranda takvim aralığı seçicisini aç ve kullanıcının seçimini bekle
    final picked = await showDateRangePicker(
      context: context,
      // Seçilebilecek ilk tarih: Bugün
      firstDate: today,
      // Seçilebilecek son tarih: Bugünden itibaren 180 gün (yaklaşık 6 ay)
      lastDate: today.add(const Duration(days: 180)),
      // Başlangıçta işaretli olacak tarih aralığı
      initialDateRange: dateRange,
    );
    // Kullanıcı bir seçim yaptıysa (İptal etmediyse)
    if (picked != null) {
      // Yeni aralığı geri çağırımla bildir
      onDateChanged(picked);
    }
  }

  // Tarih nesnesini iki basamaklı GG.AA.YYYY formatında metne çevirir
  String _format(DateTime date) => '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  @override
  Widget build(BuildContext context) {
    // Saat/dakika sapmalarından etkilenmeden başlangıç ve bitiş arasındaki net gün sayısını hesaplar (En az 1 gün)
    final start = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
    final end = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);
    final diff = (end.difference(start).inHours / 24.0).round();
    final days = diff > 0 ? diff : 1;
    return Card(
      // Tıklanma dalgalanma efekti (Ripple) sağlayan InkWell
      child: InkWell(
        // Kartın köşeleriyle uyumlu 16px yuvarlak dalga sınırı
        borderRadius: BorderRadius.circular(16),
        // Tıklandığında takvim seçici diyaloğunu açar
        onTap: () => _selectDates(context),
        child: Padding(
          // Kart içi yatay 16px, dikey 12px boşluk
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Sol baştaki tema renkli takvim ikonu
              Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              // Tarih bilgilerini gösteren esnek sütun
              Expanded(
                child: Column(
                  // Metinleri sola hizalar
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alış, iade ve toplam gün sayısı başlığı
                    Text('Alış & İade Tarihi ($days Gün)', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 2),
                    // Formatlanmış başlangıç ve bitiş tarihleri
                    Text(
                      '${_format(dateRange.start)} - ${_format(dateRange.end)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Sağ taraftaki sağ ok ikonu
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
