// lib/presentation/providers/settings_provider.dart
// Uygulama geneli ayarların yönetimi — SharedPreferences ile kalıcı.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._prefs);

  final SharedPreferences _prefs;

  // ── Ayar anahtarları ──────────────────────────────────────────────────────
  static const String _kCustomBackground = 'custom_bg_path';
  static const String _kNotificationsEnabled = 'notifications_enabled';
  static const String _kAnonymousMode = 'anonymous_mode';
  static const String _kSessionCount = 'session_count';

  // ── Getters ───────────────────────────────────────────────────────────────

  String? get customBackgroundPath => _prefs.getString(_kCustomBackground);
  bool get notificationsEnabled =>
      _prefs.getBool(_kNotificationsEnabled) ?? true;
  bool get anonymousMode => _prefs.getBool(_kAnonymousMode) ?? false;
  int get sessionCount => _prefs.getInt(_kSessionCount) ?? 0;

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
}
