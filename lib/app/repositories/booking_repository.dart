import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/booking_status_model.dart';
import '../providers/laravel_provider.dart';

class BookingRepository {
  final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();

  Future<List<Booking>> all(String statusId, {int page = 1}) async {
    return await _laravelApiClient.getBookings(statusId, page);
  }

  Future<List<BookingStatus>> getStatuses() async {
    return await _laravelApiClient.getBookingStatuses();
  }

  Future<Booking> get(String bookingId) async {
    return await _laravelApiClient.getBooking(bookingId);
  }

  Future<Booking> update(Booking booking) async {
    return await _laravelApiClient.updateBooking(booking);
  }
}
