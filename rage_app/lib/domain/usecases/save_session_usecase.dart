// lib/domain/usecases/save_session_usecase.dart
// Use-case: Rage seansı bitiminde kaydetme ve rozet hesaplama iş mantığı.

import 'package:dartz/dartz.dart';
import 'package:rage_app/domain/entities/badge.dart';
import 'package:rage_app/domain/entities/rage_session.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart';

class SaveSessionUseCase {
  const SaveSessionUseCase(this._repository);

  final RageSessionRepositoryInterface _repository;

  Future<Either<Failure, RageSession>> call({
    required String sessionId,
    required int totalBreaks,
    required int totalShards,
  }) async {
    // Toplam kırım sayısına göre kazanılan rozetleri hesapla
    final earnedBadgeIds = _calculateEarnedBadges(totalBreaks);

    return _repository.finalizeSession(
      sessionId,
      endedAt: DateTime.now(),
      earnedBadgeIds: earnedBadgeIds,
    );
  }

  List<String> _calculateEarnedBadges(int totalBreaks) {
    return Badge.allBadges
        .where((b) => b.requiredBreaks > 0 && totalBreaks >= b.requiredBreaks)
        .map((b) => b.id)
        .toList();
  }
}
