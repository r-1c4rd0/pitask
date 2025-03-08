import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'parents/model.dart';

class Address extends Model {
  String? id;
  String? description;
  String? address;
  double? latitude;
  double? longitude;
  bool? isDefault;
  String? userId;

  Address({
    this.id,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.userId,
  });

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    description = json['description'] as String?;
    address = json['address'] as String?;
    latitude = (json['latitude'] as num?)?.toDouble();
    longitude = (json['longitude'] as num?)?.toDouble();
    isDefault = json['default'] as bool?;
    userId = json['user_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'default': isDefault,
      if (userId != null) 'user_id': userId,
    };
  }

  bool isUnknown() {
    return latitude == null || longitude == null;
  }

  String get getDescription {
    if (hasDescription()) return description!;
    return address != null ? address!.substring(0, min(address!.length, 10)) : "Unknown";
  }

  bool hasDescription() {
    return description != null && description!.isNotEmpty;
  }

  LatLng getLatLng() {
    return isUnknown() ? LatLng(38.806103, 52.4964453) : LatLng(latitude!, longitude!);
  }
}
