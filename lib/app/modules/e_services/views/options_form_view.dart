import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/media_model.dart';
import '../../../models/option_group_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/image_field_widget.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/options_form_controller.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class OptionsFormView extends GetView<OptionsFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
            controller.isCreateForm() ? controller.eService.value.name ?? '' : controller.option.value.name ?? '',
            style: context.textTheme.titleLarge,
          );
        }),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.offAndToNamed(
            Routes.E_SERVICE,
            arguments: {'eService': controller.eService.value, 'heroTag': 'option_form_back'},
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20),
            icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 28),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
        elevation: 0,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Form(
        key: controller.optionForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isCreateForm()) _buildStepper(),
              _buildHeader(),
              _buildImageField(),
              _buildNameField(),
              _buildDescriptionField(),
              _buildOptionGroupSelector(context),
              _buildPriceField(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPriceField() {
    return TextFieldWidget(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (input) => controller.option.value.price = double.tryParse(input ?? '0') ?? 0,
      validator: (input) => (double.tryParse(input ?? '0') ?? 0) > 0 ? null : "Should be number more than 0".tr,
      initialValue: controller.option.value.price?.toString() ?? '',
      hintText: "23.00".tr,
      labelText: "Price".tr,
      suffix: Text(Get.find<SettingsService>().setting.value.defaultCurrency??''),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
                  controller.createOptionForm();
                } else {
                  controller.updateOptionForm();
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.colorScheme.secondary,
              child: Text("Save".tr, style: Get.textTheme.bodyMedium!.copyWith(color: Get.theme.primaryColor)),
            ),
          ),
          if (controller.isCreateForm()) SizedBox(width: 10),
          if (controller.isCreateForm())
            MaterialButton(
              onPressed: () => controller.createOptionForm(addOther: true),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.colorScheme.secondary.withOpacity(0.2),
              child: Text("Save & Add Other".tr, style: Get.textTheme.bodyMedium!.copyWith(color: Get.theme.colorScheme.secondary)),
            ),
        ],
      ).paddingSymmetric(vertical: 10, horizontal: 20),
    );
  }

  Widget _buildStepper() {
    return HorizontalStepperWidget(
      steps: [
        StepWidget(
          title: Text(("Service details".tr).substring(0, min("Service details".tr.length, 15))),
          color: Get.theme.focusColor,
          index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
        ),
        StepWidget(
          title: Text(("Options details".tr).substring(0, min("Options details".tr.length, 15))),
          index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Options".tr, style: Get.textTheme.headlineSmall).paddingOnly(top: 25, right: 22, left: 22),
        Text("Fill the following details to add option to this service".tr, style: Get.textTheme.bodySmall)
            .paddingSymmetric(horizontal: 22, vertical: 5),
      ],
    );
  }

  Widget _buildImageField() {
    return Obx(() {
      return ImageFieldWidget(
        label: "Image".tr,
        field: 'image',
        tag: controller.optionForm.hashCode.toString(),
        initialImage: controller.option.value.image,
        uploadCompleted: (uuid) => controller.option.update((val) => val?.image = Media(id: uuid)),
        reset: (uuid) => controller.option.update((val) => val?.image = null),
      );
    });
  }

  Widget _buildNameField() {
    return TextFieldWidget(
      onSaved: (input) => controller.option.value.name = input,
      validator: (input) => input != null && input.isNotEmpty ? null : "Field is required".tr,
      initialValue: controller.option.value.name,
      hintText: "Large Size".tr,
      labelText: "Name".tr,
    );
  }

  Widget _buildDescriptionField() {
    return TextFieldWidget(
      onSaved: (input) => controller.option.value.description = input,
      validator: (input) => (input != null && input.length >= 3) ? null : "Should be more than 3 letters".tr,
      keyboardType: TextInputType.multiline,
      initialValue: controller.option.value.description,
      hintText: "Description for option".tr,
      labelText: "Description".tr,
    );
  }

  Widget _buildOptionGroupSelector(BuildContext context) {
    return Obx(() {
      final selectedOptionGroup = controller.optionGroups.firstWhere(
            (element) => element.id == controller.option.value.optionGroupId,
        orElse: () => OptionGroup(),
      );

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10)],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text("Option Group".tr, style: Get.textTheme.bodyLarge)),
                MaterialButton(
                  onPressed: () async {
                    final selectedValue = await showDialog<OptionGroup>(
                      context: context,
                      builder: (context) => SelectDialog(
                        title: "Select Option Group".tr,
                        items: controller.getSelectOptionGroupsItems(),
                        initialSelectedValue: selectedOptionGroup,
                      ),
                    );
                    controller.option.update((val) => val?.optionGroupId = selectedValue?.id);
                  },
                  child: Text("Select".tr, style: Get.textTheme.titleMedium),
                ),
              ],
            ),
            buildOptionGroup(selectedOptionGroup.name),
          ],
        ),
      );
    });
  }

  Widget buildOptionGroup(String? _group) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(_group ?? '', style: Get.textTheme.bodyMedium),
    );
  }
  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Option".tr,
            style: TextStyle(color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("This option will removed from the service".tr, style: Get.textTheme.bodyLarge),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel".tr, style: Get.textTheme.bodyLarge),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "Confirm".tr,
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Get.back();
                controller.deleteOption(controller.option.value);
              },
            ),
          ],
        );
      },
    );
  }
}
