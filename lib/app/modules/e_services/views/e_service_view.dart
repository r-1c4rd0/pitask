import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/e_service_controller.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';
import '../widgets/option_group_item_widget.dart';
import '../widgets/review_item_widget.dart';

class EServiceView extends GetView<EServiceController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _eService = controller.eService.value;

      if (!_eService.hasData) {
        return Scaffold(body: CircularLoadingWidget(height: Get.height));
      }

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit_outlined, size: 28, color: Get.theme.primaryColor),
          onPressed: () => Get.offAndToNamed(Routes.E_SERVICE_FORM, arguments: {'eService': _eService}),
          backgroundColor: Get.theme.colorScheme.secondary,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final _apiClient = Get.find<LaravelApiClient>();
            _apiClient.forceRefresh();
            await controller.refreshEService(showMessage: true);
            _apiClient.unForceRefresh();
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 340,
                elevation: 0,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                  onPressed: Get.back,
                ),
                bottom: buildEServiceTitleBarWidget(_eService),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        buildCarouselSlider(_eService),
                        buildCarouselBullets(_eService),
                      ],
                    );
                  }),
                ).marginOnly(bottom: 50),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    buildDescription(_eService),
                    buildOptions(_eService),
                    if (_eService.images!.isNotEmpty) buildGalleries(_eService),
                    buildReviews(_eService),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // inicio
  buildEServiceTitleBarWidget(EService _eService) {
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _eService.name ?? '',
                  style: Get.textTheme.headlineSmall!.merge(TextStyle(height: 1.1)),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (_eService.eProvider == null)
                Container(
                  child: Text("  .  .  .  ".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_eService.eProvider != null && _eService.eProvider!.available!)
                Container(
                  child: Text("Available".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium!.merge(
                        TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
              if (_eService.eProvider != null && !_eService.eProvider!.available!)
                Container(
                  child: Text("Offline".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyMedium?.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  margin: EdgeInsets.symmetric(vertical: 3),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: List.from(Ui.getStarsList(_eService.rate))),
                    Text(
                      "Reviews (%s)".trArgs([_eService.totalReviews.toString()]),
                      style: Get.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_eService.getOldPrice > 0)
                    Ui.getPrice(
                      _eService.getOldPrice,
                      style: Get.textTheme.titleLarge!.merge(TextStyle(color: Get.theme.focusColor, decoration: TextDecoration.lineThrough)),
                      unit: _eService.getUnit,
                    ),
                  Ui.getPrice(
                    _eService.getPrice,
                    style: Get.textTheme.displaySmall!.merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                    unit: _eService.getUnit,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //fim=> análisar o que pode ser otomizado:

  Widget buildDescription(EService _eService) {
    return EServiceTilWidget(
      title: Text("Description".tr, style: Get.textTheme.titleSmall),
      content: _eService.description!.isEmpty
          ? SizedBox()
          : Ui.applyHtml(_eService.description, style: Get.textTheme.bodyLarge),
    );
  }

  Widget buildOptions(EService _eService) {
    return Obx(() {
      if (controller.optionGroups.isEmpty) {
        return EServiceTilWidget(
          title: Text("Options".tr, style: Get.textTheme.titleSmall),
          content: Center(
              child: Text(
                "No options assigned to this service".tr,
                style: Get.textTheme.bodySmall,
              ).paddingSymmetric(vertical: 15)),
          actions: [
            GestureDetector(
              onTap: () {
                Get.offAndToNamed(Routes.OPTIONS_FORM, arguments: {'eService': _eService});
              },
              child: Text("Add Option".tr, style: Get.textTheme.titleMedium),
            ),
          ],
        );
      }
      return EServiceTilWidget(
        horizontalPadding: 0,
        title: Text("Options".tr, style: Get.textTheme.titleSmall).paddingSymmetric(horizontal: 20),
        content: ListView.separated(
          padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
            return OptionGroupItemWidget(optionGroup: controller.optionGroups.elementAt(index));
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 6);
          },
          itemCount: controller.optionGroups.length,
          primary: false,
          shrinkWrap: true,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.offAndToNamed(Routes.OPTIONS_FORM, arguments: {'eService': _eService});
            },
            child: Text("Add Option".tr, style: Get.textTheme.titleMedium),
          ).paddingSymmetric(horizontal: 20),
        ],
      );
    });
  }



  Widget buildGalleries(EService _eService) {
    return EServiceTilWidget(
      horizontalPadding: 0,
      title: Text("Galleries".tr, style: Get.textTheme.titleSmall).paddingSymmetric(horizontal: 20),
      content: Container(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _eService.images?.length,
          itemBuilder: (_, index) {
            var _media = _eService.images?[index];
            return InkWell(
              onTap: () => Get.toNamed(Routes.GALLERY, arguments: {'media': _eService.images, 'current': _media, 'heroTag': 'e_services_galleries'}),
              child: Container(
                width: 100,
                height: 100,
                margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0),
                child: buildGalleryImage(_media!),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGalleryImage(Media _media) {
    return Stack(
      //TODO
      /*testando esse alinhamento, não tem o topstart, caso não funcionar testar o centerRigth*/
      alignment: Alignment.centerLeft,
      children: [
        Hero(
          tag: 'e_services_galleries${_media.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: _media.thumb!,
              placeholder: (_, __) => Image.asset('assets/img/loading.gif', fit: BoxFit.cover, height: 100),
              errorWidget: (_, __, ___) => Icon(Icons.error_outline),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 12, top: 8),
          child: Text(
            _media.name ?? '',
            maxLines: 2,
            style: Get.textTheme.bodyMedium!.copyWith(
              color: Get.theme.primaryColor,
              shadows: [Shadow(offset: Offset(0, 1), blurRadius: 6.0, color: Get.theme.hintColor.withOpacity(0.6))],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReviews(EService _eService) {
    return EServiceTilWidget(
      title: Text("Reviews & Ratings".tr, style: Get.textTheme.titleSmall),
      content: Column(
        children: [
          Text(_eService.rate.toString(), style: Get.textTheme.displayLarge),
          Wrap(children: Ui.getStarsList(_eService.rate, size: 32)),
          Text("Reviews (%s)".trArgs([_eService.totalReviews.toString()]), style: Get.textTheme.bodySmall).paddingOnly(top: 10),
          Divider(height: 35, thickness: 1.3),
          Obx(() {
            if (controller.reviews.isEmpty) return CircularLoadingWidget(height: 100);
            return ListView.separated(
              shrinkWrap: true,
              itemCount: controller.reviews.length,
              itemBuilder: (_, index) => ReviewItemWidget(review: controller.reviews[index]),
              separatorBuilder: (_, __) => Divider(height: 35, thickness: 1.3),
            );
          }),
        ],
      ),
    );
  }

  CarouselSlider buildCarouselSlider(EService _eService) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, _) => controller.currentSlide.value = index,
      ),
      items: _eService.images!.map((media) {
        return Hero(
          tag: controller.heroTag.value + _eService.id!,
          child: CachedNetworkImage(
            width: double.infinity,
            height: 350,
            fit: BoxFit.cover,
            imageUrl: media.url!,
            placeholder: (_, __) => Image.asset('assets/img/loading.gif', fit: BoxFit.cover),
            errorWidget: (_, __, ___) => Icon(Icons.error_outline),
          ),
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_eService.images!.length, (index) {
          return Container(
            width: 20,
            height: 5,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: controller.currentSlide.value == index ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4),
            ),
          );
        }),
      ),
    );
  }
}
