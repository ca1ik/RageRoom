// lib/presentation/blocs/rage_session/rage_session_state.dart
// RageSessionBloc durum tanımları — Equatable ile eşitlik kontrolü.

import 'package:equatable/equatable.dart';
import 'package:rage_app/core/constants/app_constants.dart';
import 'package:rage_app/domain/entities/rage_session.dart';

/// Mevcut seansın fazını belirtir.
enum SessionPhase {
  idle, // Seans başlamadı
  raging, // 3 dakika boyunca tam güç yıkım
  ending, // Süre bitiyor (son 10 saniye)
  zen, // Seans bitti, meditasyon modu
  saving, // Firestore'a kaydediliyor
  error, // Hata durumu
}

class RageSessionState extends Equatable {
  const RageSessionState({
    this.phase = SessionPhase.idle,
    this.currentSession,
    this.remainingSeconds = AppConstants.sessionDurationSeconds,
    this.totalBreaks = 0,
    this.totalShards = 0,
    this.errorMessage,
  });

  final SessionPhase phase;
  final RageSession? currentSession;
  final int remainingSeconds;
  final int totalBreaks;
  final int totalShards;
  final String? errorMessage;

  bool get isActive =>
      phase == SessionPhase.raging || phase == SessionPhase.ending;
  bool get isZen => phase == SessionPhase.zen;
  bool get isEnding => phase == SessionPhase.ending;

  /// Son 10 saniyede true — ending animasyonunu tetikler.
  bool get isCriticalTime => remainingSeconds <= 10 && remainingSeconds > 0;

  RageSessionState copyWith({
    SessionPhase? phase,
    RageSession? currentSession,
    int? remainingSeconds,
    int? totalBreaks,
    int? totalShards,
    String? errorMessage,
  }) {
    return RageSessionState(
      phase: phase ?? this.phase,
      currentSession: currentSession ?? this.currentSession,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalBreaks: totalBreaks ?? this.totalBreaks,
      totalShards: totalShards ?? this.totalShards,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    currentSession,
    remainingSeconds,
    totalBreaks,
    totalShards,
    errorMessage,
  ];
}
