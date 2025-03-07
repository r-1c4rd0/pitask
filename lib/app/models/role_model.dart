import 'parents/model.dart';

class Role extends Model {
  String? id;
  String? name;
  bool? isdDefault;

  Role({this.id, this.name, this.isdDefault});

  Role.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name', defaultLocale: '');
    isdDefault = boolFromJson(json, 'default');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['default'] = this.isdDefault;
    return data;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || super == other && other is Role && runtimeType == other.runtimeType && id == other.id && name == other.name && isdDefault == other.isdDefault;

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ name.hashCode ^ isdDefault.hashCode;
}
