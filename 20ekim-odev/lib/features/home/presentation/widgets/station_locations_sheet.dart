// Flutter malzeme tasarımı ve alt sayfa (BottomSheet) kütüphanesini içeri aktarır
import 'package:flutter/material.dart';
// Kiralama istasyonu veri modelini içeri aktarır
import '../../data/models/rental_station_model.dart';

/// StationLocationsSheet: Araç teslim alma ve iade noktalarını
/// interaktif harita pinleri ve istasyon listesi üzerinden seçtiren alt sayfadır.
class StationLocationsSheet extends StatelessWidget {
  // Gösterilecek istasyonlar listesi
  final List<RentalStationModel> stations;

  // Şu anda seçili olan istasyon nesnesi
  final RentalStationModel? selectedStation;

  // Yeni bir istasyon seçildiğinde çalışan geri çağırım fonksiyonu
  final ValueChanged<RentalStationModel> onSelect;

  // StationLocationsSheet sabit kurucu metodu
  const StationLocationsSheet({
    super.key,
    // İstasyon listesi zorunludur
    required this.stations,
    // Seçili istasyon parametresi zorunludur
    required this.selectedStation,
    // Seçim fonksiyonu zorunludur
    required this.onSelect,
  });

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    // Çentik ve gezinme çubuğunu koruyan güvenli alan
    return SafeArea(
      // Ekran yüksekliğinin maksimum %85'ini aşmasını önleyen sınırlayıcı kutu
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        // Yuvarlak üst köşeli alt sayfa konteyneri
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Kısım: Harita başlığı ve kapatma butonu
              _buildMapHeader(context),
              const SizedBox(height: 14),
              // 2. Kısım: Simüle edilmiş görsel pinli harita
              _buildInteractiveMap(context),
              const SizedBox(height: 14),
              // 3. Kısım: Kaydırılabilir istasyon seçim listesi
              Flexible(child: _buildStationList()),
            ],
          ),
        ),
      ),
    );
  }

  /// Harita başlığı ve kapat butonu (Yatay taşmaya karşı korumalı)
  Widget _buildMapHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Sol başlık ve ikon (Taşmayı önlemek için Expanded ile sarılı)
        Expanded(
          child: Row(
            children: [
              Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Harita Üzerinden Teslim Noktası Seçimi',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Sağ üstteki kapatma (X) butonu
        IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ],
    );
  }

  /// Görsel ve pinli simüle harita bileşeni
  Widget _buildInteractiveMap(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Stack(
        children: [
          // Merkezdeki navigasyon pusula ikonu
          Center(
            child: Icon(Icons.navigation_outlined, size: 70, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          ),
          // İstanbul Havalimanı pini
          Positioned(
            top: 14,
            left: 20,
            child: _mapPin(context, 'İST Havalimanı', true),
          ),
          // Sabiha Gökçen Havalimanı pini
          Positioned(
            bottom: 20,
            right: 24,
            child: _mapPin(context, 'SAW Havalimanı', false),
          ),
          // Levent Metro pini
          Positioned(
            top: 24,
            right: 80,
            child: _mapPin(context, 'Levent Metro', false),
          ),
          // Kadıköy Rıhtım pini
          Positioned(
            bottom: 16,
            left: 70,
            child: _mapPin(context, 'Kadıköy Rıhtım', false),
          ),
        ],
      ),
    );
  }

  /// Harita üzerindeki konum pinini inşa eden yardımcı metot
  Widget _mapPin(BuildContext context, String title, bool active) {
    final color = active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Konum iğnesi ikonu
        Icon(Icons.location_on, size: 24, color: color),
        // Pin etiket kutucuğu
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Text(title, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
        ),
      ],
    );
  }

  /// İstasyonların listelendiği seçim alanı
  Widget _buildStationList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: stations.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final st = stations[index];
        final isSel = selectedStation?.id == st.id;
        return ListTile(
          // Seçili ise yeşil onay, değilse standart konum ikonu
          leading: Icon(isSel ? Icons.check_circle : Icons.location_on_outlined, color: isSel ? Colors.green : null),
          // İstasyon adı
          title: Text(st.name, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
          // İlçe ve GPS koordinatları bilgisi
          subtitle: Text('${st.district} • Koordinat: ${st.latitude.toStringAsFixed(2)}, ${st.longitude.toStringAsFixed(2)}'),
          // Tıklandığında istasyonu seçip alt sayfayı kapatır
          onTap: () {
            onSelect(st);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
