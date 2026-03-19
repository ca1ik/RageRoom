// lib/domain/usecases/start_rage_session_usecase.dart
// Use-case: Rage seansı başlatma iş mantığı.

import 'package:dartz/dartz.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/domain/entities/rage_session.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart';
import 'package:uuid/uuid.dart';

class StartRageSessionUseCase {
  const StartRageSessionUseCase(this._repository);

  final RageSessionRepositoryInterface _repository;

  Future<Either<Failure, RageSession>> call({
    required String userId,
    required RageMaterialType materialType,
    String? backgroundTemplateId,
    String? customImagePath,
  }) async {
    final session = RageSession(
      id: const Uuid().v4(),
      userId: userId,
      startedAt: DateTime.now(),
      materialType: materialType,
      backgroundTemplateId: backgroundTemplateId,
      customImagePath: customImagePath,
    );

    return _repository.createSession(session);
  }
}
