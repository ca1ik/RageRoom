// lib/presentation/screens/badges/badges_screen.dart
// "Zero Bug Tolerance" rozet koleksiyonu ekranı.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/domain/entities/badge.dart' as domain;
import 'package:rage_app/presentation/widgets/badge_widget.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = domain.Badge.allBadges;

    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      appBar: AppBar(
        title: Text(AppStrings.badgesTitle),
        backgroundColor: AppTheme.darkSurface,
        foregroundColor: AppTheme.electricBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Zero Bug Tolerance',
              style: TextStyle(
                color: Color(0x60FFFFFF),
                fontSize: 12,
                letterSpacing: 3,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  return BadgeWidget(badge: badges[index])
                      .animate(delay: Duration(milliseconds: index * 60))
                      .fadeIn()
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
