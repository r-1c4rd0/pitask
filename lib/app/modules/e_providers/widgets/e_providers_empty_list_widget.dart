import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/block_button_widget.dart';

class EProvidersEmptyListWidget extends StatelessWidget {
  const EProvidersEmptyListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(height: 60),
        Stack(
          children: <Widget>[
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                    Colors.grey.withOpacity(0.6),
                    Colors.grey.withOpacity(0.2),
                  ])),
              child: Icon(
                Icons.build_circle_outlined,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 70,
              ),
            ),
            Positioned(
              right: -30,
              bottom: -50,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ),
            Positioned(
              left: -20,
              top: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 40),
        Opacity(
          opacity: 0.3,
          child: Text(
            "You don't have any service provider teams!".tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.headlineMedium,
          ),
        ),
        SizedBox(height: 40),
        BlockButtonWidget(
          color: Get.theme.colorScheme.secondary,
          text: Text(
            "Become a Service Provider".tr,
            style: Get.textTheme.titleLarge!.merge(TextStyle(color: Get.theme.primaryColor)),
          ).paddingSymmetric(horizontal: 20, vertical: 3),
          onPressed: () => {Get.offAndToNamed(Routes.E_PROVIDER_ADDRESSES_FORM)},
        ),
      ],
    );
  }
}
