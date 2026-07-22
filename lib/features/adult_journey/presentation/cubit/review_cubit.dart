import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_due_reviews_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/submit_review_use_case.dart';
import 'package:talia/features/adult_journey/presentation/cubit/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetDueReviewsUseCase _getDueReviews;
  final SubmitReviewUseCase _submitReview;
  final AuthCubit _authCubit;

  ReviewCubit({
    required this._getDueReviews,
    required this._submitReview,
    required this._authCubit,
  }) : super(const ReviewState());

  String get _userId {
    final authState = _authCubit.state;
    return authState is Authenticated ? authState.user.id : 'guest';
  }

  Future<void> loadDueReviews() async {
    emit(state.copyWith(status: ReviewStatus.loading));
    final result = await _getDueReviews(_userId);
    result.fold(
      (l) => emit(
        state.copyWith(status: ReviewStatus.error, errorMessage: l.message),
      ),
      (reviews) {
        if (reviews.isEmpty) {
          emit(state.copyWith(status: ReviewStatus.completed, dueReviews: []));
        } else {
          emit(
            state.copyWith(
              status: ReviewStatus.active,
              dueReviews: reviews,
              currentIndex: 0,
            ),
          );
        }
      },
    );
  }

  Future<void> submitReview(
    ReviewQuality quality,
    double similarityScore,
  ) async {
    final schedule = state.currentReview;
    if (schedule == null) return;

    emit(state.copyWith(status: ReviewStatus.loading));
    final result = await _submitReview(
      schedule: schedule,
      quality: quality,
      similarityScore: similarityScore,
    );

    result.fold(
      (l) => emit(
        state.copyWith(status: ReviewStatus.error, errorMessage: l.message),
      ),
      (_) {
        if (state.isLastReview) {
          emit(state.copyWith(status: ReviewStatus.completed));
        } else {
          emit(
            state.copyWith(
              status: ReviewStatus.active,
              currentIndex: state.currentIndex + 1,
            ),
          );
        }
      },
    );
  }
}
