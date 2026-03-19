// lib/presentation/blocs/rage_session/rage_session_event.dart
// RageSessionBloc için tip-güvenli event tanımları.

import 'package:equatable/equatable.dart';
import 'package:rage_app/core/constants/app_constants.dart';

abstract class RageSessionEvent extends Equatable {
  const RageSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Yeni seans başlatılır.
class RageSessionStarted extends RageSessionEvent {
  const RageSessionStarted({
    required this.userId,
    required this.materialType, // RageMaterialType
    this.backgroundTemplateId,
    this.customImagePath,
  });

  final String userId;
  final RageMaterialType materialType;
  final String? backgroundTemplateId;
  final String? customImagePath;

  @override
  List<Object?> get props => [
        userId,
        materialType,
        backgroundTemplateId,
        customImagePath,
      ];
}

/// Nesne kırıldığında tetiklenir — break ve shard sayısını artırır.
class RageSessionObjectBroken extends RageSessionEvent {
  const RageSessionObjectBroken({
    required this.shardCount,
    required this.materialType,
  });

  final int shardCount;
  final RageMaterialType materialType;

  @override
  List<Object?> get props => [shardCount, materialType];
}

/// 3 dakika dolduğunda veya kullanıcı manuel sonlandırdığında tetiklenir.
class RageSessionEnded extends RageSessionEvent {
  const RageSessionEnded();
}

/// Zamanlayıcı tik eventi — her saniyede tetiklenir.
class RageSessionTimerTicked extends RageSessionEvent {
  const RageSessionTimerTicked(this.remainingSeconds);

  final int remainingSeconds;

  @override
  List<Object?> get props => [remainingSeconds];
}

/// Seans sıfırlanır (tekrar oynamak için).
class RageSessionReset extends RageSessionEvent {
  const RageSessionReset();
}
