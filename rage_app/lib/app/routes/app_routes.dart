// lib/app/routes/app_routes.dart
// GetX route tanımları — tüm sayfa navigasyonu buradan yönetilir.

import 'package:get/get.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/presentation/screens/badges/badges_screen.dart';
import 'package:rage_app/presentation/screens/home/home_screen.dart';
import 'package:rage_app/presentation/screens/paywall/paywall_screen.dart';
import 'package:rage_app/presentation/screens/rage/rage_screen.dart';
import 'package:rage_app/presentation/screens/settings/settings_screen.dart';
import 'package:rage_app/presentation/screens/splash/splash_screen.dart';
import 'package:rage_app/presentation/screens/zen/zen_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static List<GetPage<dynamic>> get pages => [
        GetPage<SplashScreen>(
          name: AppConstants.routeSplash,
          page: SplashScreen.new,
          transition: Transition.fadeIn,
        ),
        GetPage<HomeScreen>(
          name: AppConstants.routeHome,
          page: HomeScreen.new,
          transition: Transition.cupertino,
        ),
        GetPage<RageScreen>(
          name: AppConstants.routeRage,
          page: RageScreen.new,
          transition: Transition.downToUp,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage<ZenScreen>(
          name: AppConstants.routeZen,
          page: ZenScreen.new,
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 800),
        ),
        GetPage<BadgesScreen>(
          name: AppConstants.routeBadges,
          page: BadgesScreen.new,
          transition: Transition.rightToLeft,
        ),
        GetPage<SettingsScreen>(
          name: AppConstants.routeSettings,
          page: SettingsScreen.new,
          transition: Transition.rightToLeft,
        ),
        GetPage<PaywallScreen>(
          name: AppConstants.routePaywall,
          page: PaywallScreen.new,
          transition: Transition.downToUp,
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ];
}
