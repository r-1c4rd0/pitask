import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../services/global_service.dart';

class PrivacyController extends GetxController {
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("${Get.find<GlobalService>().baseUrl}privacy/index.html"));
  }
}
