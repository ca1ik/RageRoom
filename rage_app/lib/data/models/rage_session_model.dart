// lib/data/models/rage_session_model.dart
// Firebase Firestore ↔ Domain entity dönüşümü için veri modeli.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/domain/entities/rage_session.dart';

class RageSessionModel {
  const RageSessionModel({
    required this.id,
    required this.userId,
    required this.startedAt,
    required this.materialTypeIndex,
    this.endedAt,
    this.totalBreaks = 0,
    this.totalShards = 0,
    this.earnedBadgeIds = const [],
    this.backgroundTemplateId,
    this.customImagePath,
  });

  factory RageSessionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return RageSessionModel(
      id: doc.id,
      userId: data['userId'] as String,
      startedAt: data['startedAt'] as Timestamp,
      endedAt: data['endedAt'] as Timestamp?,
      materialTypeIndex: data['materialTypeIndex'] as int? ?? 0,
      totalBreaks: data['totalBreaks'] as int? ?? 0,
      totalShards: data['totalShards'] as int? ?? 0,
      earnedBadgeIds: (data['earnedBadgeIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      backgroundTemplateId: data['backgroundTemplateId'] as String?,
      customImagePath: data['customImagePath'] as String?,
    );
  }

  factory RageSessionModel.fromDomain(RageSession session) {
    return RageSessionModel(
      id: session.id,
      userId: session.userId,
      startedAt: Timestamp.fromDate(session.startedAt),
      endedAt:
          session.endedAt != null ? Timestamp.fromDate(session.endedAt!) : null,
      materialTypeIndex: session.materialType.index,
      totalBreaks: session.totalBreaks,
      totalShards: session.totalShards,
      earnedBadgeIds: session.earnedBadgeIds,
      backgroundTemplateId: session.backgroundTemplateId,
      customImagePath: session.customImagePath,
    );
  }

  final String id;
  final String userId;
  final Timestamp startedAt;
  final Timestamp? endedAt;
  final int materialTypeIndex;
  final int totalBreaks;
  final int totalShards;
  final List<String> earnedBadgeIds;
  final String? backgroundTemplateId;
  final String? customImagePath;

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'startedAt': startedAt,
      if (endedAt != null) 'endedAt': endedAt,
      'materialTypeIndex': materialTypeIndex,
      'totalBreaks': totalBreaks,
      'totalShards': totalShards,
      'earnedBadgeIds': earnedBadgeIds,
      if (backgroundTemplateId != null)
        'backgroundTemplateId': backgroundTemplateId,
      if (customImagePath != null) 'customImagePath': customImagePath,
    };
  }

  RageSession toDomain() {
    return RageSession(
      id: id,
      userId: userId,
      startedAt: startedAt.toDate(),
      endedAt: endedAt?.toDate(),
      materialType: RageMaterialType.values[materialTypeIndex],
      totalBreaks: totalBreaks,
      totalShards: totalShards,
      earnedBadgeIds: earnedBadgeIds,
      backgroundTemplateId: backgroundTemplateId,
      customImagePath: customImagePath,
    );
  }
}
