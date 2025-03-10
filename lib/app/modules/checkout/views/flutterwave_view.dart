import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/flutterwave_controller.dart';

class FlutterWaveViewWidget extends GetView<FlutterWaveController> {
  @override
  Widget build(BuildContext context) {
    // Criando o WebViewController antes da construção do Widget
    final WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            controller.url.value = url;
            controller.showConfirmationIfSuccess();
          },
          onPageFinished: (String url) {
            controller.progress.value = 1;
          },
        ),
      )
      ..loadRequest(Uri.parse(controller.url.value));

    // Associando ao Controller
    controller.webView = webViewController;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "FlutterWave Payment".tr,
          style: Get.textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // WebView agora usa WebViewWidget
          Obx(() {
            return WebViewWidget(controller: webViewController);
          }),

          // Indicador de progresso
          Obx(() {
            return controller.progress.value < 1
                ? SizedBox(
              height: 3,
              child: LinearProgressIndicator(
                backgroundColor: Get.theme.colorScheme.secondary.withOpacity(0.2),
              ),
            )
                : SizedBox();
          }),
        ],
      ),
    );
  }
}
