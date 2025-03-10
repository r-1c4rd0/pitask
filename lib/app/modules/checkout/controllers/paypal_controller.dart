import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/e_provider_subscription_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';

class PayPalController extends GetxController {
  late final WebViewController webView;  // 🔹 Correção: Inicialização correta do WebViewController
  final PaymentRepository _paymentRepository = PaymentRepository();
  final url = "".obs;
  final progress = 0.0.obs;
  final eProviderSubscription = EProviderSubscription().obs;

  get webViewController => null;

  @override
  void onInit() {
    super.onInit();
    eProviderSubscription.value = Get.arguments['eProviderSubscription'] as EProviderSubscription;
    getUrl();
  }

  void getUrl() {
    url.value = _paymentRepository.getPayPalUrl(eProviderSubscription.value);
    print("PayPal URL: ${url.value}");
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}subscription/payments/paypal";
    if (url.value == _doneUrl) {  // 🔹 Correção: Comparação correta do `RxString`
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
