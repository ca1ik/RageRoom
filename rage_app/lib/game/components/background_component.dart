// lib/game/components/background_component.dart
// Oyun arkaplanı — varsayılan degradeden PRO özel görsele geçiş.

import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BackgroundComponent extends PositionComponent {
  BackgroundComponent({this.customImagePath});

  final String? customImagePath;
  ui.Image? _customImage;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    priority = -10; // Daima en arkada render edilir
  }

  @override
  void render(Canvas canvas) {
    // Fizik dünyasının görünür alanını kapsayan büyük rect
    const size = Rect.fromLTRB(-60, -110, 60, 110);

    if (_customImage != null) {
      // PRO: Kullanıcının kendi görseli
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(
          size.left,
          size.top,
          size.width,
          size.height,
        ),
        image: _customImage!,
        fit: BoxFit.cover,
        colorFilter: const ColorFilter.mode(
          Color(0x88000000),
          BlendMode.darken,
        ),
      );
    } else {
      // Varsayılan: karanlık agresif gradyan
      const gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A0A1A),
          Color(0xFF1A0A2E),
          Color(0xFF0D0D0D),
        ],
        stops: [0.0, 0.5, 1.0],
      );

      final rect = Rect.fromLTWH(
        size.left,
        size.top,
        size.width,
        size.height,
      );

      final paint = Paint()..shader = gradient.createShader(rect);

      canvas.drawRect(rect, paint);

      // Grid pattern — "dijital alan" efekti
      _drawDigitalGrid(canvas, rect);
    }
  }

  void _drawDigitalGrid(Canvas canvas, Rect bounds) {
    final gridPaint = Paint()
      ..color = const Color(0x0F4CAF50) // Çok hafif yeşil
      ..strokeWidth = 0.04
      ..style = PaintingStyle.stroke;

    const gridSize = 3.0; // Fizik birimleri

    var x = bounds.left;
    while (x <= bounds.right) {
      canvas.drawLine(
          Offset(x, bounds.top), Offset(x, bounds.bottom), gridPaint);
      x += gridSize;
    }

    var y = bounds.top;
    while (y <= bounds.bottom) {
      canvas.drawLine(
          Offset(bounds.left, y), Offset(bounds.right, y), gridPaint);
      y += gridSize;
    }
  }
}
