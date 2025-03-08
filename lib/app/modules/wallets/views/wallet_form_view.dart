import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/wallet_form_controller.dart';

class WalletFormView extends GetView<WalletFormController> {
  @override
  Widget build(BuildContext context) {
    controller.walletForm = GlobalKey<FormState>(); // ✅ Removido `new`

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isCreateForm() ? "Add New Wallet".tr : controller.wallet.value.name ?? "Wallet".tr,
          style: context.textTheme.titleLarge,
        )),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.offAndToNamed(Routes.WALLETS),
        ),
        actions: [
          if (!controller.isCreateForm())
            IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20),
              icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
              onPressed: () {
                if (controller.wallet.value.balance! > 0) {
                  //Get.showSnackbar(Ui.ErrorSnackBar(message: "You can't delete non-empty wallet".tr));
                } else {
                  _showDeleteDialog(context);
                }
              },
            ),
        ],
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: MaterialButton(
                onPressed: () {
                  if (controller.isCreateForm()) {
                    controller.createWalletForm();
                  } else {
                    controller.updateWalletForm();
                  }
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.colorScheme.secondary,
                child: Text(
                  "Save".tr,
                  style: Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor),
                ),
                elevation: 0,
                hoverElevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 10, horizontal: 20),
      ),
      body: Form(
        key: controller.walletForm,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Wallet".tr, style: Get.textTheme.headlineSmall),
              SizedBox(height: 5),
              Text("Fill the following details to add new wallet".tr, style: Get.textTheme.bodySmall),
              SizedBox(height: 20),
              TextFieldWidget(
                onSaved: (input) {
                  if (input != null && input.isNotEmpty) {
                    controller.wallet.update((val) {
                      val?.name = input;
                    });
                  }
                },
                validator: (input) => (input == null || input.isEmpty) ? "Field is required".tr : null,
                initialValue: controller.wallet.value.name??'',
                hintText: "My Wallet".tr,
                labelText: "Wallet Name".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          "Delete Wallet".tr,
          style: TextStyle(color: Colors.redAccent),
        ),
        content: Text(
          "This wallet will be removed from your account".tr,
          style: Get.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            child: Text("Cancel".tr, style: Get.textTheme.bodyMedium),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text("Confirm".tr, style: TextStyle(color: Colors.redAccent)),
            onPressed: () {
              Get.back();
              controller.deleteWallet(controller.wallet.value);
            },
          ),
        ],
      ),
    );
  }
}
