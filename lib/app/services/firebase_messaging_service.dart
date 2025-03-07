import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../models/booking_model.dart';
import '../models/message_model.dart';
import '../modules/bookings/controllers/booking_controller.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/messages/controllers/messages_controller.dart';
import '../modules/root/controllers/root_controller.dart';
import '../routes/app_routes.dart';
import 'auth_service.dart';

class FireBaseMessagingService extends GetxService {
  Future<FireBaseMessagingService> init() async {
    FirebaseMessaging.instance.requestPermission(sound: true, badge: true, alert: true);
    await _fcmOnLaunchListeners();
    await _fcmOnResumeListeners();
    await _fcmOnMessageListeners();
    return this;
  }

  Future<void> _fcmOnMessageListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Get.isRegistered<RootController>()) {
        Get.find<RootController>().getNotificationsCount();
      }
      if (message.data['id'] == "App\\Notifications\\NewMessage") {
        _newMessageNotification(message);
      } else {
        _bookingNotification(message);
      }
    });
  }

  Future<void> _fcmOnLaunchListeners() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _notificationsBackground(message);
    }
  }

  Future<void> _fcmOnResumeListeners() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationsBackground(message);
    });
  }

  void _notificationsBackground(RemoteMessage message) {
    if (message.data['id'] == "App\\Notifications\\NewMessage") {
      _newMessageNotificationBackground(message);
    } else {
      _newBookingNotificationBackground(message);
    }
  }

  void _newBookingNotificationBackground(RemoteMessage message) {
    if (Get.isRegistered<RootController>()) {
      Get.toNamed(Routes.BOOKING, arguments: Booking(id: message.data['bookingId']));
    }
  }

  void _newMessageNotificationBackground(RemoteMessage message) {
    if (message.data['messageId'] != null) {
      Get.toNamed(Routes.CHAT, arguments: Message([], id: message.data['messageId']));
    }
  }

  Future<void> setDeviceToken() async {
    Get.find<AuthService>().user.value.deviceToken = (await FirebaseMessaging.instance.getToken())!;
  }

  void _bookingNotification(RemoteMessage message) {
    if (Get.currentRoute == Routes.ROOT && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshHome();
    }
    if (Get.currentRoute == Routes.BOOKING && Get.isRegistered<BookingController>()) {
      Get.find<BookingController>().refreshBooking();
    }

    RemoteNotification? notification = message.notification;
    if (notification == null) return;

    Get.showSnackbar(Ui.SuccessSnackBar(
      title: notification.title ?? "Nova Notificação",
      message: notification.body ?? "Você recebeu uma nova atualização.",

      /*mainButton: _buildNotificationIcon(message.data['icon']),
      onTap: (getBar) async {
        if (message.data['bookingId'] != null) {
          await Get.back();
          Get.toNamed(Routes.BOOKING, arguments: Booking(id: message.data['bookingId']));
        }
      },*/
    ));
  }

  void _newMessageNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;

    if (Get.isRegistered<MessagesController>() && Get.find<MessagesController>().initialized) {
      Get.find<MessagesController>().refreshMessages();
    }

    if (Get.currentRoute != Routes.CHAT) {
      Get.showSnackbar(Ui.SuccessSnackBar(
        title: notification.title ?? "Nova Mensagem",
        message: notification.body ?? "Você recebeu uma nova mensagem.",

        /*mainButton: _buildNotificationIcon(message.data['icon']),
        onTap: (getBar) async {
          if (message.data['messageId'] != null) {
            await Get.back();
            Get.toNamed(Routes.CHAT, arguments: Message([], id: message.data['messageId']));
          }
        },*/
      ));
    }
  }

  Widget _buildNotificationIcon(String? imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 52,
      height: 52,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: CachedNetworkImage(
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl: imageUrl ?? "",
          placeholder: (context, url) => Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error_outline),
        ),
      ),
    );
  }
}
