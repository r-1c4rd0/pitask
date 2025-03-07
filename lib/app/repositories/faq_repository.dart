import 'package:get/get.dart';

import '../models/faq_category_model.dart';
import '../models/faq_model.dart';
import '../providers/laravel_provider.dart';

class FaqRepository {
  final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();


  Future<List<FaqCategory>> getFaqCategories() async{
    return await _laravelApiClient.getFaqCategories();
  }

  Future<List<Faq>> getFaqs(String categoryId) async{
    return await _laravelApiClient.getFaqs(categoryId);
  }
}
