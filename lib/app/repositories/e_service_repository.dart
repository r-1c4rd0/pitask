import 'package:get/get.dart';

import '../models/e_service_model.dart';
import '../models/option_group_model.dart';
import '../models/option_model.dart';
import '../models/review_model.dart';
import '../providers/laravel_provider.dart';

class EServiceRepository {
   final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();


  Future<List<EService>> search(String keywords, List<String> categories, {int page = 1}) {
    return _laravelApiClient.searchEServices(keywords, categories, page);
  }

  Future<EService> get(String id) async {
    return  await _laravelApiClient.getEService(id);
  }

  Future<EService> create(EService eService) async {
    return await _laravelApiClient.createEService(eService);
  }

  Future<EService> update(EService eService) async{
    return await _laravelApiClient.updateEService(eService);
  }

  Future<bool> delete(String eServiceId) async{
    return await _laravelApiClient.deleteEService(eServiceId);
  }

  Future<List<Review>> getReviews(String eServiceId) async{
    return await _laravelApiClient.getEServiceReviews(eServiceId);
  }

  Future<List<OptionGroup>> getOptionGroups(String eServiceId) async{
    return await _laravelApiClient.getEServiceOptionGroups(eServiceId);
  }

  Future<List<OptionGroup>> getAllOptionGroups() async{
    return await _laravelApiClient.getOptionGroups();
  }

  Future<Option> createOption(Option option) async{
    return await _laravelApiClient.createOption(option);
  }

  Future<Option> updateOption(Option option) async{
    return await _laravelApiClient.updateOption(option);
  }

  Future<bool> deleteOption(String optionId) async{
    return await _laravelApiClient.deleteOption(optionId);
  }
}
