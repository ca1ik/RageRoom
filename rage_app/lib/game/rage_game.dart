// lib/game/rage_game.dart
// Ana Flame/Forge2D oyun motoru.
// 60 FPS fizik simülasyonu, dokunmatik kırım, parti efektleri.

import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/game/components/background_component.dart';
import 'package:rage_app/game/components/breakable_object.dart';
import 'package:rage_app/game/components/world_boundaries.dart';

/// Oyun motoru geri bildirim callback'leri.
typedef OnObjectBroken = void Function({
  required int shardCount,
  required RageMaterialType materialType,
});

/// Ana Forge2D tabanlı Rage Room oyun motoru.
/// - Dokunma noktasına yakın nesneyi kırar.
/// - Kırılan nesne ShardParticle'lara dönüşür.
/// - Parçalar yerçekimiyle düşer ve sınırlardan sekme yapar.
class RageGame extends Forge2DGame with TapCallbacks {
  RageGame({
    required this.onObjectBroken,
    required this.materialType,
    this.customBackgroundPath,
  }) : super(
          gravity: Vector2(0, AppConstants.gravityY),
          zoom: AppConstants.physicsZoom,
        );

  final OnObjectBroken onObjectBroken;
  RageMaterialType materialType;
  final String? customBackgroundPath;

  /// Ekrandaki kırılabilir nesnelerin listesi.
  final List<BreakableObject> _breakableObjects = [];

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Color backgroundColor() => const Color(0xFF0A0A0F);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Fizik sınırlarını yükle (zemin, duvarlar, tavan)
    await add(WorldBoundaries());

    // Arkaplanı yükle
    await add(BackgroundComponent(customImagePath: customBackgroundPath));

    // İlk nesne setini spawn et
    await _spawnInitialObjects();
  }

  // ── Dokunma İşleme ────────────────────────────────────────────────────────

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    final tap = event.localPosition;
    // Flame Vector2'sini (32-bit) Forge2D Vector2'sine (64-bit) dönüştür
    // screenToWorld dönerken dynamic olabilir (forge2d_game.dart'taki ambiguous import nedeniyle)
    // ignore: avoid_dynamic_calls
    final Vector2 worldPos =
        screenToWorld(Vector2(tap.x.toDouble(), tap.y.toDouble())) as Vector2;

    // En yakın kırılabilir nesneyi bul
    BreakableObject? nearest;
    double minDist = double.infinity;

    for (final obj in List.of(_breakableObjects)) {
      final dist = (obj.body.position - worldPos).length;
      if (dist < minDist && dist < 8.0) {
        // 8 fizik birimi yakınlık eşiği
        minDist = dist;
        nearest = obj;
      }
    }

    if (nearest != null) {
      _breakObject(nearest, worldPos);
    } else {
      // Boş alana vuruldu — bütün nesnelere dalga etkisi uygula
      _applyShockwave(worldPos);
    }
  }

  // ── Kırım Mantığı ─────────────────────────────────────────────────────────

  void _breakObject(BreakableObject obj, Vector2 impactPoint) {
    _breakableObjects.remove(obj);

    final params = _getMaterialParams(materialType);
    final shardCount = (params['shardCount'] as int) +
        (params['shardCount'] as int) ~/ 3 * 0; // sabit şimdilik

    // Nesneyi kır (shard'ları spawn eder ve kendini dünyadan çıkarır)
    obj.breakApart(
      impactPoint: impactPoint,
      shardCount: shardCount,
      restitution: (params['restitution'] as num).toDouble(),
      friction: (params['friction'] as num).toDouble(),
      density: (params['density'] as num).toDouble(),
    );

    // BLoC'a bildir
    onObjectBroken(
      shardCount: shardCount,
      materialType: materialType,
    );

    // Yeni nesne üret (gecikmeyle, animate gibi görünsün)
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!isMounted) return;
      _spawnSingleObject();
    });
  }

  void _applyShockwave(Vector2 center) {
    for (final obj in _breakableObjects) {
      final direction = obj.body.position - center;
      final distance = direction.length;
      if (distance < 15.0) {
        final force = direction.normalized() * (500 / (distance + 1));
        obj.body.applyLinearImpulse(force);
      }
    }
  }

  // ── Nesne Yönetimi ────────────────────────────────────────────────────────

  Future<void> _spawnInitialObjects() async {
    // 3x2 grid düzeninde başlangıç nesneleri
    final positions = [
      Vector2(-8, 5),
      Vector2(0, 5),
      Vector2(8, 5),
      Vector2(-4, 15),
      Vector2(4, 15),
    ];

    for (final pos in positions) {
      await _spawnAt(pos);
    }
  }

  Future<void> _spawnSingleObject() async {
    if (_breakableObjects.length >= 8) return;

    // Rastgele x pozisyonu, üst kısımdan düşsün
    final x = (camera.visibleWorldRect.width * (0.1 + 0.8 * _pseudoRandom())) -
        camera.visibleWorldRect.width / 2;
    await _spawnAt(Vector2(x, -10));
  }

  Future<void> _spawnAt(Vector2 position) async {
    final params = _getMaterialParams(materialType);
    final obj = BreakableObject(
      position: position,
      materialType: materialType,
      restitution: (params['restitution'] as num).toDouble(),
      friction: (params['friction'] as num).toDouble(),
      density: (params['density'] as num).toDouble(),
    );
    _breakableObjects.add(obj);
    await add(obj);
  }

  /// Materyal tipini günceller ve tüm nesneleri temizleyip yeniden oluşturur.
  Future<void> changeMaterial(RageMaterialType newMaterial) async {
    materialType = newMaterial;
    // Mevcut nesneleri temizle
    for (final obj in List.of(_breakableObjects)) {
      _breakableObjects.remove(obj);
      obj.removeFromParent();
    }
    await _spawnInitialObjects();
  }

  // ── Yardımcı Metotlar ─────────────────────────────────────────────────────

  Map<String, dynamic> _getMaterialParams(RageMaterialType type) {
    return switch (type) {
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
      RageMaterialType.bubbleWrap => {
          'shardCount': 40,
          'restitution': 0.6,
          'friction': 0.1,
          'density': 0.3,
        },
    };
  }

  /// Basit zaman tabanlı pseudo random (dart:math olmadan saf).
  double _pseudoRandom() {
    return (DateTime.now().microsecondsSinceEpoch % 1000) / 1000.0;
  }
}
