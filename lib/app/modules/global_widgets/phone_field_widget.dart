import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneFieldWidget extends StatelessWidget {
  const PhoneFieldWidget({
    super.key,  // ✅ Corrigido uso da `key`
    required this.onSaved,
    required this.onChanged,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.isFirst = false,
    this.isLast = false,
    this.style,
    this.textAlign,
    this.suffix,
    this.initialCountryCode = 'DE',
    this.countries,
  });

  final FormFieldSetter<PhoneNumber> onSaved;
  final ValueChanged<PhoneNumber> onChanged;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? style;
  final bool obscureText;
  final String initialCountryCode;
  final List<String>? countries;
  final bool isFirst;
  final bool isLast;
  final Widget? suffixIcon;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: buildBorderRadius,
        boxShadow: [
          BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            Text(
              labelText!,
              style: Get.textTheme.bodyLarge,
              textAlign: textAlign ?? TextAlign.start,
            ),
          IntlPhoneField(
            onSaved: onSaved,
            onChanged: onChanged,
            initialValue: initialValue,
            initialCountryCode: initialCountryCode,
            showDropdownIcon: false,
            pickerDialogStyle: PickerDialogStyle(countryNameStyle: Get.textTheme.bodyMedium),
            style: style ?? Get.textTheme.bodyMedium,
            textAlign: textAlign ?? TextAlign.start,
            disableLengthCheck: true,
            autovalidateMode: AutovalidateMode.disabled,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Get.textTheme.bodySmall,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              suffix: suffix,
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst) return const BorderRadius.vertical(top: Radius.circular(10));
    if (isLast) return const BorderRadius.vertical(bottom: Radius.circular(10));
    return BorderRadius.circular(10);
  }

  double get topMargin => isFirst ? 20 : 0;
  double get bottomMargin => isLast ? 10 : 0;
}
