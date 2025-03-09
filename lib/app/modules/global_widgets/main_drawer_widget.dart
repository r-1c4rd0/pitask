import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        children: [
          Obx(() {
            if (!Get.find<AuthService>().isAuth) {
              return _buildGuestHeader();
            } else {
              return _buildUserHeader(context);
            }
          }),
          SizedBox(height: 20),
          if (Get.find<AuthService>().user.value?.isProvider ?? false)
            DrawerLinkWidget(
              icon: Icons.assignment_outlined,
              text: "Bookings",
              onTap: (_) => _changePage(0),
            ),
          DrawerLinkWidget(
            icon: Icons.folder_special_outlined,
            text: "My Services",
            onTap: (_) => Get.offAndToNamed(Routes.E_SERVICES),
          ),
          DrawerLinkWidget(
            icon: Icons.build_circle_outlined,
            text: "My Providers",
            onTap: (_) => Get.offAndToNamed(Routes.E_PROVIDERS),
          ),
          DrawerLinkWidget(
            icon: Icons.notifications_none_outlined,
            text: "Notifications",
            onTap: (_) => Get.offAndToNamed(Routes.NOTIFICATIONS),
          ),
          if (_isSubscriptionEnabled())
            _buildSubscriptionLinks(),
          _buildAppPreferences(),
          if (Get.find<AuthService>().user.value?.isProvider ?? false)
            DrawerLinkWidget(
              icon: Icons.person_outline,
              text: "Account",
              onTap: (_) => _changePage(3),
            ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (_) => Get.offAndToNamed(Routes.SETTINGS),
          ),
          DrawerLinkWidget(
            icon: Icons.translate_outlined,
            text: "Languages",
            onTap: (_) => Get.offAndToNamed(Routes.SETTINGS_LANGUAGE),
          ),
          DrawerLinkWidget(
            icon: Icons.brightness_6_outlined,
            text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
            onTap: (_) => Get.offAndToNamed(Routes.SETTINGS_THEME_MODE),
          ),
          _buildHelpAndPrivacy(),
          if (Get.find<AuthService>().user.value?.isProvider ?? false) CustomPageDrawerLinkWidget(),
          Obx(() {
            return Get.find<AuthService>().isAuth
                ? DrawerLinkWidget(
              icon: Icons.logout,
              text: "Logout",
              onTap: (_) async {
                await Get.find<AuthService>().removeCurrentUser();
                await Get.offNamedUntil(Routes.LOGIN, (route) => route.settings.name == Routes.LOGIN);
              },
            )
                : SizedBox();
          }),
          if (Get.find<SettingsService>().setting.value.enableVersion ?? false)
            _buildVersionInfo(),
        ],
      ),
    );
  }

  Widget _buildGuestHeader() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.LOGIN),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        decoration: BoxDecoration(color: Get.theme.hintColor.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome".tr, style: Get.textTheme.headlineSmall?.copyWith(color: Get.theme.colorScheme.secondary)),
            SizedBox(height: 5),
            Text("Login account or create new one for free".tr, style: Get.textTheme.bodyLarge),
            SizedBox(height: 15),
            Wrap(
              spacing: 10,
              children: [
                _buildButton("Login", Icons.exit_to_app_outlined, Get.theme.colorScheme.secondary, Routes.LOGIN),
                _buildButton("Register", Icons.person_add_outlined, Get.theme.focusColor.withOpacity(0.2), Routes.REGISTER),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    final user = Get.find<AuthService>().user.value;
    return GestureDetector(
      onTap: () => Get.find<RootController>().changePageOutRoot(3),
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: Get.theme.hintColor.withOpacity(0.1)),
        accountName: Text(user?.name ?? "", style: Get.textTheme.titleLarge),
        accountEmail: Text(user?.email ?? "", style: Get.textTheme.bodySmall),
        currentAccountPicture: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                imageUrl: user?.avatar?.thumb ?? "",
                placeholder: (_, __) => Image.asset('assets/img/loading.gif', height: 80),
                errorWidget: (_, __, ___) => Icon(Icons.error_outline),
              ),
            ),
            if (user?.verifiedPhone ?? false)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Color color, String route) {
    return MaterialButton(
      onPressed: () => Get.toNamed(route),
      color: color,
      height: 40,
      elevation: 0,
      child: Wrap(
        spacing: 9,
        children: [
          Icon(icon, color: Get.theme.primaryColor, size: 24),
          Text(text.tr, style: Get.textTheme.titleMedium?.copyWith(color: Get.theme.primaryColor)),
        ],
      ),
      shape: StadiumBorder(),
    );
  }

  bool _isSubscriptionEnabled() {
    return Get.find<AuthService>().user.value?.isProvider ?? false &&
        (Get.find<SettingsService>().setting.value.modules?.contains("Subscription") ?? false);
  }

  Widget _buildSubscriptionLinks() {
    return Column(
      children: [
        ListTile(
          dense: true,
          title: Text("Subscriptions & Payments".tr, style: Get.textTheme.bodySmall),
          trailing: Icon(Icons.remove, color: Get.theme.focusColor.withOpacity(0.3)),
        ),
        DrawerLinkWidget(icon: Icons.fact_check_outlined, text: "Subscriptions History", onTap: (_) => Get.offAndToNamed(Routes.SUBSCRIPTIONS)),
        DrawerLinkWidget(icon: Icons.auto_awesome_mosaic_outlined, text: "Subscription Packages", onTap: (_) => Get.offAndToNamed(Routes.PACKAGES)),
        DrawerLinkWidget(icon: Icons.account_balance_wallet_outlined, text: "Wallets", onTap: (_) async => await Get.offAndToNamed(Routes.WALLETS)),
      ],
    );
  }

  Widget _buildAppPreferences() {
    return ListTile(
      dense: true,
      title: Text("Application preferences".tr, style: Get.textTheme.bodySmall),
      trailing: Icon(Icons.remove, color: Get.theme.focusColor.withOpacity(0.3)),
    );
  }

  Widget _buildHelpAndPrivacy() {
    return ListTile(
      dense: true,
      title: Text("Help & Privacy", style: Get.textTheme.bodySmall),
      trailing: Icon(Icons.remove, color: Get.theme.focusColor.withOpacity(0.3)),
    );
  }

  Widget _buildVersionInfo() {
    return ListTile(
      dense: true,
      title: Text("Version".tr + " " + (Get.find<SettingsService>().setting.value.appVersion ?? ""), style: Get.textTheme.bodySmall),
      trailing: Icon(Icons.remove, color: Get.theme.focusColor.withOpacity(0.3)),
    );
  }

  void _changePage(int index) {
    Get.back();
    Get.find<RootController>().changePage(index);
  }
}
