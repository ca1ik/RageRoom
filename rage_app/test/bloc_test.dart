// test/bloc_test.dart
// RageSessionBloc birim testleri.

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/domain/entities/rage_session.dart';
import 'package:rage_app/domain/repositories/rage_session_repository_interface.dart';
import 'package:rage_app/domain/usecases/save_session_usecase.dart';
import 'package:rage_app/domain/usecases/start_rage_session_usecase.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_bloc.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_event.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_state.dart';

// Mock sınıflar
class MockRageSessionRepository extends Mock
    implements RageSessionRepositoryInterface {}

class MockStartRageSessionUseCase extends Mock
    implements StartRageSessionUseCase {}

class MockSaveSessionUseCase extends Mock implements SaveSessionUseCase {}

void main() {
  late MockRageSessionRepository mockRepo;
  late StartRageSessionUseCase startSession;
  late SaveSessionUseCase saveSession;

  setUp(() {
    mockRepo = MockRageSessionRepository();
    startSession = StartRageSessionUseCase(mockRepo);
    saveSession = SaveSessionUseCase(mockRepo);

    // Varsayılan mock davranışları
    when(
      () => mockRepo.createSession(any()),
    ).thenAnswer((_) async {
      final session = RageSession(
        id: 'test_session_1',
        userId: 'anonymous',
        startedAt: DateTime.now(),
        materialType: RageMaterialType.digitalGlass,
      );
      return Right(session);
    });

    when(
      () => mockRepo.finalizeSession(
        any(),
        endedAt: any(named: 'endedAt'),
        earnedBadgeIds: any(named: 'earnedBadgeIds'),
      ),
    ).thenAnswer((_) async {
      final session = RageSession(
        id: 'test_session_1',
        userId: 'anonymous',
        startedAt: DateTime.now(),
        materialType: RageMaterialType.digitalGlass,
      );
      return Right(session);
    });

    when(
      () => mockRepo.getTotalBreaks(any()),
    ).thenAnswer((_) async => const Right(0));
  });

  group('RageSessionBloc', () {
    blocTest<RageSessionBloc, RageSessionState>(
      'başlangıçta idle state olmalı',
      build: () => RageSessionBloc(
        startSession: startSession,
        saveSession: saveSession,
      ),
      verify: (bloc) {
        expect(bloc.state.phase, SessionPhase.idle);
        expect(bloc.state.totalBreaks, 0);
      },
    );

    blocTest<RageSessionBloc, RageSessionState>(
      'RageSessionStarted → phase raging olmalı',
      build: () => RageSessionBloc(
        startSession: startSession,
        saveSession: saveSession,
      ),
      act: (bloc) => bloc.add(
        const RageSessionStarted(
          userId: 'anonymous',
          materialType: RageMaterialType.digitalGlass,
        ),
      ),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<RageSessionState>()
            .having((s) => s.phase, 'phase', SessionPhase.raging),
      ],
    );

    blocTest<RageSessionBloc, RageSessionState>(
      'RageSessionObjectBroken → totalBreaks artmalı',
      build: () => RageSessionBloc(
        startSession: startSession,
        saveSession: saveSession,
      ),
      seed: () => const RageSessionState(
        phase: SessionPhase.raging,
      ),
      act: (bloc) {
        bloc.add(
          const RageSessionObjectBroken(
            shardCount: 12,
            materialType: RageMaterialType.digitalGlass,
          ),
        );
        bloc.add(
          const RageSessionObjectBroken(
            shardCount: 8,
            materialType: RageMaterialType.bubbleWrap,
          ),
        );
      },
      expect: () => [
        isA<RageSessionState>()
            .having((s) => s.totalBreaks, 'totalBreaks', 1)
            .having((s) => s.totalShards, 'totalShards', 12),
        isA<RageSessionState>()
            .having((s) => s.totalBreaks, 'totalBreaks', 2)
            .having((s) => s.totalShards, 'totalShards', 20),
      ],
    );

    blocTest<RageSessionBloc, RageSessionState>(
      'RageSessionReset → tüm sayaçlar sıfırlanmalı',
      build: () => RageSessionBloc(
        startSession: startSession,
        saveSession: saveSession,
      ),
      seed: () => const RageSessionState(
        phase: SessionPhase.zen,
        remainingSeconds: 0,
        totalBreaks: 50,
        totalShards: 600,
      ),
      act: (bloc) => bloc.add(const RageSessionReset()),
      expect: () => [
        isA<RageSessionState>()
            .having((s) => s.phase, 'phase', SessionPhase.idle)
            .having((s) => s.totalBreaks, 'totalBreaks', 0)
            .having((s) => s.remainingSeconds, 'remainingSeconds',
                AppConstants.sessionDurationSeconds),
      ],
    );
  });
}
