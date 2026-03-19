// lib/data/repositories/local_rage_session_repository.dart
// Firebase kapaliyken seanslari bellek icinde tutan gecici repository.

import 'package:dartz/dartz.dart';
import 'package:rage_app/domain/entities/rage_session.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart';

class LocalRageSessionRepository implements RageSessionRepositoryInterface {
  final Map<String, RageSession> _sessionsById = <String, RageSession>{};
  final Map<String, int> _totalBreaksByUser = <String, int>{};

  @override
  Future<Either<Failure, RageSession>> createSession(
      RageSession session) async {
    _sessionsById[session.id] = session;
    return Right(session);
  }

  @override
  Future<Either<Failure, RageSession>> updateSession(
      RageSession session) async {
    _sessionsById[session.id] = session;
    return Right(session);
  }

  @override
  Future<Either<Failure, RageSession>> finalizeSession(
    String sessionId, {
    required DateTime endedAt,
    required List<String> earnedBadgeIds,
  }) async {
    final existing = _sessionsById[sessionId];
    if (existing == null) {
      return const Left(Failure('Session not found'));
    }

    final finalized = existing.copyWith(
      endedAt: endedAt,
      earnedBadgeIds: earnedBadgeIds,
    );

    _sessionsById[sessionId] = finalized;
    _totalBreaksByUser[finalized.userId] =
        (_totalBreaksByUser[finalized.userId] ?? 0) + finalized.totalBreaks;

    return Right(finalized);
  }

  @override
  Future<Either<Failure, List<RageSession>>> getUserSessions(
      String userId) async {
    final sessions = _sessionsById.values
        .where((session) => session.userId == userId)
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    return Right(sessions);
  }

  @override
  Future<Either<Failure, int>> getTotalBreaks(String userId) async {
    return Right(_totalBreaksByUser[userId] ?? 0);
  }
}
