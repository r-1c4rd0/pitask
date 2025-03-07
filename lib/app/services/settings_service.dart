import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/ui.dart';
import '../models/address_model.dart';
import '../models/setting_model.dart';
import '../repositories/setting_repository.dart';

class SettingsService extends GetxService {
  final setting = Setting().obs;
  final address = Address().obs;
  final GetStorage _box = GetStorage();
  final SettingRepository _settingsRepo = SettingRepository();

  Future<SettingsService> init() async {
    address.listen((Address _address) {
      _box.write('current_address', _address.toJson());
    });

    final fetchedSetting = await _settingsRepo.get();
    if (fetchedSetting != null) {
      setting.value = fetchedSetting;
      setting.value.modules = await _settingsRepo.getModules();
    }

    return this;
  }

  ThemeData getLightTheme() {
    return ThemeData(
      primaryColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
      brightness: Brightness.light,
      dividerColor: Ui.parseColor(setting.value?.accentColor ?? "#CCCCCC", opacity: 0.1),
      focusColor: Ui.parseColor(setting.value?.accentColor ?? "#CCCCCC"),
      hintColor: Ui.parseColor(setting.value?.secondColor ?? "#CCCCCC"),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Ui.parseColor(setting.value?.mainColor ?? "#000000")),
      ),
      colorScheme: ColorScheme.light(
        primary: Ui.parseColor(setting.value?.mainColor ?? "#000000"),
        secondary: Ui.parseColor(setting.value?.mainColor ?? "#000000"),
      ),
      textTheme: GoogleFonts.getTextTheme(
        _getLocale().startsWith('ar') ? 'Cairo' : 'Poppins',
        _buildTextTheme(setting.value),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      primaryColor: const Color(0xFF252525),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 0),
      scaffoldBackgroundColor: const Color(0xFF2C2C2C),
      brightness: Brightness.dark,
      dividerColor: Ui.parseColor(setting.value?.accentDarkColor ?? "#CCCCCC", opacity: 0.1),
      focusColor: Ui.parseColor(setting.value?.accentDarkColor ?? "#CCCCCC"),
      hintColor: Ui.parseColor(setting.value?.secondDarkColor ?? "#CCCCCC"),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Ui.parseColor(setting.value?.mainColor ?? "#000000")),
      ),
      colorScheme: ColorScheme.dark(
        primary: Ui.parseColor(setting.value?.mainDarkColor ?? "#000000"),
        secondary: Ui.parseColor(setting.value?.mainDarkColor ?? "#000000"),
      ),
      textTheme: GoogleFonts.getTextTheme(
        _getLocale().startsWith('ar') ? 'Cairo' : 'Poppins',
        _buildTextTheme(setting.value),
      ), checkboxTheme: CheckboxThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Ui.parseColor(setting.value?.mainDarkColor ?? "#000000"); }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Ui.parseColor(setting.value?.mainDarkColor ?? "#000000"); }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Ui.parseColor(setting.value?.mainDarkColor ?? "#000000"); }
 return null;
 }),
 trackColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
 if (states.contains(MaterialState.disabled)) { return null; }
 if (states.contains(MaterialState.selected)) { return Ui.parseColor(setting.value?.mainDarkColor ?? "#000000"); }
 return null;
 }),
 ),
    );
  }

  TextTheme _buildTextTheme(Setting? setting) {
    return TextTheme(
      titleLarge: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Ui.parseColor(setting?.mainColor ?? "#000000"), height: 1.2),
      headlineSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.2),
      headlineMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.3),
      displaySmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.3),
      displayMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Ui.parseColor(setting?.mainColor ?? "#000000"), height: 1.4),
      displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.4),
      titleSmall: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.2),
      titleMedium: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Ui.parseColor(setting?.mainColor ?? "#000000"), height: 1.2),
      bodyMedium: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.2),
      bodyLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Ui.parseColor(setting?.secondColor ?? "#CCCCCC"), height: 1.2),
      bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Ui.parseColor(setting?.accentColor ?? "#CCCCCC"), height: 1.2),
    );
  }

  String _getLocale() {
    return _box.read<String>('language') ?? setting.value?.mobileLanguage ?? 'en';
  }

  ThemeMode getThemeMode() {
    String? _themeMode = _box.read<String>('theme_mode');
    switch (_themeMode) {
      case 'ThemeMode.light':
        _setSystemUIOverlay(Brightness.light);
        return ThemeMode.light;
      case 'ThemeMode.dark':
        _setSystemUIOverlay(Brightness.dark);
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        if (setting.value?.defaultTheme == "dark") {
          _setSystemUIOverlay(Brightness.dark);
          return ThemeMode.dark;
        } else {
          _setSystemUIOverlay(Brightness.light);
          return ThemeMode.light;
        }
    }
  }

  void _setSystemUIOverlay(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: brightness == Brightness.dark ? Colors.black87 : Colors.white,
    ));
  }
}
