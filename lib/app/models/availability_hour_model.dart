import 'dart:core';
import 'e_provider_model.dart';
import 'parents/model.dart';

class AvailabilityHour extends Model {
  String? id;
  String? day;
  String? startAt;
  String? endAt;
  String? data;
  EProvider? eProvider;

  AvailabilityHour({
    this.id,
    this.day,
    this.startAt,
    this.endAt,
    this.data,
    this.eProvider,
  });

  AvailabilityHour.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    day = json['day'] as String?;
    startAt = json['start_at'] as String?;
    endAt = json['end_at'] as String?;
    data = json['data'] as String?;
    eProvider = json['e_provider'] != null ? EProvider.fromJson(json['e_provider']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (data != null) 'data': data,
      if (eProvider?.id != null) 'e_provider_id': eProvider!.id,
    };
  }

  String toDuration() {
    return '$startAt - $endAt';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AvailabilityHour &&
            id == other.id &&
            day == other.day &&
            startAt == other.startAt &&
            endAt == other.endAt &&
            data == other.data &&
            eProvider == other.eProvider);
  }

  @override
  int get hashCode =>
      id.hashCode ^ day.hashCode ^ startAt.hashCode ^ endAt.hashCode ^ data.hashCode ^ (eProvider?.hashCode ?? 0);
}
