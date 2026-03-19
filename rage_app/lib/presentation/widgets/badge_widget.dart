// lib/presentation/widgets/badge_widget.dart
// Rozet kartı — kilitli/açık durumlarıyla.

import 'package:flutter/material.dart';
import 'package:rage_app/app/theme/app_theme.dart';
import 'package:rage_app/core/l10n/app_strings.dart';
import 'package:rage_app/domain/entities/badge.dart' as domain;

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    required this.badge,
    this.isUnlocked = false,
    super.key,
  });

  final domain.Badge badge;
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppTheme.electricBlue.withValues(alpha: 0.5)
              : Colors.white10,
        ),
        gradient: isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.electricBlue.withValues(alpha: 0.08),
                  AppTheme.darkCard,
                ],
              )
            : null,
      ),
      child: Stack(
        children: [
          // Kilitli kaplaması
          if (!isUnlocked)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.lock_outline,
                size: 14,
                color: Colors.white24,
              ),
            ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rozet emojisi
                Text(
                  badge.iconEmoji,
                  style: TextStyle(
                    fontSize: 32,
                    color: isUnlocked ? null : const Color(0x40FFFFFF),
                  ),
                ),
                const SizedBox(height: 8),
                // Rozet adı
                Text(
                  badge.title,
                  style: TextStyle(
                    color: isUnlocked ? Colors.white : Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Gereksinim
                Text(
                  AppStrings.breaksRequired(badge.requiredBreaks),
                  style: const TextStyle(
                    color: Color(0x50FFFFFF),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
