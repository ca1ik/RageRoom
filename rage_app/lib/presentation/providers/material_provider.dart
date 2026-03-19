// lib/presentation/providers/material_provider.dart
// Provider — seçili kırılabilir materyal temasını ve ayarlarını yönetir.

import 'package:flutter/foundation.dart';
import 'package:rage_app/core/constants/app_constants.dart';

class MaterialProvider extends ChangeNotifier {
  RageMaterialType _selectedMaterial = RageMaterialType.digitalGlass;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  double _particleIntensity = 1; // 0.5 düşük — 2.0 yoğun

  RageMaterialType get selectedMaterial => _selectedMaterial;
  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;
  double get particleIntensity => _particleIntensity;

  /// Materyal tipini değiştirir — PRO kontrolü dışarıdan yapılır.
  void selectMaterial(RageMaterialType type) {
    if (_selectedMaterial == type) return;
    _selectedMaterial = type;
    notifyListeners();
  }

  void toggleSound({required bool enabled}) {
    _soundEnabled = enabled;
    notifyListeners();
  }

  void toggleHaptic({required bool enabled}) {
    _hapticEnabled = enabled;
    notifyListeners();
  }

  void setParticleIntensity(double intensity) {
    _particleIntensity = intensity.clamp(0.5, 2.0);
    notifyListeners();
  }

  /// Materyal fizik parametrelerini döndürür.
  /// Şu an için sabit; ileriki versiyonlarda assets/data/materials.json'dan yüklenir.
  Map<String, dynamic> get currentMaterialParams {
    return switch (_selectedMaterial) {
      RageMaterialType.digitalGlass => {
          'shardCount': 18,
          'restitution': 0.3,
          'friction': 0.2,
          'density': 1.2,
        },
      RageMaterialType.porcelainVase => {
          'shardCount': 24,
          'restitution': 0.1,
          'friction': 0.6,
          'density': 2.0,
        },
      RageMaterialType.crtMonitor => {
          'shardCount': 30,
          'restitution': 0.05,
          'friction': 0.8,
          'density': 3.5,
        },
      RageMaterialType.bubbleWrap => {},
    };
  }
}
