import 'package:equatable/equatable.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

enum KidsHomeStatus { initial, loading, loaded, error }

class JuzProgress extends Equatable {
  final int juzNumber;
  final int ayahsMemorized;
  final int totalAyahs;
  final bool isUnlocked;

  const JuzProgress({
    required this.juzNumber,
    required this.ayahsMemorized,
    required this.totalAyahs,
    required this.isUnlocked,
  });

  double get completionPercentage => totalAyahs == 0 ? 0 : ayahsMemorized / totalAyahs;

  @override
  List<Object?> get props => [juzNumber, ayahsMemorized, totalAyahs, isUnlocked];
}

class KidsHomeState extends Equatable {
  final KidsHomeStatus status;
  final ProgressEntity progress;
  final List<dynamic> recommendations;
  final SessionEntity? activeSession;
  final List<JuzProgress> juzProgress;
  final String? errorMessage;

  const KidsHomeState({
    this.status = KidsHomeStatus.initial,
    this.progress = const ProgressEntity(),
    this.recommendations = const [],
    this.activeSession,
    this.juzProgress = const [],
    this.errorMessage,
  });

  KidsHomeState copyWith({
    KidsHomeStatus? status,
    ProgressEntity? progress,
    List<dynamic>? recommendations,
    SessionEntity? activeSession,
    List<JuzProgress>? juzProgress,
    String? errorMessage,
  }) {
    return KidsHomeState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      recommendations: recommendations ?? this.recommendations,
      activeSession: activeSession ?? this.activeSession,
      juzProgress: juzProgress ?? this.juzProgress,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, progress, recommendations, activeSession, juzProgress, errorMessage];
}
