import 'package:get/get.dart';

import '../../common/uuid.dart';
import 'category_model.dart';
import 'e_provider_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class EService extends Model {
  String? id;
  String? name;
  String? description;
  List<Media>? images;
  double? price;
  double? discountPrice;
  String? priceUnit;
  String? quantityUnit;
  double? rate;
  int? totalReviews;
  String? duration;
  bool? featured;
  bool? enableBooking;
  bool? isFavorite;
  List<Category>? categories;
  List<Category>? subCategories;
  EProvider? eProvider;

  EService({
    this.id,
    this.name,
    this.description,
    this.images,
    this.price,
    this.discountPrice,
    this.priceUnit,
    this.quantityUnit,
    this.rate,
    this.totalReviews,
    this.duration,
    this.featured,
    this.enableBooking,
    this.isFavorite,
    this.categories,
    this.subCategories,
    this.eProvider,
  });

  EService.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    price = doubleFromJson(json, 'price');
    discountPrice = doubleFromJson(json, 'discount_price');
    priceUnit = stringFromJson(json, 'price_unit');
    quantityUnit = transStringFromJson(json, 'quantity_unit');
    rate = doubleFromJson(json, 'rate');
    totalReviews = intFromJson(json, 'total_reviews');
    duration = stringFromJson(json, 'duration');
    featured = boolFromJson(json, 'featured');
    enableBooking = boolFromJson(json, 'enable_booking');
    isFavorite = boolFromJson(json, 'is_favorite');
    categories = listFromJson<Category>(json, 'categories', (value) => Category.fromJson(value));
    subCategories = listFromJson<Category>(json, 'sub_categories', (value) => Category.fromJson(value));
    eProvider = objectFromJson(json, 'e_provider', (value) => EProvider.fromJson(value));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['price_unit'] = priceUnit;
    data['quantity_unit'] = quantityUnit;
    data['rate'] = rate;
    data['total_reviews'] = totalReviews;
    data['duration'] = duration;
    data['featured'] = featured;
    data['enable_booking'] = enableBooking;
    data['is_favorite'] = isFavorite;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.id).toList();
    }
    if (images != null) {
      data['image'] = images!.where((element) => Uuid.isUuid(element.id!)).map((v) => v.id).toList();
    }
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    if (eProvider != null && eProvider!.hasData) {
      data['e_provider_id'] = eProvider!.id;
    }
    return data;
  }

  String? get firstImageUrl => images?.isNotEmpty == true ? images!.first.url : '';

  String? get firstImageThumb => images?.isNotEmpty == true ? images!.first.thumb : '';

  String? get firstImageIcon => images?.isNotEmpty == true ? images!.first.icon : '';

  @override
  bool get hasData {
    return id?.isNotEmpty == true && name?.isNotEmpty == true && description?.isNotEmpty == true;
  }

  double get getPrice => (discountPrice ?? 0) > 0 ? discountPrice! : price ?? 0;

  double get getOldPrice => (discountPrice ?? 0) > 0 ? price ?? 0 : 0;

  String get getUnit {
    if (priceUnit == 'fixed') {
      return (quantityUnit?.isNotEmpty ?? false) ? "/${quantityUnit!.tr}" : "";
    }
    return "/h".tr;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
          super == other &&
              other is EService &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              rate == other.rate &&
              isFavorite == other.isFavorite &&
              enableBooking == other.enableBooking &&
              categories == other.categories &&
              subCategories == other.subCategories &&
              eProvider == other.eProvider;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      rate.hashCode ^
      eProvider.hashCode ^
      categories.hashCode ^
      subCategories.hashCode ^
      isFavorite.hashCode ^
      enableBooking.hashCode;
}
