import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/statistic.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/statistic_repository.dart';
import '../../../services/global_service.dart';
import '../../root/controllers/root_controller.dart';

class HomeController extends GetxController {
  late final StatisticRepository _statisticRepository;
  late final BookingRepository _bookingsRepository;

  final RxList<Statistic> statistics = <Statistic>[].obs;
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxList<BookingStatus> bookingStatuses = <BookingStatus>[].obs;
  final RxInt page = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isDone = false.obs;
  final RxString currentStatus = '1'.obs;

  late ScrollController scrollController;

  HomeController() {
    _statisticRepository = StatisticRepository();
    _bookingsRepository = BookingRepository();
  }

  @override
  Future<void> onInit() async {
    initScrollController();
    await refreshHome();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> refreshHome({bool showMessage = false, String? statusId}) async {
    await getBookingStatuses();
    await getStatistics();
    Get.find<RootController>().getNotificationsCount();
    changeTab(statusId ?? currentStatus.value);
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  void initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadBookingsOfStatus(statusId: currentStatus.value);
      }
    });
  }

  void changeTab(String statusId) async {
    bookings.clear();
    currentStatus.value = statusId;
    page.value = 0;
    await loadBookingsOfStatus(statusId: currentStatus.value);
  }

  Future<void> getStatistics() async {
    try {
      statistics.assignAll(await _statisticRepository.getHomeStatistics());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> getBookingStatuses() async {
    try {
      bookingStatuses.assignAll(await _bookingsRepository.getStatuses());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  BookingStatus getStatusByOrder(int order) {
    return bookingStatuses.firstWhere(
          (s) => s.order == order,
      orElse: () {
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Booking status not found".tr));
        return BookingStatus();
      },
    );
  }

  Future<void> loadBookingsOfStatus({required String statusId}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      page.value++;
      List<Booking> _bookings = [];

      if (bookingStatuses.isNotEmpty) {
        _bookings = await _bookingsRepository.all(statusId, page: page.value);
      }
      if (_bookings.isNotEmpty) {
        bookings.addAll(_bookings);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeBookingStatus(Booking booking, BookingStatus bookingStatus) async {
    try {
      final Booking _booking = Booking(id: booking.id, status: bookingStatus);
      await _bookingsRepository.update(_booking);
      bookings.removeWhere((element) => element.id == booking.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService(Booking booking) async {
    final int acceptedStatus = Get.find<GlobalService>().global.value.accepted ?? 0;
    final BookingStatus _status = getStatusByOrder(acceptedStatus);
    await changeBookingStatus(booking, _status);
    Get.showSnackbar(Ui.SuccessSnackBar(title: "Status Changed".tr, message: "Booking has been accepted".tr));
  }

  Future<void> declineBookingService(Booking booking) async {
    try {
      final int onTheWay = Get.find<GlobalService>().global.value.onTheWay ?? 0;
      if (booking.status!.order! < onTheWay) {
        final int failedStatus = Get.find<GlobalService>().global.value.failed ?? 0;
        final BookingStatus _status = getStatusByOrder(failedStatus);
        final Booking _booking = Booking(id: booking.id, cancel: true, status: _status);
        await _bookingsRepository.update(_booking);
        bookings.removeWhere((element) => element.id == booking.id);
        Get.showSnackbar(Ui.SuccessSnackBar(title: "Status Changed".tr, message: "Booking has been declined".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
