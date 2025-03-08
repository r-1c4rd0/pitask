/*
 * Copyright (c) 2020 .
 */

import 'package:get/get.dart';
import '../services/global_service.dart';
import 'parents/model.dart';

class Media extends Model {
  String? id;
  String? name;
  String? url;
  String? thumb;
  String? icon;
  String? size;

  Media({
    this.id,
    this.url,
    this.thumb,
    this.icon,
  }) {
    url ??= "${Get.find<GlobalService>().baseUrl}images/image_default.png";
    thumb ??= "${Get.find<GlobalService>().baseUrl}images/image_default.png";
    icon ??= "${Get.find<GlobalService>().baseUrl}images/image_default.png";
  }

  Media.fromJson(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id']?.toString();
      name = jsonMap['name'];
      url = jsonMap['url'] ?? "${Get.find<GlobalService>().baseUrl}images/image_default.png";
      thumb = jsonMap['thumb'] ?? "${Get.find<GlobalService>().baseUrl}images/image_default.png";
      icon = jsonMap['icon'] ?? "${Get.find<GlobalService>().baseUrl}images/image_default.png";
      size = jsonMap['formatted_size'];
    } catch (e) {
      url = "${Get.find<GlobalService>().baseUrl}images/image_default.png";
      thumb = "${Get.find<GlobalService>().baseUrl}images/image_default.png";
      icon = "${Get.find<GlobalService>().baseUrl}images/image_default.png";
      print("Erro ao processar Media: $e");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "url": url,
      "thumb": thumb,
      "icon": icon,
      "formatted_size": size,
    };
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
          super == other &&
              other is Media &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              url == other.url &&
              thumb == other.thumb &&
              icon == other.icon &&
              size == other.size;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      url.hashCode ^
      thumb.hashCode ^
      icon.hashCode ^
      size.hashCode;
}
