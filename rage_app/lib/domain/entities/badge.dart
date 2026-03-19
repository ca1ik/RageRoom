// lib/domain/entities/badge.dart
// "Zero Bug Tolerance" gamification rozetleri domain entity.

import 'package:equatable/equatable.dart';
import 'package:rage_app/core/l10n/app_strings.dart';

/// Kullanıcının kazandığı rozeti temsil eder.
class Badge extends Equatable {
  const Badge({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.iconEmoji,
    required this.requiredBreaks,
    this.earnedAt,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String iconEmoji;
  final int requiredBreaks;
  final DateTime? earnedAt;

  String get title => _resolveTitle(titleKey);
  String get description => _resolveDescription(descriptionKey);

  bool get isEarned => earnedAt != null;

  @override
  List<Object?> get props => [id, titleKey, earnedAt];

  static String _resolveTitle(String key) {
    return switch (key) {
      'first_rage' => AppStrings.badgeFirstRageTitle,
      'syntax_error_slayer' => AppStrings.badgeSyntaxSlayerTitle,
      'deadline_survivor' => AppStrings.badgeDeadlineTitle,
      'tubitak_warrior' => AppStrings.badgeTubitakTitle,
      'century_destroyer' => AppStrings.badgeCenturyTitle,
      'zen_master' => AppStrings.badgeZenTitle,
      'pro_unlocked' => AppStrings.badgeProTitle,
      _ => key,
    };
  }

  static String _resolveDescription(String key) {
    return switch (key) {
      'first_rage' => AppStrings.badgeFirstRageDesc,
      'syntax_error_slayer' => AppStrings.badgeSyntaxSlayerDesc,
      'deadline_survivor' => AppStrings.badgeDeadlineDesc,
      'tubitak_warrior' => AppStrings.badgeTubitakDesc,
      'century_destroyer' => AppStrings.badgeCenturyDesc,
      'zen_master' => AppStrings.badgeZenDesc,
      'pro_unlocked' => AppStrings.badgeProDesc,
      _ => key,
    };
  }

  /// Tüm olası rozetlerin statik listesi.
  static List<Badge> get allBadges => [
        const Badge(
          id: 'first_rage',
          titleKey: 'first_rage',
          descriptionKey: 'first_rage',
          iconEmoji: '💥',
          requiredBreaks: 1,
        ),
        const Badge(
          id: 'syntax_error_slayer',
          titleKey: 'syntax_error_slayer',
          descriptionKey: 'syntax_error_slayer',
          iconEmoji: '⚔️',
          requiredBreaks: 50,
        ),
        const Badge(
          id: 'deadline_survivor',
          titleKey: 'deadline_survivor',
          descriptionKey: 'deadline_survivor',
          iconEmoji: '🏆',
          requiredBreaks: 100,
        ),
        const Badge(
          id: 'tubitak_warrior',
          titleKey: 'tubitak_warrior',
          descriptionKey: 'tubitak_warrior',
          iconEmoji: '🧪',
          requiredBreaks: 200,
        ),
        const Badge(
          id: 'century_destroyer',
          titleKey: 'century_destroyer',
          descriptionKey: 'century_destroyer',
          iconEmoji: '💣',
          requiredBreaks: 500,
        ),
        const Badge(
          id: 'zen_master',
          titleKey: 'zen_master',
          descriptionKey: 'zen_master',
          iconEmoji: '🧘',
          requiredBreaks: 0,
        ),
        const Badge(
          id: 'pro_unlocked',
          titleKey: 'pro_unlocked',
          descriptionKey: 'pro_unlocked',
          iconEmoji: '👑',
          requiredBreaks: 0,
        ),
      ];
}
