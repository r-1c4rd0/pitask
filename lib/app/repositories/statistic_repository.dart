import 'package:get/get.dart';

import '../models/statistic.dart';
import '../providers/laravel_provider.dart';

class StatisticRepository {
 final LaravelApiClient _laravelApiClient  = Get.find<LaravelApiClient>();



  Future<List<Statistic>> getHomeStatistics() async {
    return await _laravelApiClient.getHomeStatistics();
  }
}
