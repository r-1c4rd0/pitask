import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide OnTap;
import 'package:get/get.dart';
//import "package:intl/intl.dart" show DateFormat;
import '../app/services/settings_service.dart';

class Ui {
  static GetSnackBar SuccessSnackBar({String title = 'Success', String? message}) {
    Get.log("[$title] ${message ?? ''}");
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message ?? '', style: Get.textTheme.bodySmall?.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.green,
      icon: Icon(Icons.check_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 5),
    );
  }

  static Color parseColor(String hexCode, {double opacity = 1.0}) {
    try {
      return Color(int.parse(hexCode.replaceAll("#", "0xFF"))).withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Widget getPrice(double myPrice, {TextStyle? style, String zeroPlaceholder = '-', String? unit}) {
    var _setting = Get.find<SettingsService>();
    style = style?.merge(TextStyle(fontSize: style.fontSize! + 2)) ?? Get.textTheme.titleSmall;
    try {
      if (myPrice == 0) {
        return Text(zeroPlaceholder, style: style);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: TextSpan(
          text: _setting.setting.value.currencyRight == false
              ? _setting.setting.value.defaultCurrency
              : myPrice.toStringAsFixed(_setting.setting.value.defaultCurrencyDecimalDigits ?? 2),
          style: getPriceStyle(style),
          children: <TextSpan>[
            TextSpan(
              text: _setting.setting.value.currencyRight == false
                  ? myPrice.toStringAsFixed(_setting.setting.value.defaultCurrencyDecimalDigits ?? 2)
                  : _setting.setting.value.defaultCurrency,
              style: style,
            ),
            if (unit != null) TextSpan(text: " $unit ", style: getPriceStyle(style)),
          ],
        ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static TextStyle getPriceStyle(TextStyle? style) {
    return (style ?? Get.textTheme.titleSmall!).merge(
      TextStyle(fontWeight: FontWeight.w300, fontSize: (style?.fontSize ?? Get.textTheme.titleSmall!.fontSize)! - 4),
    );
  }

  static BoxDecoration getBoxDecoration({Color? color, double radius = 10, Border? border, Gradient? gradient}) {
    return BoxDecoration(
      color: color ?? Get.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      boxShadow: [
        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
      ],
      border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
    );
  }

  static Future<String> showTimePickerDialog(BuildContext context, String? initialTime) async {
    DateTime dateTime = DateTime.now();
    if (initialTime != null) {
     // dateTime = DateFormat("HH:mm").parse(initialTime);
    }
    final TimeOfDay time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Padding(padding: EdgeInsets.all(10), child: child);
      },
    );
    if (picked != null) {
      return picked.hour.toString().padLeft(2, '0') + ':' + picked.minute.toString().padLeft(2, '0');
    }
    return "00:00";
  }

  static Html applyHtml(String? html, {TextStyle? style, TextAlign? textAlign, Alignment alignment = Alignment.centerLeft}) {
    style ??= Get.textTheme.bodyLarge;
    return Html(
      data: html?.replaceAll('\r\n', '') ?? '',
      style: {
        "*": Style(
          textAlign: textAlign,
          alignment: alignment,
          color: style?.color,
          fontSize: FontSize(style?.fontSize ?? 16.0),
          display: Display.inline,
          fontWeight: style?.fontWeight,
         // width: Get.width,
        ),
      },
    );
  }
}
