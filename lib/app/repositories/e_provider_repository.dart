import 'package:get/get.dart';

import '../models/address_model.dart';
import '../models/availability_hour_model.dart';
import '../models/award_model.dart';
import '../models/e_provider_model.dart';
import '../models/e_provider_type_model.dart';
import '../models/e_service_model.dart';
import '../models/experience_model.dart';
import '../models/gallery_model.dart';
import '../models/review_model.dart';
import '../models/tax_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class EProviderRepository {
  final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();

  Future<EProvider> get(String eProviderId) async {
    return await _laravelApiClient.getEProvider(eProviderId);
  }

  Future<List<EProvider>> getAll() async {
    return await _laravelApiClient.getEProviders();
  }

  Future<List<Review>> getReviews(String userId) async {
    return await _laravelApiClient.getEProviderReviews(userId);
  }

  Future<Review> getReview(String reviewId) async {
    return await _laravelApiClient.getEProviderReview(reviewId);
  }

  Future<List<Gallery>> getGalleries(String eProviderId) async {
    return await _laravelApiClient.getEProviderGalleries(eProviderId);
  }

  Future<List<Award>> getAwards(String eProviderId) async {
    return await _laravelApiClient.getEProviderAwards(eProviderId);
  }

  Future<List<Experience>> getExperiences(String eProviderId) async {
    return await _laravelApiClient.getEProviderExperiences(eProviderId);
  }

  Future<List<EService>> getEServices({String? eProviderId, int page = 1}) async {
    return await _laravelApiClient.getEProviderEServices(eProviderId!, page);
  }

  Future<List<User>> getAllEmployees() async {
    return await _laravelApiClient.getAllEmployees();
  }

  Future<List<Tax>> getTaxes() async {
    return await _laravelApiClient.getTaxes();
  }

  Future<List<User>> getEmployees(String eProviderId) async {
    return await _laravelApiClient.getEProviderEmployees(eProviderId);
  }

  Future<List<EService>> getPopularEServices({String? eProviderId, int page = 1}) async {
    return await _laravelApiClient.getEProviderPopularEServices(eProviderId!, page);
  }

  Future<List<EService>> getMostRatedEServices({String? eProviderId, int page = 1}) async {
    return await _laravelApiClient.getEProviderMostRatedEServices(eProviderId!, page);
  }

  Future<List<EService>> getAvailableEServices({String? eProviderId, int page = 1}) async {
    return await _laravelApiClient.getEProviderAvailableEServices(eProviderId!, page);
  }

  Future<List<EService>> getFeaturedEServices({String? eProviderId, int page = 1}) async {
    return await _laravelApiClient.getEProviderFeaturedEServices(eProviderId!, page);
  }

  Future<List<EProvider>> getEProviders({int page = 1}) async {
    return await _laravelApiClient.getEProviders(page);
  }

  Future<List<EProviderType>> getEProviderTypes() async {
    return await _laravelApiClient.getEProviderTypes();
  }

  /// Obtém os endereços do usuário
  Future<List<Address>> getAddresses() async {
    return await _laravelApiClient.getAddresses();
  }

  /// Cria um novo endereço para o usuário
  Future<Address> createAddress(Address address) async {
    return await _laravelApiClient.createAddress(address);
  }

  Future<Address> updateAddress(Address address) async {
    return await _laravelApiClient.updateAddress(address);
  }

  Future<void> deleteAddress(Address address) async {
    await _laravelApiClient.deleteAddress(address);
  }

  Future<List<AvailabilityHour>> getAvailabilityHours(EProvider eProvider) async {
    return await _laravelApiClient.getAvailabilityHours(eProvider);
  }

  Future<AvailabilityHour> createAvailabilityHour(AvailabilityHour availabilityHour) async {
    return await _laravelApiClient.createAvailabilityHour(availabilityHour);
  }

  Future<void> deleteAvailabilityHour(AvailabilityHour availabilityHour) async {
    await _laravelApiClient.deleteAvailabilityHour(availabilityHour);
  }

  Future<List<EProvider>> getAcceptedEProviders({int page = 1}) async {
    return await _laravelApiClient.getAcceptedEProviders(page);
  }

  Future<List<EProvider>> getFeaturedEProviders({int page = 1}) async {
    return await _laravelApiClient.getFeaturedEProviders(page);
  }

  Future<List<EProvider>> getPendingEProviders({int page = 1}) async {
    return await _laravelApiClient.getPendingEProviders(page);
  }

  Future<EProvider> create(EProvider eProvider) async {
    return await _laravelApiClient.createEProvider(eProvider);
  }

  Future<EProvider> update(EProvider eProvider) async {
    return await _laravelApiClient.updateEProvider(eProvider);
  }

  Future<void> delete(EProvider eProvider) async {
    await _laravelApiClient.deleteEProvider(eProvider);
  }
}
