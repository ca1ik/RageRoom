// lib/presentation/screens/splash/splash_screen.dart
// Uygulama başlangıç ekranı — Firebase başlatma, anonim giriş ve routing.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/data/sources/firebase_source.dart';
import 'package:rage_app/presentation/blocs/monetization/monetization_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    if (!AppConstants.enableFirebase) {
      await Get.offAllNamed<void>(AppConstants.routeHome);
      return;
    }

    final firebaseSource = Get.find<FirebaseSource>();
    final cubit = Get.find<MonetizationCubit>();

    // Kullanıcı yoksa anonim giriş yap
    User? user = firebaseSource.currentUser;
    if (user == null) {
      final credential = await firebaseSource.signInAnonymously();
      user = credential.user;
    }

    if (user != null) {
      await cubit.initialize(user.uid);
    }

    if (mounted) {
      await Get.offAllNamed<void>(AppConstants.routeHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ana logo
            const Text(
              '💥',
              style: TextStyle(fontSize: 72),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .then()
                .shake(duration: 400.ms, hz: 6),

            const SizedBox(height: 24),

            const Text(
              'RAGE ROOM',
              style: TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 8),

            const Text(
              'Developer Stress Relief',
              style: TextStyle(
                color: Color(0x80FFFFFF),
                fontSize: 13,
                letterSpacing: 3,
              ),
            ).animate(delay: 600.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 60),

            // Loading indicator
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: Color(0xFFE53935),
                strokeWidth: 2,
              ),
            ).animate(delay: 800.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}
