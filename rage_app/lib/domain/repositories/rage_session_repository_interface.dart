// lib/domain/repositories/rage_session_repository_interface.dart
// Domain katmanının repository sözleşmesi — Data katmanını izole eder.

import 'package:dartz/dartz.dart';
import 'package:rage_app/domain/entities/rage_session.dart';

/// Repository işlemleri ya [Failure] ya da [T] döndürür (Either monad).
class Failure {
  const Failure(this.message);
  final String message;
}

abstract interface class RageSessionRepositoryInterface {
  /// Yeni bir seans oluşturur ve kaydeder.
  Future<Either<Failure, RageSession>> createSession(RageSession session);

  /// Var olan seansı günceller (kırım sayısı vb.).
  Future<Either<Failure, RageSession>> updateSession(RageSession session);

  /// Seansı tamamlanmış olarak işaretler.
  Future<Either<Failure, RageSession>> finalizeSession(
    String sessionId, {
    required DateTime endedAt,
    required List<String> earnedBadgeIds,
  });

  /// Kullanıcının geçmiş seanslarını getirir.
  Future<Either<Failure, List<RageSession>>> getUserSessions(String userId);

  /// Kullanıcının toplam kırım istatistiklerini getirir.
  Future<Either<Failure, int>> getTotalBreaks(String userId);
}
