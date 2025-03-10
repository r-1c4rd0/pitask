import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/e_provider_subscription_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';

class StripeController extends GetxController {
  late final WebViewController webViewController; // ✅ Inicialização correta
  final PaymentRepository _paymentRepository = PaymentRepository();
  final url = "".obs;
  final progress = 0.0.obs;
  final eProviderSubscription = EProviderSubscription().obs;

  @override
  void onInit() {
    super.onInit();

    eProviderSubscription.value = Get.arguments['eProviderSubscription'] as EProviderSubscription;
    getUrl();

    // ✅ Inicializa o WebViewController corretamente
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String newUrl) {
          url.value = newUrl;
          showConfirmationIfSuccess();
        },
        onProgress: (int newProgress) {
          progress.value = newProgress / 100;
        },
      ));
  }

  void getUrl() {
    url.value = _paymentRepository.getStripeUrl(eProviderSubscription.value);
    print("Stripe URL: ${url.value}");

    // ✅ Carrega a URL após inicializar o WebViewController
    webViewController.loadRequest(Uri.parse(url.value.isNotEmpty ? url.value : "about:blank"));
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}subscription/payments/stripe";
    if (url.value.contains(_doneUrl)) {
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
