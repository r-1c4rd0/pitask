import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../profile/bindings/profile_binding.dart';
import '../../profile/views/profile_view.dart';
import '../bindings/settings_binding.dart';
import '../views/language_view.dart';
import '../views/theme_mode_view.dart';

class SettingsController extends GetxController {
  final currentIndex = 0.obs;

  // Lista final para evitar recriações desnecessárias
  final List<String> pages = [
    Routes.PROFILE,
    Routes.SETTINGS_LANGUAGE,
    Routes.SETTINGS_THEME_MODE,
  ];

  void changePage(int index) {
    if (index < 0 || index >= pages.length) return;
    currentIndex.value = index;
    Get.toNamed(pages[index]); // Removido `id: 1` para evitar erros de navegação
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.PROFILE:
        return GetPageRoute(
          settings: settings,
          page: () => ProfileView(hideAppBar: true),
          binding: ProfileBinding(),
        );
      case Routes.SETTINGS_LANGUAGE:
        return GetPageRoute(
          settings: settings,
          page: () => LanguageView(hideAppBar: true),
          binding: SettingsBinding(),
        );
      case Routes.SETTINGS_THEME_MODE:
        return GetPageRoute(
          settings: settings,
          page: () => ThemeModeView(hideAppBar: true),
          binding: SettingsBinding(),
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => Scaffold(
            body: Center(child: Text("Página não encontrada")),
          ),
        );
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
