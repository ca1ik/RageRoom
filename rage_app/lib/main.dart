// lib/main.dart
// Uygulama giriş noktası.
// Firebase init → Crashlytics → DI → SharedPrefs → runApp.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rage_app/app/app.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/core/di/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Yalnızca dikey mod — oyun alanı için
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Durum çubuğunu gizle — tam ekran oyun deneyimi
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  var firebaseReady = false;
  if (AppConstants.enableFirebase) {
    try {
      // Firebase: hata yakalamak için
      await Firebase.initializeApp();
      firebaseReady = true;
    } catch (e) {
      // google-services.json / values.xml yoksa debug modda uygulama yine acilsin
      debugPrint('Firebase initialize skipped: $e');
    }
  }

  // Hata işleyicileri yalnızca release modda aktif
  if (!kDebugMode && firebaseReady) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // GetIt servis bağımlılıklarını başlat
  await configureDependencies();

  // SharedPreferences — provider başlatma için
  final prefs = await SharedPreferences.getInstance();

  runApp(RageApp(prefs: prefs));
}
