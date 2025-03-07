import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;

import '../app/models/address_model.dart';
import '../app/providers/laravel_provider.dart';
import '../app/services/settings_service.dart';
import 'ui.dart';

class MapsUtil {
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static Future<Marker> getMarker({
    required Address address,
    String id = '',
    String description = '',
  }) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    return Marker(
      markerId: MarkerId(id),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      anchor: const Offset(0.5, 0.5),
      infoWindow: InfoWindow(
        title: description,
        onTap: () {},
      ),
      position: address.getLatLng(),
    );
  }

  static Widget getStaticMaps(
      List<LatLng> latLngs, {
        double height = 168,
        String size = '400x160',
        double zoom = 13,
      }) {
    if (latLngs.isEmpty) {
      return const Center(
        child: Icon(Icons.map, size: 50, color: Colors.grey),
      );
    }

    final laravelApiClient = Get.isRegistered<LaravelApiClient>() ? Get.find<LaravelApiClient>() : null;
    final settingsService = Get.isRegistered<SettingsService>() ? Get.find<SettingsService>() : null;

    if (laravelApiClient == null || settingsService == null) {
      return const Center(
        child: Icon(Icons.error_outline, color: Colors.red),
      );
    }

    String markers = latLngs.map((e) {
      return 'markers=icon:${laravelApiClient.getBaseUrl("images")}marker.png%7Cscale:5%7C${e.latitude},${e.longitude}&';
    }).join();

    return CachedNetworkImage(
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      imageUrl: 'https://maps.googleapis.com/maps/api/staticmap?'
          'zoom=$zoom&'
          'size=$size&'
          'language=${Get.locale?.languageCode ?? "en"}&'
          'maptype=roadmap&$markers'
          'key=${settingsService.setting.value.googleMapsKey}',
      placeholder: (context, url) => Image.asset(
        'assets/img/loading.gif',
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error_outline),
    );
  }

  static void openMapsSheet(BuildContext context, LatLng latLng, String title) async {
    try {
      final coords = launcher.Coords(latLng.latitude, latLng.longitude);
      final availableMaps = await launcher.MapLauncher.installedMaps;

      if (availableMaps.isEmpty) {
      //  Get.showSnackbar(Ui.ErrorSnackBar(message: "Nenhum aplicativo de mapas encontrado.".tr));
        return;
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: availableMaps
                    .map(
                      (map) => ListTile(
                    onTap: () => map.showDirections(
                      directionsMode: launcher.DirectionsMode.driving,
                      destinationTitle: title.isNotEmpty ? title : "Destino",
                      destination: coords,
                    ),
                    title: Text(map.mapName, style: Get.textTheme.bodyMedium),
                    leading: SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          );
        },
      );
    } catch (e) {
     // Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
