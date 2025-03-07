import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../providers/laravel_provider.dart';
import '../repositories/setting_repository.dart';
import 'settings_service.dart';

class TranslationService extends GetxService {
  final translations = <String, Map<String, String>>{}.obs;
  final RxList<String> languages = <String>[].obs; // Lista reativa de idiomas

  final SettingRepository _settingsRepo = SettingRepository();
  final GetStorage _box = GetStorage();

  // Inicializa o serviço de tradução carregando arquivos de idioma
  Future<TranslationService> init() async {
    languages.assignAll(await _settingsRepo.getSupportedLocales());
    await loadTranslation();
    return this;
  }

  Future<void> loadTranslation({String? locale}) async {
    locale ??= getLocale().toString();
    Map<String, String> _translations = await _settingsRepo.getTranslations(locale);
    Get.addTranslations({locale: _translations});
    Get.find<LaravelApiClient>().setLocale(locale);
  }

  Locale getLocale() {
    String _locale = _box.read<String>('language') ?? ''; // Evita erro de null
    if (_locale.isEmpty) {
      _locale = Get.find<SettingsService>().setting.value.mobileLanguage ?? 'en_US';
    }
    return fromStringToLocale(_locale);
  }

  // Retorna a lista de idiomas suportados
  List<Locale> supportedLocales() {
    return languages.map((String _locale) => fromStringToLocale(_locale)).toList();
  }

  // Converte string de código de idioma para Locale
  Locale fromStringToLocale(String _locale) {
    if (_locale.contains('_')) {
      var parts = _locale.split('_');
      return Locale(parts[0], parts[1]);
    } else {
      return Locale(_locale);
    }
  }
}
