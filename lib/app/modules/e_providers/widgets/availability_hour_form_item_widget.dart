import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/availability_hour_model.dart';
import '../../global_widgets/confirm_dialog.dart';
import '../controllers/e_provider_availability_form_controller.dart';

class AvailabilityHourFromItemWidget extends GetView<EProviderAvailabilityFormController> {
  const AvailabilityHourFromItemWidget({
     Key? key,
    required MapEntry<String, List<AvailabilityHour>> availabilityHour,
    required List<String> data,
  })  : _availabilityHour = availabilityHour,
        _data = data,
        super(key: key);

  final MapEntry<String, List<AvailabilityHour>> _availabilityHour;
  final List<String> _data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
                  Text(_availabilityHour.key.tr).paddingSymmetric(vertical: 5),
                ] +
                List.generate(_data.length, (index) {
                  return Text(
                    _data.elementAt(index),
                    style: Get.textTheme.bodySmall,
                  );
                }),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        Column(
          children: List.generate(_availabilityHour.value.length, (index) {
            var _hour = _availabilityHour.value.elementAt(index);
            return Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 3),
                  width: 125,
                  child: Text(
                    _hour.toDuration(),
                    style: Get.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.focusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                if (controller.eProvider.value.hasData)
                  MaterialButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmDialog(
                              title: "Delete Availability Hour".tr, content: "Are you sure you want to delete this slot?".tr, submitText: "Submit".tr, cancelText: "Cancel".tr);
                        },
                      );
                      if (confirm! && _hour.hasData) {
                        await controller.deleteAvailabilityHour(_hour);
                      }
                    },
                    height: 44,
                    minWidth: 44,
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.delete_outlined,
                      color: Colors.redAccent,
                    ),
                    elevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                  ),
              ],
            );
          }),
          //mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}
