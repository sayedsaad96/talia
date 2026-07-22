import 'package:equatable/equatable.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';

enum ReviewStatus { initial, loading, active, completing, completed, error }

class ReviewState extends Equatable {
  final ReviewStatus status;
  final List<ReviewScheduleEntity> dueReviews;
  final int currentIndex;
  final String? errorMessage;

  const ReviewState({
    this.status = ReviewStatus.initial,
    this.dueReviews = const [],
    this.currentIndex = 0,
    this.errorMessage,
  });

  ReviewScheduleEntity? get currentReview {
    if (dueReviews.isEmpty || currentIndex >= dueReviews.length) return null;
    return dueReviews[currentIndex];
  }

  bool get isLastReview => currentIndex == dueReviews.length - 1;

  ReviewState copyWith({
    ReviewStatus? status,
    List<ReviewScheduleEntity>? dueReviews,
    int? currentIndex,
    String? errorMessage,
  }) {
    return ReviewState(
      status: status ?? this.status,
      dueReviews: dueReviews ?? this.dueReviews,
      currentIndex: currentIndex ?? this.currentIndex,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dueReviews, currentIndex, errorMessage];
}
