import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../providers/laravel_provider.dart';
import '../../../services/translation_service.dart';
import '../controllers/language_controller.dart';
import '../widgets/languages_loader_widget.dart';

class LanguageView extends GetView<LanguageController> {
  final bool hideAppBar;

  LanguageView({this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Languages".tr,
                  style: context.textTheme.titleLarge,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: () => Get.back(),
                ),
                elevation: 0,
              ),
        body: ListView(
          primary: true,
          children: [
            Obx(() {
              if (Get.find<LaravelApiClient>().isLoading(task: 'getTranslations')) {
                return LanguagesLoaderWidget();
              }
              return Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: Ui.getBoxDecoration(),
                child: Column(
                  children: List.generate(Get.find<TranslationService>().languages.length, (index) {
                    var _lang = Get.find<TranslationService>().languages.elementAt(index);
                    return RadioListTile(
                      value: _lang,
                      groupValue: Get.locale.toString(),
                      activeColor: Get.theme.colorScheme.secondary,
                      onChanged: (value) {
                        controller.updateLocale(value);
                      },
                      title: Text(_lang.tr, style: Get.textTheme.bodyMedium),
                    );
                  }).toList(),
                ),
              );
            })
          ],
        ));
  }
}
