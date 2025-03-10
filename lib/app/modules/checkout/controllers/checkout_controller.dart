import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_provider_subscription_model.dart';
import '../../../models/payment_method_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';

class CheckoutController extends GetxController {
  final PaymentRepository _paymentRepository = PaymentRepository();
  final paymentsList = <PaymentMethod>[].obs;
  final walletList = <Wallet>[].obs;
  final isLoading = true.obs;
  final eProviderSubscription = EProviderSubscription().obs;
  Rx<PaymentMethod> selectedPaymentMethod = PaymentMethod().obs;

  @override
  void onInit() {
    super.onInit();
    eProviderSubscription.value = Get.arguments as EProviderSubscription;

    // Carregar métodos de pagamento e carteiras de forma assíncrona
    ever(isLoading, (_) async {
      await loadPaymentMethodsList();
      await loadWalletList();
      if (paymentsList.isNotEmpty) {
        selectedPaymentMethod.value = paymentsList.firstWhere((element) => element.isDefault ?? false, orElse: () => paymentsList.first);
      }
    });

    isLoading.value = true;
  }

  Future<void> loadPaymentMethodsList() async {
    try {
      paymentsList.assignAll(await _paymentRepository.getMethods());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> loadWalletList() async {
    try {
      int walletIndex = paymentsList.indexWhere((element) => element.route?.toLowerCase() == Routes.WALLET);
      if (walletIndex > -1) {
        // Método de pagamento via carteira está ativado
        var walletPaymentMethod = paymentsList.removeAt(walletIndex);
        walletList.assignAll(await _paymentRepository.getWallets());

        // Substituir pelo novo método de pagamento
        _insertWalletsPaymentMethod(walletIndex, walletPaymentMethod);
        paymentsList.refresh();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  void paySubscription(EProviderSubscription subscription) {
    try {
      subscription.payment = Payment(paymentMethod: selectedPaymentMethod.value);
      if (selectedPaymentMethod.value.route != null) {
        Get.offAndToNamed(
          selectedPaymentMethod.value.route!.toLowerCase(),
          arguments: {
            'eProviderSubscription': subscription,
            'wallet': selectedPaymentMethod.value.wallet
          },
        );
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  TextStyle? getTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyMedium?.merge(TextStyle(color: Get.theme.primaryColor));
    } else if (paymentMethod.wallet != null &&
        (paymentMethod.wallet!.balance ?? 0) < (eProviderSubscription.value.subscriptionPackage?.getPrice ?? 0)) {
      return Get.textTheme.bodyMedium?.merge(TextStyle(color: Get.theme.focusColor));
    }
    return Get.textTheme.bodyMedium;
  }

  TextStyle? getSubTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodySmall?.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodySmall;
  }

  Color? getColor(PaymentMethod paymentMethod) {
    return paymentMethod == selectedPaymentMethod.value ? Get.theme.colorScheme.secondary : null;
  }

  void _insertWalletsPaymentMethod(int walletIndex, PaymentMethod walletPaymentMethod) {
    for (var walletElement in walletList) {
      paymentsList.insert(
        walletIndex,
        PaymentMethod(
          isDefault: walletPaymentMethod.isDefault,
          id: walletPaymentMethod.id,
          name: walletElement.getName(),
          description: walletElement.balance?.toString(),
          logo: walletPaymentMethod.logo,
          route: walletPaymentMethod.route,
          wallet: walletElement,
        ),
      );
    }
  }
}
