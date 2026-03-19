// lib/domain/entities/rage_session.dart
// Saf domain entity — framework bağımlılığı yok.

import 'package:equatable/equatable.dart';
import 'package:rage_app/core/constants/app_constants.dart';

/// Tek bir kırım seansını temsil eden domain nesnesi.
class RageSession extends Equatable {
  const RageSession({
    required this.id,
    required this.userId,
    required this.startedAt,
    required this.materialType, // RageMaterialType
    this.endedAt,
    this.totalBreaks = 0,
    this.totalShards = 0,
    this.earnedBadgeIds = const [],
    this.backgroundTemplateId,
    this.customImagePath,
  });

  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final RageMaterialType materialType;
  final int totalBreaks;
  final int totalShards;
  final List<String> earnedBadgeIds;
  final String? backgroundTemplateId;
  final String? customImagePath; // PRO: kullanıcının özel görseli

  Duration get duration => (endedAt ?? DateTime.now()).difference(startedAt);

  bool get isCompleted => endedAt != null;

  /// Seans puan hesaplama — gamification için.
  int get score => (totalBreaks * 10) + (totalShards * 2);

  RageSession copyWith({
    DateTime? endedAt,
    int? totalBreaks,
    int? totalShards,
    List<String>? earnedBadgeIds,
  }) {
    return RageSession(
      id: id,
      userId: userId,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      materialType: materialType, // RageMaterialType
      totalBreaks: totalBreaks ?? this.totalBreaks,
      totalShards: totalShards ?? this.totalShards,
      earnedBadgeIds: earnedBadgeIds ?? this.earnedBadgeIds,
      backgroundTemplateId: backgroundTemplateId,
      customImagePath: customImagePath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        startedAt,
        endedAt,
        materialType,
        totalBreaks,
        totalShards,
        earnedBadgeIds,
        backgroundTemplateId,
        customImagePath,
      ];
}
