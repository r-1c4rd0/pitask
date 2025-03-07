import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../app/services/settings_service.dart';
import 'ui.dart';

class Helper {
  DateTime? currentBackPressTime;

  static Future<dynamic> getJsonFile(String path) async {
    return rootBundle.loadString(path).then(convert.jsonDecode);
  }

  static List<String> getFilesInDirectory(String path) {
    try {
      return io.Directory(path).listSync().map((e) => e.path).toList();
    } catch (e) {
      print("Erro ao listar diretório: $e");
      return [];
    }
  }

  static String toUrl(String path) {
    return path.endsWith('/') ? path : '$path/';
  }

  static String toApiUrl(String path) {
    return toUrl(path);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
     // Get.showSnackbar(Ui.defaultSnackBar(message: "Tap again to leave!".tr));
      return Future.value(false);
    }
    if (io.Platform.isAndroid) {
      SystemNavigator.pop(); // Alternativa: exit(0);
    }
    return Future.value(true);
  }

  static PhoneNumber getPhoneNumber(String? phoneNumber) {
    if (phoneNumber != null && phoneNumber.length > 4) {
      phoneNumber = phoneNumber.replaceAll(' ', '');
      for (var country in countries) {
        if (phoneNumber.startsWith('+${country.dialCode}')) {
          return PhoneNumber(
            countryISOCode: country.code,
            countryCode: country.dialCode,
            number: phoneNumber.substring(country.dialCode.length + 1),
          );
        }
      }
    }
    return PhoneNumber(
      countryISOCode: Get.find<SettingsService>().setting.value.defaultCountryCode ?? 'US',
      countryCode: '1',
      number: '',
    );
  }
}
