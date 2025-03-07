import 'package:get/get.dart';

import '../models/custom_page_model.dart';
import '../providers/laravel_provider.dart';

class CustomPageRepository {
  final LaravelApiClient _laravelApiClient= Get.find<LaravelApiClient>();

  Future<List<CustomPage>> all() async {
    return await _laravelApiClient.getCustomPages();
  }

  Future<CustomPage> get(String id) async {
    return await _laravelApiClient.getCustomPageById(id);
  }
}
