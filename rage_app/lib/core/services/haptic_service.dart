// lib/core/services/haptic_service.dart
// Native Android VibrationEffect API'ye erişmek için Platform Channel servisi.
// Kırılan materyalin cinsine göre farklı haptik profiller tetiklenir.

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:rage_app/core/constants/app_constants.dart';

/// Haptik geri bildirim servisinin sözleşmesi (Dependency Inversion prensibi).
abstract interface class HapticServiceInterface {
  Future<void> vibrateMaterial(RageMaterialType type);
  Future<void> vibrateImpact({required int intensity});
}

/// Gerçek Android haptik implementasyonu — MethodChannel üzerinden çalışır.
class HapticService implements HapticServiceInterface {
  HapticService() : _channel = const MethodChannel(AppConstants.hapticChannel);

  final MethodChannel _channel;
  final Logger _log = Logger();

  /// Materyal tipine göre önceden tanımlanmış titreşim profilini tetikler.
  /// [type] — kırılan materyalin enum değeri.
  @override
  Future<void> vibrateMaterial(RageMaterialType type) async {
    try {
      await _channel.invokeMethod<void>('vibrateMaterial', {
        'materialType': type.hapticProfile,
      });
    } on PlatformException catch (e) {
      _log.w('HapticService.vibrateMaterial hata: ${e.message}');
    }
  }

  /// Tek seferlik darbe titreşimi — [intensity] 0-255 arası.
  @override
  Future<void> vibrateImpact({required int intensity}) async {
    try {
      await _channel.invokeMethod<void>('vibrateImpact', {
        'intensity': intensity.clamp(0, 255),
      });
    } on PlatformException catch (e) {
      _log.w('HapticService.vibrateImpact hata: ${e.message}');
    }
  }
}

/// Test ortamında kullanılmak üzere no-op implementasyon.
class NoOpHapticService implements HapticServiceInterface {
  @override
  Future<void> vibrateMaterial(RageMaterialType type) async {}

  @override
  Future<void> vibrateImpact({required int intensity}) async {}
}
