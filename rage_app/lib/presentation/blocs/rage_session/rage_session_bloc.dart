// lib/presentation/blocs/rage_session/rage_session_bloc.dart
// Çekirdek iş mantığı: 3 dakikalık seans yönetimi, fizik entegrasyonu,
// Firestore kaydetme ve rozet sistemi.

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/domain/usecases/save_session_usecase.dart';
import 'package:rage_app/domain/usecases/start_rage_session_usecase.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_event.dart';
import 'package:rage_app/presentation/blocs/rage_session/rage_session_state.dart';

class RageSessionBloc extends Bloc<RageSessionEvent, RageSessionState> {
  RageSessionBloc({
    required StartRageSessionUseCase startSession,
    required SaveSessionUseCase saveSession,
  })  : _startSession = startSession,
        _saveSession = saveSession,
        super(const RageSessionState()) {
    on<RageSessionStarted>(_onStarted);
    on<RageSessionObjectBroken>(_onObjectBroken);
    on<RageSessionTimerTicked>(_onTimerTicked);
    on<RageSessionEnded>(_onEnded);
    on<RageSessionReset>(_onReset);
  }

  final StartRageSessionUseCase _startSession;
  final SaveSessionUseCase _saveSession;
  Timer? _timer;

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onStarted(
    RageSessionStarted event,
    Emitter<RageSessionState> emit,
  ) async {
    emit(
      state.copyWith(
        phase: SessionPhase.raging,
        remainingSeconds: AppConstants.sessionDurationSeconds,
      ),
    );

    // Firestore'da yeni seans oluştur
    final result = await _startSession(
      userId: event.userId,
      materialType: event.materialType,
      backgroundTemplateId: event.backgroundTemplateId,
      customImagePath: event.customImagePath,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          phase: SessionPhase.error,
          errorMessage: failure.message,
        ),
      ),
      (session) => emit(state.copyWith(currentSession: session)),
    );

    // 3 dakika geri sayım zamanlayıcısını başlat
    _startCountdown();
  }

  void _onObjectBroken(
    RageSessionObjectBroken event,
    Emitter<RageSessionState> emit,
  ) {
    if (!state.isActive) return;

    emit(
      state.copyWith(
        totalBreaks: state.totalBreaks + 1,
        totalShards: state.totalShards + event.shardCount,
      ),
    );
  }

  void _onTimerTicked(
    RageSessionTimerTicked event,
    Emitter<RageSessionState> emit,
  ) {
    if (event.remainingSeconds <= 0) {
      add(const RageSessionEnded());
      return;
    }

    final phase = event.remainingSeconds <= 10
        ? SessionPhase.ending
        : SessionPhase.raging;

    emit(
      state.copyWith(remainingSeconds: event.remainingSeconds, phase: phase),
    );
  }

  Future<void> _onEnded(
    RageSessionEnded event,
    Emitter<RageSessionState> emit,
  ) async {
    _timer?.cancel();

    if (state.currentSession == null) {
      emit(state.copyWith(phase: SessionPhase.zen));
      return;
    }

    emit(state.copyWith(phase: SessionPhase.saving));

    final result = await _saveSession(
      sessionId: state.currentSession!.id,
      totalBreaks: state.totalBreaks,
      totalShards: state.totalShards,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(phase: SessionPhase.zen, errorMessage: failure.message),
      ),
      (session) => emit(
        state.copyWith(phase: SessionPhase.zen, currentSession: session),
      ),
    );
  }

  void _onReset(RageSessionReset event, Emitter<RageSessionState> emit) {
    _timer?.cancel();
    emit(const RageSessionState());
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _startCountdown() {
    _timer?.cancel();
    var remaining = state.remainingSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      remaining--;
      add(RageSessionTimerTicked(remaining));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
