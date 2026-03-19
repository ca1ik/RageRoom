// lib/game/components/shard_particle.dart
// Forge2D BodyComponent — kırılan nesneden çıkan parça.
// Yerçekimiyle düşer, sınırlardan sekme yapar ve zaman aşımında solar.

import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:rage_app/core/constants/app_constants.dart';

class ShardParticle extends BodyComponent {
  ShardParticle({
    required Vector2 position,
    required this.initialVelocity,
    required this.initialAngle,
    required this.size,
    required this.color,
    required this.materialType,
    required this.restitution,
    required this.friction,
  }) : _startPosition = position;

  final Vector2 initialVelocity;
  final double initialAngle;
  final double size;
  final Color color;
  final RageMaterialType materialType;
  final double restitution;
  final double friction;
  final Vector2 _startPosition;

  // Opacity için yaşam süresi
  double _age = 0;
  static const double _maxAge = 8; // saniye

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = _startPosition
      ..angle = initialAngle
      ..linearVelocity = initialVelocity
      ..linearDamping = 0.1
      ..angularDamping = 0.2;

    // Shard şekli — materyal tipine göre farklı polygon
    final Shape shape = switch (materialType) {
      RageMaterialType.digitalGlass => _createTriangleShape(),
      RageMaterialType.porcelainVase => _createIrregularShape(),
      RageMaterialType.crtMonitor => _createBoxShape(),
      RageMaterialType.bubbleWrap => CircleShape()..radius = size * 0.6,
    };

    final fixtureDef = FixtureDef(shape)
      ..restitution = restitution
      ..friction = friction
      ..density = 0.5;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  PolygonShape _createTriangleShape() {
    final s = size;
    return PolygonShape()
      ..set([
        Vector2(0, s),
        Vector2(-s * 0.6, -s * 0.5),
        Vector2(s * 0.6, -s * 0.5),
      ]);
  }

  PolygonShape _createIrregularShape() {
    final s = size * 0.8;
    return PolygonShape()
      ..set([
        Vector2(0, s),
        Vector2(-s * 0.7, s * 0.3),
        Vector2(-s * 0.5, -s * 0.8),
        Vector2(s * 0.5, -s * 0.8),
        Vector2(s * 0.7, s * 0.3),
      ]);
  }

  PolygonShape _createBoxShape() {
    return PolygonShape()..setAsBoxXY(size * 0.7, size * 0.4);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;

    // Belirli süre sonra shard'ı kaldır (bellek temizliği)
    if (_age >= _maxAge) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    // Yaş ilerledikçe opacity azalır — son 2 saniyede solar
    final opacity =
        _age > (_maxAge - 2.0) ? ((_maxAge - _age) / 2.0).clamp(0.0, 1.0) : 1.0;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity * color.a)
      ..style = PaintingStyle.fill;

    // Fixture vertices'i kullanarak çiz
    for (final fixture in body.fixtures) {
      if (fixture.shape is PolygonShape) {
        final poly = fixture.shape as PolygonShape;
        final path = Path();
        final verts = poly.vertices;

        if (verts.isEmpty) continue;
        path.moveTo(verts[0].x, verts[0].y);
        for (var i = 1; i < verts.length; i++) {
          path.lineTo(verts[i].x, verts[i].y);
        }
        path.close();
        canvas.drawPath(path, paint);
      } else if (fixture.shape is CircleShape) {
        final circle = fixture.shape as CircleShape;
        canvas.drawCircle(
          Offset(circle.position.x, circle.position.y),
          circle.radius,
          paint,
        );
      }
    }
  }
}
