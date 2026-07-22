import 'package:dartz/dartz.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/review_engine.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';

class GetDueReviewsUseCase {
  final ReviewRepository _reviewRepository;
  final ReviewEngine _reviewEngine;

  const GetDueReviewsUseCase(this._reviewRepository, this._reviewEngine);

  ResultFuture<List<ReviewScheduleEntity>> call(String userId) async {
    final result = await _reviewRepository.getSchedules(userId);
    return result.fold(
      Left.new,
      (schedules) => Right(_reviewEngine.getDueReviews(schedules)),
    );
  }
}
