import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../common/helper.dart';
import '../../../models/e_provider_subscription_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';

class FlutterWaveController extends GetxController {
  late final WebViewController webView;
  PaymentRepository _paymentRepository = PaymentRepository();
  final url = "".obs;
  final progress = 0.0.obs;
  final eProviderSubscription = new EProviderSubscription().obs;


  @override
  void onInit() {
    eProviderSubscription.value = Get.arguments['eProviderSubscription'] as EProviderSubscription;
    getUrl();
    super.onInit();
  }

  void getUrl() {
    url.value = _paymentRepository.getFlutterWaveUrl(eProviderSubscription.value);
    print(url.value);
  }

  void showConfirmationIfSuccess() {
    final _doneUrl = "${Helper.toUrl(Get.find<GlobalService>().baseUrl)}subscription/payments/flutterwave";
    if (url == _doneUrl) {
      Get.toNamed(Routes.CONFIRMATION, arguments: {
        'title': "Payment Successful".tr,
        'long_message': "Your Payment is Successful".tr,
      });
    }
  }
}
