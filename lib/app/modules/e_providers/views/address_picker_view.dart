/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../../models/address_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/e_provider_addresses_form_controller.dart';

// ignore: must_be_immutable
class AddressPickerView extends GetView<EProviderAddressesFormController> {
  AddressPickerView({Key? key}) : super(key: key) {
    _address = (Get.arguments?['address'] as Address?) ?? Address();
  }

  late Address _address;

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: Get.find<SettingsService>().setting.value.googleMapsKey,
      initialPosition: _address.getLatLng(),
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePlaceDetailSearch: true,
      forceSearchOnZoomChanged: true,
      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
        if (isSearchBarFocused) return SizedBox();

        _address.address = selectedPlace?.formattedAddress ?? _address.address;

        return FloatingCard(
          height: 300,
          elevation: 0,
          bottomPosition: 10.0, // Ajuste de posição
          leftPosition: 10.0,
          rightPosition: 10.0,
          color: Colors.transparent,
          child: state == SearchingState.Searching
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFieldWidget(
                labelText: "Description".tr,
                hintText: "My Home".tr,
                initialValue: _address.description,
                onChanged: (input) => _address.description = input,
                iconData: Icons.description_outlined,
                isFirst: true,
                isLast: false,
              ),
              TextFieldWidget(
                labelText: "Full Address".tr,
                hintText: "123 Street, City 136, State, Country".tr,
                initialValue: _address.address,
                onChanged: (input) => _address.address = input,
                iconData: Icons.place_outlined,
                isFirst: false,
                isLast: true,
              ),
              BlockButtonWidget(
                onPressed: () async {
                  if (selectedPlace?.geometry?.location != null) {
                    _address.latitude = selectedPlace!.geometry!.location.lat;
                    _address.longitude = selectedPlace.geometry!.location.lng;
                  }

                  if (_address.hasData) {
                    await controller.updateAddress(_address);
                  } else {
                    await controller.createAddress(_address);
                  }
                  Get.back();
                },
                color: Get.theme.colorScheme.secondary,
                text: Text(
                  "Pick Here".tr,
                  style: Get.textTheme.titleLarge!.merge(TextStyle(color: Get.theme.primaryColor)),
                ),
              ).paddingSymmetric(horizontal: 20),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
*/
