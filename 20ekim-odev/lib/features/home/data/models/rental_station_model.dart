import 'package:flutter/foundation.dart';

@immutable
class RentalStationModel {
  final String id;
  final String name;
  final String district;
  final String address;
  final double latitude;
  final double longitude;

  const RentalStationModel({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
