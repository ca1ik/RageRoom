// lib/core/constants/app_constants.dart
// Uygulamanın tüm sabit değerleri burada tanımlanır.
// ignore_for_file: avoid_classes_with_only_static_members

/// Uygulama genelindeki sabitler.
abstract class AppConstants {
  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'Rage Room';

  // ── Firebase / RevenueCat ─────────────────────────────────────────────────
  static const bool enableFirebase = false;
  static const String revenueCatApiKeyAndroid = 'goog_REPLACE_WITH_YOUR_KEY';

  // ── Platform Channel ──────────────────────────────────────────────────────
  static const String hapticChannel = 'com.example.rage_app/haptic';

  // ── Game ──────────────────────────────────────────────────────────────────
  /// Fizik simülasyonu zoom faktörü: 1 fizik birimi = 10 ekran piksel
  static const double physicsZoom = 10;

  /// Yerçekimi (piksel/s² cinsinden fizik motoru için)
  static const double gravityY = -10;

  /// Saniyedeki maksimum kare yenileme sayısı
  static const int targetFps = 60;

  /// Rage seansının süresi: 3 dakika
  static const int sessionDurationSeconds = 180;

  /// Bir dokunuşta oluşan shard (parça) sayısı
  static const int defaultShardCount = 18;

  // ── Monetization ─────────────────────────────────────────────────────────
  static const String proEntitlementId = 'rage_pro';
  static const String proMonthlyProductId = 'rage_pro_monthly';
  static const String proYearlyProductId = 'rage_pro_yearly';
  static const String proLifetimeProductId = 'rage_pro_lifetime';

  // ── Hive Box Keys ─────────────────────────────────────────────────────────
  static const String sessionsBoxKey = 'rage_sessions';
  static const String settingsBoxKey = 'rage_settings';
  static const String badgesBoxKey = 'rage_badges';

  // ── Route Names ──────────────────────────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeHome = '/home';
  static const String routeRage = '/rage';
  static const String routeZen = '/zen';
  static const String routeBadges = '/badges';
  static const String routeSettings = '/settings';
  static const String routePaywall = '/paywall';

  // ── Firestore Collection Names ────────────────────────────────────────────
  static const String colUsers = 'users';
  static const String colSessions = 'sessions';
  static const String colBadges = 'badges';

  // ── API ───────────────────────────────────────────────────────────────────
  static const String apiBaseUrl = 'https://api.rageroom.app/v1';
  static const Duration apiTimeout = Duration(seconds: 10);
}

/// Rozet ID'leri — "Zero Bug Tolerance" gamification sistemi.
abstract class BadgeIds {
  static const String firstRage = 'first_rage';
  static const String syntaxErrorSlayer = 'syntax_error_slayer';
  static const String deadlineSurvivor = 'deadline_survivor';
  static const String tubitakWarrior = 'tubitak_warrior';
  static const String centuryDestroyer = 'century_destroyer';
  static const String zenMaster = 'zen_master';
  static const String proUnlocked = 'pro_unlocked';
}

/// Materyal tipleri — kırılma fizik profili için.
/// NOT: Flutter'ın kendi MaterialType enum'u ile çakışmamak için
/// RageMaterialType adı kullanılmıştır.
enum RageMaterialType {
  digitalGlass,
  porcelainVase,
  crtMonitor,
  bubbleWrap;

  String get hapticProfile {
    return switch (this) {
      RageMaterialType.digitalGlass => 'glass',
      RageMaterialType.porcelainVase => 'ceramic',
      RageMaterialType.crtMonitor => 'crt_monitor',
      RageMaterialType.bubbleWrap => 'bubble_wrap',
    };
  }

  bool get isPro {
    return switch (this) {
      RageMaterialType.digitalGlass => false,
      _ => true,
    };
  }

  String get displayName {
    return switch (this) {
      RageMaterialType.digitalGlass => 'Dijital Cam',
      RageMaterialType.porcelainVase => 'Porselen Vazo',
      RageMaterialType.crtMonitor => 'Eski CRT Monitör',
      RageMaterialType.bubbleWrap => 'Balonlu Naylon',
    };
  }
}
