import 'package:flutter/material.dart';
import '../../data/models/rental_station_model.dart';

/// StationLocationsSheet: Araç teslim alma ve iade noktalarını
/// interaktif harita pinleri ve istasyon listesi üzerinden seçtiren alt sayfadır.
class StationLocationsSheet extends StatelessWidget {
  final List<RentalStationModel> stations;
  final RentalStationModel? selectedStation;
  final ValueChanged<RentalStationModel> onSelect;

  const StationLocationsSheet({
    super.key,
    required this.stations,
    required this.selectedStation,
    required this.onSelect,
  });

  // 40 satır kuralına uygun ana build metodu
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMapHeader(context),
          const SizedBox(height: 14),
          _buildInteractiveMap(context),
          const SizedBox(height: 14),
          Flexible(child: _buildStationList()),
        ],
      ),
    );
  }

  /// Harita başlığı ve kapat butonu
  Widget _buildMapHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Harita Üzerinden Teslim Noktası Seçimi', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
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
          Center(
            child: Icon(Icons.navigation_outlined, size: 70, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          ),
          Positioned(
            top: 14,
            left: 20,
            child: _mapPin(context, 'İST Havalimanı', true),
          ),
          Positioned(
            bottom: 20,
            right: 24,
            child: _mapPin(context, 'SAW Havalimanı', false),
          ),
          Positioned(
            top: 24,
            right: 80,
            child: _mapPin(context, 'Levent Metro', false),
          ),
          Positioned(
            bottom: 16,
            left: 70,
            child: _mapPin(context, 'Kadıköy Rıhtım', false),
          ),
        ],
      ),
    );
  }

  Widget _mapPin(BuildContext context, String title, bool active) {
    final color = active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, size: 24, color: color),
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
          leading: Icon(isSel ? Icons.check_circle : Icons.location_on_outlined, color: isSel ? Colors.green : null),
          title: Text(st.name, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
          subtitle: Text('${st.district} • Koordinat: ${st.latitude.toStringAsFixed(2)}, ${st.longitude.toStringAsFixed(2)}'),
          onTap: () {
            onSelect(st);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
