import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';

class WalletFormController extends GetxController {
  final Rx<Wallet> wallet = Wallet().obs;
  late GlobalKey<FormState> walletForm; // Use 'late' para inicializar posteriormente
  final PaymentRepository _paymentRepository = PaymentRepository();

  @override
  void onInit() {
    // Os argumentos podem ser nulos, por isso é feito um cast seguro
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    _initWallet(arguments: arguments);
    super.onInit();
  }

  // Método para inicializar a carteira (wallet)
  void _initWallet({Map<String, dynamic>? arguments}) {
    wallet.value = arguments?['wallet'] as Wallet? ?? Wallet();
  }

  /// Retorna true se o formulário for de criação (sem dados)
  bool isCreateForm() {
    return !wallet.value.hasData;
  }

  /// Cria uma nova carteira utilizando os dados do formulário
  Future<void> createWalletForm() async {
    Get.focusScope?.unfocus();
    if (walletForm.currentState!.validate()) {
      try {
        walletForm.currentState!.save();
        Get.log(wallet.value.toString());
        await _paymentRepository.createWallet(wallet.value);
        await Get.offAndToNamed(Routes.WALLETS);
      } catch (e) {
        //Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
     // Get.showSnackbar(Ui.ErrorSnackBar( message: "There are errors in some fields please correct them!".tr));
    }
  }

  /// Atualiza a carteira com os dados do formulário
  Future<void> updateWalletForm() async {
    Get.focusScope?.unfocus();
    if (walletForm.currentState!.validate()) {
      try {
        walletForm.currentState!.save();
        await _paymentRepository.updateWallet(wallet.value);
        await Get.offAndToNamed(Routes.WALLETS);
      } catch (e) {
       // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
     // Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  /// Exclui a carteira e redireciona para a rota de wallets
  Future<void> deleteWallet(Wallet wallet) async {
    try {
      await _paymentRepository.deleteWallet(wallet);
      await Get.offAndToNamed(Routes.WALLETS);
    } catch (e) {
     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
