// lib/presentation/widgets/timer_widget.dart
// Dairesel geri sayım zamanlayıcısı.
// Son 10 saniyede kırmızıya döner, 0'da tam ekran flaş yapar.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_bloc.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_state.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RageSessionBloc, RageSessionState>(
      buildWhen: (previous, current) =>
          previous.remainingSeconds != current.remainingSeconds,
      builder: (context, state) {
        final remaining = state.remainingSeconds;
        const total = AppConstants.sessionDurationSeconds;
        final progress = remaining / total;
        final isCritical = remaining <= 10 && remaining > 0;

        final color = isCritical
            ? Color.lerp(AppTheme.rageCrimson, Colors.orange, remaining / 10)!
            : AppTheme.electricBlue;

        return SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Arka plan halkası
              CustomPaint(
                size: const Size(56, 56),
                painter: _ArcPainter(
                  progress: progress,
                  color: color,
                  strokeWidth: 3,
                ),
              ),
              // Saniye metni
              Text(
                _formatTime(remaining),
                style: TextStyle(
                  color: isCritical ? AppTheme.rageCrimson : Colors.white,
                  fontSize: isCritical ? 13 : 11,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Arka plan halkası
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // İlerleme yayı
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
