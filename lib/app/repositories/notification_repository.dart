import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../providers/laravel_provider.dart';

class NotificationRepository {
  final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();


  Future<List<Notification>> getAll() async{
    return await _laravelApiClient.getNotifications();
  }

  Future<int> getCount() async{
    return await _laravelApiClient.getNotificationsCount();
  }

  Future<Notification> remove(Notification notification) async {
    return  await _laravelApiClient.removeNotification(notification);
  }

  Future<Notification> markAsRead(Notification notification) async {
    return await _laravelApiClient.markAsReadNotification(notification);
  }

  Future<bool> sendNotification(List<User> users, User from, String type, String text, String id) async{
    return await _laravelApiClient.sendNotification(users, from, type, text, id);
  }
}
