// lib/data/repositories/rage_session_repository.dart
// Repository implementasyonu — Firestore'u domain katmanından gizler.

import 'package:dartz/dartz.dart';
import 'package:rage_app/data/models/rage_session_model.dart';
import 'package:rage_app/data/sources/firebase_source.dart';
import 'package:rage_app/domain/entities/rage_session.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart';

class RageSessionRepository implements RageSessionRepositoryInterface {
  const RageSessionRepository(this._source);

  final FirebaseSource _source;

  @override
  Future<Either<Failure, RageSession>> createSession(
    RageSession session,
  ) async {
    try {
      final model = RageSessionModel.fromDomain(session);
      await _source.createSession(model);
      return Right(session);
    } on Exception catch (e) {
      return Left(Failure('Seans oluşturulamadı: $e'));
    }
  }

  @override
  Future<Either<Failure, RageSession>> updateSession(
    RageSession session,
  ) async {
    try {
      final model = RageSessionModel.fromDomain(session);
      await _source.updateSession(model);
      return Right(session);
    } on Exception catch (e) {
      return Left(Failure('Seans güncellenemedi: $e'));
    }
  }

  @override
  Future<Either<Failure, RageSession>> finalizeSession(
    String sessionId, {
    required DateTime endedAt,
    required List<String> earnedBadgeIds,
  }) async {
    try {
      final userId = _source.currentUser?.uid;
      if (userId == null) {
        return const Left(Failure('Kullanıcı oturumu yok'));
      }
      final existing = await _source.getSession(userId, sessionId);
      if (existing == null) {
        return const Left(Failure('Seans bulunamadı'));
      }
      final updated = RageSessionModel(
        id: existing.id,
        userId: existing.userId,
        startedAt: existing.startedAt,
        endedAt:
            existing.endedAt, // fromDomain'de Timestamp.fromDate ile set edilir
        materialTypeIndex: existing.materialTypeIndex,
        totalBreaks: existing.totalBreaks,
        totalShards: existing.totalShards,
        earnedBadgeIds: earnedBadgeIds,
      );
      await _source.updateSession(updated);
      await _source.incrementTotalBreaks(userId, existing.totalBreaks);
      return Right(updated.toDomain());
    } on Exception catch (e) {
      return Left(Failure('Seans tamamlanamadı: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RageSession>>> getUserSessions(
    String userId,
  ) async {
    try {
      final models = await _source.getUserSessions(userId);
      return Right(models.map((m) => m.toDomain()).toList());
    } on Exception catch (e) {
      return Left(Failure('Seanslar alınamadı: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getTotalBreaks(String userId) async {
    try {
      final total = await _source.getTotalBreaks(userId);
      return Right(total);
    } on Exception catch (e) {
      return Left(Failure('Toplam kırım alınamadı: $e'));
    }
  }
}
