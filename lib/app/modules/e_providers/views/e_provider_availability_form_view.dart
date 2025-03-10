import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/availability_hour_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/select_dialog.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/e_provider_availability_form_controller.dart';
import '../widgets/availability_hour_form_item_widget.dart';
import '../widgets/horizontal_stepper_widget.dart';
import '../widgets/step_widget.dart';

class EProviderAvailabilityFormView extends GetView<EProviderAvailabilityFormController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Provider Availability".tr,
          style: context.textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () async => Get.back(),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: controller.createAvailabilityHour,
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Form(
        key: controller.eProviderAvailabilityForm,
        child: ListView(
          controller: controller.scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 60),
          children: [
            _buildStepper(),
            _buildAvailabilityList(),
            _buildDaySelector(context),
            _buildTimePicker(context, "Starts At", controller.availabilityHour.value.startAt, (time) {
              controller.availabilityHour.update((val) => val!.startAt = time);
            }),
            _buildTimePicker(context, "Ends At", controller.availabilityHour.value.endAt, (time) {
              controller.availabilityHour.update((val) => val!.endAt = time);
            }),
            Obx(() {
              return TextFieldWidget(
                onSaved: (input) => controller.availabilityHour.value.data = input,
                keyboardType: TextInputType.multiline,
                initialValue: controller.availabilityHour.value.data,
                hintText: "Notes for this availability hour".tr,
                labelText: "Notes".tr,
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation Bar
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
              onPressed: () => Get.offNamedUntil(Routes.E_PROVIDERS, (route) => route.settings.name == Routes.E_PROVIDERS),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Get.theme.colorScheme.secondary,
              child: Text("Finish".tr, style: Get.textTheme.bodyMedium?.merge(TextStyle(color: Get.theme.primaryColor))),
              elevation: 0,
            ),
          ),
        ],
      ).paddingSymmetric(vertical: 10, horizontal: 20),
    );
  }

  /// Stepper Widget
  Widget _buildStepper() {
    return HorizontalStepperWidget(
      controller: ScrollController(initialScrollOffset: 9999),
      steps: [
        StepWidget(
          title: Text("Addresses".tr),
          color: Get.theme.focusColor,
          index: Text("1", style: TextStyle(color: Get.theme.primaryColor)),
        ),
        StepWidget(
          title: Text("Provider Details".tr),
          color: Get.theme.focusColor,
          index: Text("2", style: TextStyle(color: Get.theme.primaryColor)),
        ),
        StepWidget(
          title: Text("Availability".tr),
          index: Text("3", style: TextStyle(color: Get.theme.primaryColor)),
        ),
      ],
    );
  }

  /// Availability List
  Widget _buildAvailabilityList() {
    return Obx(() {
      if (controller.eProvider.value.groupedAvailabilityHours().entries.isEmpty) {
        return SizedBox();
      }
      return Container(
        padding: EdgeInsetsDirectional.only(top: 10, bottom: 10, end: 5, start: 20),
        margin: EdgeInsets.all(20),
        decoration: Ui.getBoxDecoration(),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.eProvider.value.groupedAvailabilityHours().entries.length,
          separatorBuilder: (_, __) => Divider(height: 16, thickness: 0.8),
          itemBuilder: (context, index) {
            var availabilityHour = controller.eProvider.value.groupedAvailabilityHours().entries.elementAt(index);
            var data = controller.eProvider.value.getAvailabilityHoursData(availabilityHour.key);
            return AvailabilityHourFromItemWidget(availabilityHour: availabilityHour, data: data);
          },
        ),
      );
    });
  }

  /// Day Selector
  Widget _buildDaySelector(BuildContext context) {
    return Obx(() {
      return _buildSelectionContainer(
        title: "Days".tr,
        buttonText: "Select".tr,
        onPressed: () async {
          final selectedValue = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return SelectDialog(
                title: "Select a day".tr,
                submitText: "Submit".tr,
                cancelText: "Cancel".tr,
                items: controller.getSelectDaysItems(),
                initialSelectedValue: controller.availabilityHour.value.day,
              );
            },
          );
          controller.availabilityHour.update((val) => val?.day = selectedValue);
        },
        child: controller.availabilityHour.value.day != null
            ? Text(controller.availabilityHour.value.day!.tr, style: Get.textTheme.bodyMedium)
            : Text("Select a day".tr, style: Get.textTheme.bodySmall),
      );
    });
  }

  /// Time Picker
  Widget _buildTimePicker(BuildContext context, String title, String? initialTime, Function(String) onTimePicked) {
    return _buildSelectionContainer(
      title: title.tr,
      buttonText: "Time Picker".tr,
      onPressed: () async {
        final pickedTime = await Ui.showTimePickerDialog(context, initialTime);
        onTimePicked(pickedTime);
      },
      child: initialTime != null
          ? Text(initialTime, style: Get.textTheme.bodyMedium)

          : Text("Pick a time for $title".tr, style: Get.textTheme.bodySmall),
    );
  }

  /// Generic Selection Container
  Widget _buildSelectionContainer({required String title, required String buttonText, required VoidCallback onPressed, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
        border: Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [Expanded(child: Text(title, style: Get.textTheme.bodyLarge)), _buildSelectButton(buttonText, onPressed)],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: child),
        ],
      ),
    );
  }

  Widget _buildSelectButton(String text, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      shape: StadiumBorder(),
      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
      child: Text(text, style: Get.textTheme.titleMedium),
      elevation: 0,
    );
  }
}
