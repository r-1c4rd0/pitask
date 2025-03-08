import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../common/uuid.dart';
import '../services/settings_service.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'role_model.dart';

class User extends Model {
  String? name;
  String? email;
  String? password;
  Media? avatar;
  String? apiToken;
  String? deviceToken;
  String? phoneNumber;
  bool verifiedPhone;
  String? verificationId;
  String? address;
  String? bio;
  List<Role> roles;
  bool auth;

  User({
    this.name,
    this.email,
    this.password,
    this.apiToken,
    this.deviceToken,
    this.phoneNumber,
    this.verifiedPhone = false,
    this.verificationId,
    this.address,
    this.bio,
    this.avatar,
    this.roles = const [],
    this.auth = false,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        email = json['email'] as String?,
        apiToken = json['api_token'] as String?,
        deviceToken = json['device_token'] as String?,
        phoneNumber = json['phone_number'] as String?,
        verifiedPhone = json['phone_verified_at'] != null,
        avatar = json['avatar'] != null ? Media.fromJson(json['avatar']) : null,
        auth = json['auth'] ?? false,
        roles = (json['roles'] as List?)?.map((v) => Role.fromJson(v)).toList() ?? [] {
    try {
      address = json['custom_fields']?['address']?['view'] ?? json['address'] as String?;
      bio = json['custom_fields']?['bio']?['view'] ?? json['bio'] as String?;
    } catch (e) {
      address = json['address'] as String?;
      bio = json['bio'] as String?;
    }
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    data['api_token'] = apiToken;
    if (deviceToken != null) {
      data["device_token"] = deviceToken;
    }
    data["phone_number"] = phoneNumber;
    if (verifiedPhone) {
      data["phone_verified_at"] = DateTime.now().toLocal().toString();
    }
    data["address"] = address;
    data["bio"] = bio;
    if (avatar != null && Uuid.isUuid(avatar!.id!)) {
      data['avatar'] = avatar!.id;
    }
    if (avatar != null) {
      data["media"] = [avatar!.toJson()];
    }
    data['auth'] = auth;
    if (roles.isNotEmpty) {
      data['roles'] = roles.map((e) => e.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toRestrictMap() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "thumb": avatar?.thumb,
      "device_token": deviceToken,
    };
  }

  PhoneNumber getPhoneNumber() {
    if (phoneNumber != null && phoneNumber!.length > 4) {
      String _phoneNumber = phoneNumber!.replaceAll(' ', '');
      String dialCode1 = _phoneNumber.substring(1, 2);
      String dialCode2 = _phoneNumber.substring(1, 3);
      String dialCode3 = _phoneNumber.substring(1, 4);

      for (var country in countries) {
        if (country.dialCode == dialCode1) {
          return PhoneNumber(countryISOCode: country.code, countryCode: dialCode1, number: _phoneNumber.substring(2));
        } else if (country.dialCode == dialCode2) {
          return PhoneNumber(countryISOCode: country.code, countryCode: dialCode2, number: _phoneNumber.substring(3));
        } else if (country.dialCode == dialCode3) {
          return PhoneNumber(countryISOCode: country.code, countryCode: dialCode3, number: _phoneNumber.substring(4));
        }
      }
    }
    return PhoneNumber(
      countryISOCode: Get.find<SettingsService>().setting.value.defaultCountryCode ?? 'US',
      countryCode: '1',
      number: '',
    );
  }

  bool get isAdmin => roles.any((role) => role.name == 'admin');
  bool get isProvider => roles.any((role) => role.name == 'provider' || role.name == 'admin');
  bool get isCustomer => roles.any((role) => role.isdDefault == true);

  @override
  bool operator == (dynamic other) =>
      super == other &&
          other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          avatar == other.avatar &&
          apiToken == other.apiToken &&
          deviceToken == other.deviceToken &&
          phoneNumber == other.phoneNumber &&
          verifiedPhone == other.verifiedPhone &&
          verificationId == other.verificationId &&
          address == other.address &&
          bio == other.bio &&
          roles == other.roles &&
          auth == other.auth;

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phoneNumber.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      roles.hashCode ^
      auth.hashCode;
}
