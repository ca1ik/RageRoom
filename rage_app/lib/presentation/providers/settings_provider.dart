// lib/presentation/providers/settings_provider.dart
// Uygulama geneli ayarların yönetimi — SharedPreferences ile kalıcı.

import 'package:flutter/foundation.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs);

  final SharedPreferences _prefs;

  // ── Ayar anahtarları ──────────────────────────────────────────────────────
  static const String _kCustomBackground = 'custom_bg_path';
  static const String _kNotificationsEnabled = 'notifications_enabled';
  static const String _kAnonymousMode = 'anonymous_mode';
  static const String _kSessionCount = 'session_count';
  static const String _kLanguage = 'language';

  // ── Init ──────────────────────────────────────────────────────────────────

  /// Call once at startup to restore persisted language.
  void restoreLanguage() {
    final saved = _prefs.getString(_kLanguage);
    if (saved == 'tr') {
      AppStrings.setLanguage(AppLanguage.tr);
    } else {
      AppStrings.setLanguage(AppLanguage.en);
    }
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  String? get customBackgroundPath => _prefs.getString(_kCustomBackground);
  bool get notificationsEnabled =>
      _prefs.getBool(_kNotificationsEnabled) ?? true;
  bool get anonymousMode => _prefs.getBool(_kAnonymousMode) ?? false;
  int get sessionCount => _prefs.getInt(_kSessionCount) ?? 0;
  AppLanguage get language => AppStrings.current;

  // ── Setters ───────────────────────────────────────────────────────────────

  Future<void> setCustomBackgroundPath(String? path) async {
    if (path == null) {
      await _prefs.remove(_kCustomBackground);
    } else {
      await _prefs.setString(_kCustomBackground, path);
    }
    notifyListeners();
  }

  Future<void> setNotificationsEnabled({required bool enabled}) async {
    await _prefs.setBool(_kNotificationsEnabled, enabled);
    notifyListeners();
  }

  Future<void> setAnonymousMode({required bool enabled}) async {
    await _prefs.setBool(_kAnonymousMode, enabled);
    notifyListeners();
  }

  Future<void> incrementSessionCount() async {
    final newCount = sessionCount + 1;
    await _prefs.setInt(_kSessionCount, newCount);
    notifyListeners();
  }

  Future<void> clearAll() async {
    await _prefs.clear();
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    AppStrings.setLanguage(lang);
    await _prefs.setString(_kLanguage, lang == AppLanguage.tr ? 'tr' : 'en');
    notifyListeners();
  }
}
