// lib/game/components/breakable_object.dart
// Forge2D BodyComponent — dokunulduğunda shard parçacıklarına dönüşür.
// Materyal tipine göre farklı boyut, renk ve kırılma davranışı sergiler.

import 'dart:math' as math;
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/game/components/shard_particle.dart';

/// Ekrandaki kırılabilir nesne.
class BreakableObject extends BodyComponent {
  BreakableObject({
    required Vector2 position,
    required this.materialType,
    required this.restitution,
    required this.friction,
    required this.density,
  })  : _startPosition = position,
        _halfWidth = _calcHalfWidth(materialType),
        _halfHeight = _calcHalfHeight(materialType);

  final RageMaterialType materialType;
  final double restitution;
  final double friction;
  final double density;
  final Vector2 _startPosition;
  final double _halfWidth;
  final double _halfHeight;

  /// Kırılma animasyonu aktif mi?
  bool _isBreaking = false;

  static double _calcHalfWidth(RageMaterialType type) {
    return switch (type) {
      RageMaterialType.digitalGlass => 2.0,
      RageMaterialType.porcelainVase => 1.5,
      RageMaterialType.crtMonitor => 3.0,
      RageMaterialType.bubbleWrap => 3.5,
    };
  }

  static double _calcHalfHeight(RageMaterialType type) {
    return switch (type) {
      RageMaterialType.digitalGlass => 2.5,
      RageMaterialType.porcelainVase => 3.0,
      RageMaterialType.crtMonitor => 2.5,
      RageMaterialType.bubbleWrap => 2.0,
    };
  }

  Color get _materialColor {
    return switch (materialType) {
      RageMaterialType.digitalGlass =>
        const Color(0xFF64B5F6).withValues(alpha: 0.85),
      RageMaterialType.porcelainVase =>
        const Color(0xFFF5F5F5).withValues(alpha: 0.95),
      RageMaterialType.crtMonitor =>
        const Color(0xFF37474F).withValues(alpha: 0.90),
      RageMaterialType.bubbleWrap =>
        const Color(0xFFB3E5FC).withValues(alpha: 0.75),
    };
  }

  // ── Forge2D Body Setup ────────────────────────────────────────────────────

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = _startPosition
      ..linearDamping = 0.3
      ..angularDamping = 0.5;

    final shape = PolygonShape()..setAsBoxXY(_halfWidth, _halfHeight);

    final fixtureDef = FixtureDef(shape)
      ..restitution = restitution
      ..friction = friction
      ..density = density;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  // ── Render ────────────────────────────────────────────────────────────────

  @override
  void render(Canvas canvas) {
    if (_isBreaking) return;

    final paint = Paint()
      ..color = _materialColor
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = _materialColor.withValues(alpha: 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.08;

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: _halfWidth * 2,
      height: _halfHeight * 2,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(0.2));
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(rrect, outlinePaint);

    // Cam efekti: iç parlaklık
    if (materialType == RageMaterialType.digitalGlass) {
      _drawGlassShineLine(canvas);
    }
  }

  void _drawGlassShineLine(Canvas canvas) {
    final shinePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.3)
      ..strokeWidth = 0.15
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(-_halfWidth * 0.6, _halfHeight * 0.7),
      Offset(-_halfWidth * 0.2, -_halfHeight * 0.5),
      shinePaint,
    );
  }

  // ── Kırılma Efekti ────────────────────────────────────────────────────────

  /// Nesneyi parçalara ayırır — shard'ları spawn eder ve kendini kaldırır.
  void breakApart({
    required Vector2 impactPoint,
    required int shardCount,
    required double restitution,
    required double friction,
    required double density,
  }) {
    if (_isBreaking) return;
    _isBreaking = true;

    final currentPos = body.position.clone();
    final currentVel = body.linearVelocity.clone();
    final angle = body.angle;

    // Shard'ları oluştur
    for (var i = 0; i < shardCount; i++) {
      final random = math.Random();
      final shardAngle =
          (i / shardCount) * math.pi * 2 + random.nextDouble() * 0.5;

      // Shard boyutu — materyal tipine göre değişir
      final shardSize = switch (materialType) {
        RageMaterialType.digitalGlass => 0.3 + random.nextDouble() * 0.5,
        RageMaterialType.porcelainVase => 0.4 + random.nextDouble() * 0.6,
        RageMaterialType.crtMonitor => 0.5 + random.nextDouble() * 0.8,
        RageMaterialType.bubbleWrap => 0.2 + random.nextDouble() * 0.3,
      };

      // Impact noktasından dışa doğru fırlat
      final launchDir = Vector2(
        math.cos(shardAngle),
        math.sin(shardAngle),
      );

      final speed = 5.0 + random.nextDouble() * 15.0;
      final velocity = currentVel + launchDir * speed;

      // Shard'ı ekrana ekle
      parent?.add(
        ShardParticle(
          position: currentPos.clone()
            ..add(
              Vector2(
                random.nextDouble() * _halfWidth * 2 - _halfWidth,
                random.nextDouble() * _halfHeight * 2 - _halfHeight,
              ),
            ),
          initialVelocity: velocity,
          initialAngle: angle + random.nextDouble() * math.pi,
          size: shardSize,
          color: _materialColor,
          materialType: materialType,
          restitution: restitution,
          friction: friction,
        ),
      );
    }

    removeFromParent();
  }
}
