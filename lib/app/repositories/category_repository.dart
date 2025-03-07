import 'package:get/get.dart';

import '../models/category_model.dart';
import '../providers/laravel_provider.dart';

class CategoryRepository {
  final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();

  Future<List<Category>> getAll() async {
    return await _laravelApiClient.getAllCategories();
  }

  Future<List<Category>> getAllParents() async {
    return await _laravelApiClient.getAllParentCategories();
  }

  Future<List<Category>> getAllWithSubCategories() async {
    return await _laravelApiClient.getAllWithSubCategories();
  }
}
