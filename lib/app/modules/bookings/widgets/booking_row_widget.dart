import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingRowWidget extends StatelessWidget {
  const BookingRowWidget({
    super.key,
    required this.description,
    this.value,
    this.valueStyle,
    this.hasDivider = true,
    this.child,
    this.descriptionFlex = 1,
    this.valueFlex = 1,
    this.dividerThickness = 1.0,
    this.dividerHeight = 25.0,
    this.spacingHeight = 6.0,
  });

  final String description;
  final String? value; // Tornamos nullable para segurança
  final TextStyle? valueStyle;
  final bool hasDivider;
  final Widget? child;
  final int descriptionFlex;
  final int valueFlex;
  final double dividerThickness;
  final double dividerHeight;
  final double spacingHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: descriptionFlex,
              child: Text(
                description,
                style: Get.textTheme.bodyLarge,
              ),
            ),
            Expanded(
              flex: valueFlex,
              child: child ??
                  Text(
                    value ?? '', // Tratamento seguro para null
                    style: valueStyle ?? Get.textTheme.bodyMedium,
                    maxLines: 3,
                    textAlign: TextAlign.end,
                  ),
            ),
          ],
        ),
        if (hasDivider)
          Divider(
            thickness: dividerThickness,
            height: dividerHeight,
          )
        else
          SizedBox(height: spacingHeight),
      ],
    );
  }
}