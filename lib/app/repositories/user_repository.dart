import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../providers/firebase_provider.dart';
import '../providers/laravel_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  final LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();
  final FirebaseProvider _firebaseProvider = Get.find<FirebaseProvider>();
  final AuthService _authService = Get.find<AuthService>();

  Future<User> login(User user) {
    return _laravelApiClient.login(user);
  }

  Future<User> get(User user) {
    return _laravelApiClient.getUser(user);
  }

  Future<User> update(User user) {
    return _laravelApiClient.updateUser(user);
  }

  Future<bool> sendResetLinkEmail(User user) {
    return _laravelApiClient.sendResetLinkEmail(user);
  }

  Future<User> getCurrentUser() async {
    return _authService.user.value;
  }

  Future<void> deleteCurrentUser() async {
    await _laravelApiClient.deleteUser(_authService.user.value);
    await _firebaseProvider.deleteCurrentUser();
    _authService.user.value = User();
    GetStorage().remove('current_user');
  }

  Future<User> register(User user) {
    return _laravelApiClient.register(user);
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  Future<void> verifyPhone(String smsCode) async {
    return _firebaseProvider.verifyPhone(smsCode);
  }

  Future<void> sendCodeToPhone() async {
    return _firebaseProvider.sendCodeToPhone();
  }

  Future<void> signOut() async {
    await _firebaseProvider.signOut();
  }
}
