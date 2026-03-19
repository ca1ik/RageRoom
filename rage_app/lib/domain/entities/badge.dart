// lib/domain/entities/badge.dart
// "Zero Bug Tolerance" gamification rozetleri domain entity.

import 'package:equatable/equatable.dart';

/// Kullanıcının kazandığı rozeti temsil eder.
class Badge extends Equatable {
  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.requiredBreaks,
    this.earnedAt,
  });

  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final int
  requiredBreaks; // Bu rozeti kazanmak için gereken minimum kırım sayısı
  final DateTime? earnedAt;

  bool get isEarned => earnedAt != null;

  @override
  List<Object?> get props => [id, title, earnedAt];

  /// Tüm olası rozetlerin statik listesi.
  static List<Badge> get allBadges => [
    const Badge(
      id: 'first_rage',
      title: 'İlk Deşarj',
      description: 'İlk rage seansını tamamladın. Burası bir başlangıç.',
      iconEmoji: '💥',
      requiredBreaks: 1,
    ),
    const Badge(
      id: 'syntax_error_slayer',
      title: 'Syntax Error Slayer',
      description: '50 nesneyi kırdın. Compiler sana hak verecek.',
      iconEmoji: '⚔️',
      requiredBreaks: 50,
    ),
    const Badge(
      id: 'deadline_survivor',
      title: 'Deadline Survivor',
      description: '3 tam seansı zamanlayıcı bitene dek sürdürdün.',
      iconEmoji: '🏆',
      requiredBreaks: 100,
    ),
    const Badge(
      id: 'tubitak_warrior',
      title: 'TÜBİTAK Warrior',
      description: 'Şiddetli baskı altında 200 kırım. Savaşçısın.',
      iconEmoji: '🧪',
      requiredBreaks: 200,
    ),
    const Badge(
      id: 'century_destroyer',
      title: 'Century Destroyer',
      description: '500 kırım. Klavyeye değil, uygulamaya vuruyorsun. İyi.',
      iconEmoji: '💣',
      requiredBreaks: 500,
    ),
    const Badge(
      id: 'zen_master',
      title: 'Zen Master',
      description: 'Rage seansından sonra meditasyon modunda 60 saniye kaldın.',
      iconEmoji: '🧘',
      requiredBreaks: 0,
    ),
    const Badge(
      id: 'pro_unlocked',
      title: 'PRO Yükselişi',
      description: 'PRO üyeliğini etkinleştirdin. Tam güç serbest.',
      iconEmoji: '👑',
      requiredBreaks: 0,
    ),
  ];
}
