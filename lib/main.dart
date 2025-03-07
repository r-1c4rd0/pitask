import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/providers/firebase_provider.dart';
import 'app/providers/laravel_provider.dart';
import 'app/routes/theme1_app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/firebase_messaging_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';

Future<void> initServices() async {
  Get.log('Starting services...');
  await GetStorage.init();
  await Firebase.initializeApp(); // Inicializa Firebase antes dos serviços

  // Inicializa serviços essenciais
  await Get.putAsync(() => GlobalService().init());
  await Get.putAsync(() => SettingsService().init());
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => TranslationService().init());

  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante inicialização correta
  await initServices();

  runApp(HomeServicesApp());
}

class HomeServicesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Get.find<SettingsService>().setting.value.providerAppName ?? 'Home Services',
      initialRoute: Theme1AppPages.INITIAL,
      onReady: () async {
        await Get.putAsync(() => FireBaseMessagingService().init()); // Firebase Messaging só após inicialização completa
      },
      getPages: Theme1AppPages.routes,
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: Get.find<TranslationService>().getLocale(),
      fallbackLocale: Get.find<TranslationService>().getLocale(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    );
  }
}
