// lib/game/components/world_boundaries.dart
// Fizik dünyasının statik sınırları: zemin, sol ve sağ duvar.

import 'package:flame_forge2d/flame_forge2d.dart';

class WorldBoundaries extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef()..type = BodyType.static;
    final body = world.createBody(bodyDef);

    final size = game.camera.visibleWorldRect;
    final halfW = (size.width / 2) + 5;
    final groundY = -(size.height / 2) - 2; // Ekranın altı (y negatif taba)
    final ceilY = (size.height / 2) + 5; // Tavan

    final ground = EdgeShape()
      ..set(Vector2(-halfW, groundY), Vector2(halfW, groundY));
    final leftWall = EdgeShape()
      ..set(Vector2(-halfW, groundY), Vector2(-halfW, ceilY));
    final rightWall = EdgeShape()
      ..set(Vector2(halfW, groundY), Vector2(halfW, ceilY));

    final groundFixture = FixtureDef(ground)
      ..restitution = 0.2
      ..friction = 0.5;
    final wallFixture = FixtureDef(leftWall)
      ..restitution = 0.3
      ..friction = 0.1;
    final rightWallFixture = FixtureDef(rightWall)
      ..restitution = 0.3
      ..friction = 0.1;

    body
      ..createFixture(groundFixture)
      ..createFixture(wallFixture)
      ..createFixture(rightWallFixture);

    return body;
  }
}
