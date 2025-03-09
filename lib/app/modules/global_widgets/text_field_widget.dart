import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.iconData,
    this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.isFirst = false,
    this.isLast = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.suffix,
  }) : super(key: key);

  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? style;
  final IconData? iconData;
  final bool obscureText;
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
              textAlign: textAlign,
            ),
          TextFormField(
            maxLines: keyboardType == TextInputType.multiline ? null : 1,
            keyboardType: keyboardType ?? TextInputType.text,
            onSaved: onSaved,
            onChanged: onChanged,
            validator: validator,
            initialValue: initialValue ?? '',
            style: style ?? Get.textTheme.bodyMedium,
            obscureText: obscureText,
            textAlign: textAlign!,
            decoration: Ui.getInputDecoration(
              hintText: hintText ?? '',
              //iconData: iconData,
              suffixIcon: suffixIcon,
             // suffix: suffix,
             // errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst) {
      return const BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast) {
      return const BorderRadius.vertical(bottom: Radius.circular(10));
    }
    return const BorderRadius.all(Radius.circular(10));
  }

  double get topMargin => isFirst ? 20 : 0;
  double get bottomMargin => isLast ? 10 : 0;
}
