// test/physics_test.dart
// Flame/Forge2D fizik motoru öğeleri için birim testleri.
// Not: Gerçek Forge2D testi FlutterDriver gerektirir.
// Bu testler pure-Dart business logic'ini kapsar.

import 'package:flutter_test/flutter_test.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/presentation/providers/material_provider.dart';

void main() {
  group('MaterialProvider fizik parametreleri', () {
    late MaterialProvider provider;

    setUp(() {
      provider = MaterialProvider();
    });

    test('varsayılan materyal digitalGlass olmalı', () {
      expect(provider.selectedMaterial, RageMaterialType.digitalGlass);
    });

    test('digitalGlass shard sayısı pozitif olmalı', () {
      provider.selectMaterial(RageMaterialType.digitalGlass);
      final params = provider.currentMaterialParams;
      expect(params['shardCount'] as int, greaterThan(0));
    });

    test('bubbleWrap restitution yüksek olmalı (sekme efekti)', () {
      provider.selectMaterial(RageMaterialType.bubbleWrap);
      final params = provider.currentMaterialParams;
      final restitution = params['restitution'] as double;
      expect(restitution, greaterThan(0.5));
    });

    test('crtMonitor yoğunluğu yüksek olmalı (ağır nesne)', () {
      provider.selectMaterial(RageMaterialType.crtMonitor);
      final params = provider.currentMaterialParams;
      final density = params['density'] as double;
      expect(density, greaterThan(1.0));
    });

    test('materyal değişikliği doğru çalışmalı', () {
      provider.selectMaterial(RageMaterialType.porcelainVase);
      expect(provider.selectedMaterial, RageMaterialType.porcelainVase);

      provider.selectMaterial(RageMaterialType.crtMonitor);
      expect(provider.selectedMaterial, RageMaterialType.crtMonitor);
    });
  });

  group('AppConstants sabit değerleri', () {
    test('sessionDurationSeconds 180 olmalı (3 dakika)', () {
      expect(AppConstants.sessionDurationSeconds, 180);
    });

    test('physicsZoom pozitif olmalı', () {
      expect(AppConstants.physicsZoom, greaterThan(0));
    });

    test('defaultShardCount pozitif olmalı', () {
      expect(AppConstants.defaultShardCount, greaterThan(0));
    });

    test('gravityY negatif olmalı (aşağı çekim)', () {
      expect(AppConstants.gravityY, lessThan(0));
    });

    test('route stringler boş olmamalı', () {
      expect(AppConstants.routeHome, isNotEmpty);
      expect(AppConstants.routeRage, isNotEmpty);
      expect(AppConstants.routeZen, isNotEmpty);
    });
  });

  group('RageMaterialType haptic profilleri', () {
    test('her materyal tipi geçerli haptic profili olmalı', () {
      for (final type in RageMaterialType.values) {
        expect(type.hapticProfile, isNotEmpty);
      }
    });

    test('pro materyal tipleri doğru işaretlenmeli', () {
      expect(RageMaterialType.digitalGlass.isPro, isFalse);
      expect(RageMaterialType.porcelainVase.isPro, isTrue);
      expect(RageMaterialType.crtMonitor.isPro, isTrue);
      expect(RageMaterialType.bubbleWrap.isPro, isTrue);
    });
  });
}
