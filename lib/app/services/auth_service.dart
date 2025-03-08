import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import 'settings_service.dart';

class AuthService extends GetxService {
  final user = User().obs;
  late GetStorage _box;
  late UserRepository _usersRepo;

  AuthService() {
    _usersRepo = UserRepository();
    _box = GetStorage();
  }

  Future<AuthService> init() async {
    user.listen((User _user) {
      if (Get.isRegistered<SettingsService>()) {
        final settingsService = Get.find<SettingsService>();
        if (settingsService.address.value != null) {
          settingsService.address.value.userId = _user.id;
        }
      }
      _box.write('current_user', _user.toJson());
    });

    await getCurrentUser();
    return this;
  }

  Future<void> getCurrentUser() async {
    if (_box.hasData('current_user')) {
      user.value = User.fromJson(await _box.read('current_user'));
      user.value.auth = true;
    } else {
      user.value.auth = false;
    }
  }

  Future<void> removeCurrentUser() async {
    user.value = User();
    await _usersRepo.signOut();
    await _box.remove('current_user');
  }

  Future<bool> isRoleChanged() async {
    try {
      final _user = await _usersRepo.getCurrentUser();
      if (_user != null && _user.isProvider != user.value.isProvider) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error in isRoleChanged: $e");
      return false;
    }
  }

  bool get isAuth => user.value.auth ?? false;
  String? get apiToken => isAuth ? user.value.apiToken : '';
}
