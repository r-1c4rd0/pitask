import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/e_provider_model.dart';
import '../../../models/e_service_model.dart';
import '../../../models/option_group_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/multi_select_dialog.dart';
import '../../global_widgets/select_dialog.dart';

class EServiceFormController extends GetxController {
  final eService = EService().obs;
  final optionGroups = <OptionGroup>[].obs;
  final categories = <Category>[].obs;
  final eProviders = <EProvider>[].obs;
  GlobalKey<FormState> eServiceForm = new GlobalKey<FormState>();
  EServiceRepository _eServiceRepository = EServiceRepository();
  CategoryRepository _categoryRepository = CategoryRepository();
  EProviderRepository _eProviderRepository = EProviderRepository();


  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      eService.value = arguments['eService'] as EService;
    }
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    await getEService();
    await getCategories();
    await getEProviders();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name! + " " + "page refreshed successfully".tr));
    }
  }

  Future getEService() async {
    if (eService.value.hasData) {
      try {
        eService.value = await _eServiceRepository.get(eService.value.id!);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getEProviders() async {
    try {
      eProviders.assignAll(await _eProviderRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  List<MultiSelectDialogItem<Category>> getMultiSelectCategoriesItems() {
    return categories.map((element) {
      return MultiSelectDialogItem(element, element.name!);
    }).toList();
  }

  List<SelectDialogItem<EProvider>> getSelectProvidersItems() {
    return eProviders.map((element) {
      return SelectDialogItem(element, element.name!);
    }).toList();
  }

  Future getOptionGroups() async {
    if (eService.value.hasData) {
      try {
        var _optionGroups = await _eServiceRepository.getOptionGroups(eService.value.id!);
        optionGroups.assignAll(_optionGroups);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
  }

  /*
  * Check if the form for create new service or edit
  * */
  bool isCreateForm() {
    return !eService.value.hasData;
  }

  void createEServiceForm({bool createOptions = false}) async {
    Get.focusScope?.unfocus();
    if (eServiceForm.currentState!.validate()) {
      try {
        eServiceForm.currentState?.save();
        var _eService = await _eServiceRepository.create(eService.value);
        if (createOptions)
          Get.offAndToNamed(Routes.OPTIONS_FORM, arguments: {'eService': _eService});
        else
          Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': _eService, 'heroTag': 'e_service_create_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void updateEServiceForm() async {
    Get.focusScope?.unfocus();
    if (eServiceForm.currentState!.validate()) {
      try {
        eServiceForm.currentState?.save();
        var _eService = await _eServiceRepository.update(eService.value);
        Get.offAndToNamed(Routes.E_SERVICE, arguments: {'eService': _eService, 'heroTag': 'e_service_update_form'});
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {}
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void deleteEService() async {
    try {
      await _eServiceRepository.delete(eService.value.id!);
      Get.offAndToNamed(Routes.E_SERVICES);
      Get.showSnackbar(Ui.SuccessSnackBar(message: eService.value.name! + " " + "has been removed".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
