import 'dart:async';

import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../models/booking_status_model.dart';
import '../../../models/media_model.dart';
import '../../../models/message_model.dart';
import '../../../models/payment_model.dart';
import '../../../models/payment_status_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/booking_repository.dart';
import '../../../repositories/e_provider_repository.dart';
import '../../../repositories/payment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../home/controllers/home_controller.dart';

class BookingController extends GetxController {
  final BookingRepository _bookingRepository = BookingRepository();
  final EProviderRepository _eProviderRepository = EProviderRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();

  final bookingStatuses = <BookingStatus>[].obs;
  final booking = Booking().obs;
  final duration = 0.0.obs; // 🔹 Substituindo Timer por RxDouble
  Timer? _timer;

  @override
  void onInit() {
    booking.value = Get.arguments as Booking? ?? Booking();
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshBooking();
    super.onReady();
  }

  @override
  void onClose() {
    _timer
        ?.cancel(); // 🔹 Garante que o timer seja cancelado ao fechar o controller
    super.onClose();
  }

  Future refreshBooking({bool showMessage = false}) async {
    await getBooking();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "Booking page refreshed successfully".tr));
    }
  }

  Future<void> getBooking() async {
    try {
      final fetchedBooking = await _bookingRepository.get(
          booking.value.id ?? '');
      booking.value = fetchedBooking;

      final int inProgress = Get
          .find<GlobalService>()
          .global
          .value
          .inProgress ?? 0;
      if (booking.value.status ==
          Get.find<HomeController>().getStatusByOrder(inProgress)) {
        _startTimer();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void _startTimer() {
    _timer
        ?.cancel(); // 🔹 Garante que um novo Timer não seja criado se já existir
    _timer = Timer.periodic(Duration(minutes: 1), (t) {
      duration.value += 1.0 / 60; // 🔹 Para evitar problemas de precisão
    });
  }

  Future<void> changeBookingStatus(BookingStatus bookingStatus) async {
    try {
      await _bookingRepository.update(
          Booking(id: booking.value.id, status: bookingStatus));
      booking.update((val) => val?.status = bookingStatus);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> acceptBookingService() async {
    final int received = Get
        .find<GlobalService>()
        .global
        .value
        .received ?? 0;
    if (booking.value.status?.order == received) {
      final _status = Get.find<HomeController>().getStatusByOrder(Get
          .find<GlobalService>()
          .global
          .value
          .accepted ?? 0);
      await changeBookingStatus(_status);
    }
  }

  Future<void> onTheWayBookingService() async {
    final _status = Get.find<HomeController>().getStatusByOrder(Get
        .find<GlobalService>()
        .global
        .value
        .onTheWay ?? 0);
    await changeBookingStatus(_status);
  }

  Future<void> readyBookingService() async {
    final _status = Get.find<HomeController>().getStatusByOrder(Get
        .find<GlobalService>()
        .global
        .value
        .ready ?? 0);
    await changeBookingStatus(_status);
  }

  Future<void> confirmPaymentBookingService() async {
    try {
      final _status = Get.find<HomeController>().getStatusByOrder(Get
          .find<GlobalService>()
          .global
          .value
          .done ?? 0);
      final _payment = Payment(id: booking.value.payment?.id ?? '',
          paymentStatus: PaymentStatus(id: '2')); // "Paid"
      final result = await _paymentRepository.update(_payment);
      booking.update((val) {
        val?.payment = result;
        val?.status = _status;
      });
      _timer?.cancel();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> declineBookingService() async {
    try {
      final int onTheWay = Get
          .find<GlobalService>()
          .global
          .value
          .onTheWay ?? 0;
      if ((booking.value.status?.order ?? 0) < onTheWay) {
        final int failed = Get
            .find<GlobalService>()
            .global
            .value
            .failed ?? 0;
        final _status = Get.find<HomeController>().getStatusByOrder(failed);
        final _booking = Booking(
            id: booking.value.id, cancel: true, status: _status);
        await _bookingRepository.update(_booking);
        booking.update((val) {
          val?.cancel = true;
          val?.status = _status;
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  String getTime({String separator = ":"}) {
    int minutesInt = ((duration.value - duration.value.toInt()) * 60).toInt();
    int hoursInt = duration.value.toInt();

    String hours = hoursInt < 10 ? "0$hoursInt" : "$hoursInt";
    String minutes = minutesInt < 10 ? "0$minutesInt" : "$minutesInt";

    return "$hours$separator$minutes";
  }

  Future<void> startChat() async {
    List<User> _employees = await _eProviderRepository.getEmployees(
        booking.value.eProvider?.id ?? '');

    _employees = _employees.map((e) {
      e.avatar = (booking.value.eProvider?.images?.isNotEmpty ?? false)
          ? booking.value.eProvider!.images![0] // ✅ Correção aqui
          : Media();
      return e;
    }).toSet().toList();

    _employees.insert(
        0, booking.value.user ?? User()); // ✅ Evita erro se `user` for null
    Message _message = Message(
        _employees, name: booking.value.eProvider?.name ?? '');
    Get.toNamed(Routes.CHAT, arguments: _message);
  }

}