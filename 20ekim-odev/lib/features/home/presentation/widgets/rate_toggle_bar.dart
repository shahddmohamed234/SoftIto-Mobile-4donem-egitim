// Flutter malzeme tasarımı ve SegmentedButton bileşenini içeri aktarır
import 'package:flutter/material.dart';
// Fiyatlandırma tarifesi enum'ını (daily, weekly, monthly) içeri aktarır
import '../../data/models/car_model.dart';

/// RateToggleBar: Kullanıcının Günlük, Haftalık ve Aylık tarife modları arasında
/// anlık ve kesintisiz geçiş yapmasını sağlayan şık buton çubuğudur.
class RateToggleBar extends StatelessWidget {
  // Seçili olan fiyatlandırma türü
  final PricingType selectedType;

  // Tarife değiştirildiğinde yeni türü üst bileşene ileten geri çağırım fonksiyonu
  final ValueChanged<PricingType> onTypeChanged;

  // RateToggleBar sabit kurucu metodu
  const RateToggleBar({
    super.key,
    // Seçili tür parametresi zorunludur
    required this.selectedType,
    // Değişim geri çağırımı zorunludur
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Material 3 standartlarında parçalı buton bileşeni
    return SegmentedButton<PricingType>(
      // Gösterilecek tarife segmentleri (Günlük, Haftalık, Aylık)
      segments: const [
        // 1. Segment: Günlük tarife
        ButtonSegment(value: PricingType.daily, label: Text('Günlük')),
        // 2. Segment: Haftalık indirimli tarife
        ButtonSegment(value: PricingType.weekly, label: Text('Haftalık')),
        // 3. Segment: Aylık avantajlı tarife
        ButtonSegment(value: PricingType.monthly, label: Text('Aylık')),
      ],
      // Aktif seçili olan değeri küme olarak bağlar
      selected: {selectedType},
      // Yeni bir segment seçildiğinde değeri iletir
      onSelectionChanged: (set) => onTypeChanged(set.first),
      // Buton çubuğunun kompakt görsel stili ve köşe kavisi
      style: ButtonStyle(
        // Sıkışık ve kompakt görsel yoğunluk
        visualDensity: VisualDensity.compact,
        // 12px yuvarlatılmış köşeler
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
