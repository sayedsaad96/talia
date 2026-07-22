import 'package:equatable/equatable.dart';
import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';

enum ProgressStatus { initial, loading, loaded, error }

class ProgressState extends Equatable {
  final ProgressStatus status;
  final ProgressEntity? progress;
  final List<BadgeEntity> badges;
  final Map<DateTime, int> dailyActivity;
  final String? errorMessage;

  const ProgressState({
    this.status = ProgressStatus.initial,
    this.progress,
    this.badges = const [],
    this.dailyActivity = const {},
    this.errorMessage,
  });

  ProgressState copyWith({
    ProgressStatus? status,
    ProgressEntity? progress,
    List<BadgeEntity>? badges,
    Map<DateTime, int>? dailyActivity,
    String? errorMessage,
  }) {
    return ProgressState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      badges: badges ?? this.badges,
      dailyActivity: dailyActivity ?? this.dailyActivity,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, progress, badges, dailyActivity, errorMessage];
}
