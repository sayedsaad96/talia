import 'package:equatable/equatable.dart';
import 'package:talia/features/memorization_engine/domain/entities/coach_recommendation_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CoachRecommendationEntity> recommendations;
  final ProgressEntity progress;
  final SessionEntity? activeSession;
  final int dueReviewsCount;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.recommendations = const [],
    this.progress = const ProgressEntity(),
    this.activeSession,
    this.dueReviewsCount = 0,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CoachRecommendationEntity>? recommendations,
    ProgressEntity? progress,
    SessionEntity? activeSession,
    int? dueReviewsCount,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      recommendations: recommendations ?? this.recommendations,
      progress: progress ?? this.progress,
      activeSession: activeSession ?? this.activeSession,
      dueReviewsCount: dueReviewsCount ?? this.dueReviewsCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        recommendations,
        progress,
        activeSession,
        dueReviewsCount,
        errorMessage,
      ];
}
