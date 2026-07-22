import 'package:dartz/dartz.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/review_engine.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';

class SubmitReviewUseCase {
  final ReviewRepository _reviewRepository;
  final MemorizationRepository _memorizationRepository;
  final ReviewEngine _reviewEngine;

  const SubmitReviewUseCase(
    this._reviewRepository,
    this._memorizationRepository,
    this._reviewEngine,
  );

  ResultFuture<ReviewScheduleEntity> call({
    required ReviewScheduleEntity schedule,
    required ReviewQuality quality,
    required double similarityScore,
  }) async {
    try {
      final updated = _reviewEngine.calculateNextReview(schedule, quality);
      _ensureSucceeded(await _reviewRepository.updateSchedule(updated));

      final recordResult = await _memorizationRepository.getRecord(
        schedule.userId,
        schedule.surahNumber,
        schedule.ayahNumber,
      );
      final record = recordResult.fold(
        (failure) => throw StateError(failure.message),
        (resolved) {
          if (resolved == null) {
            throw StateError('Memorization record not found for review');
          }
          return resolved;
        },
      );
      final updatedRecord = record.copyWith(
        lastReviewedAt: DateTime.now(),
        reviewCount: record.reviewCount + 1,
        confidence: _reviewEngine.updateConfidence(record.confidence, quality),
      );
      final updateRecordOutcome =
          await _memorizationRepository.updateRecord(updatedRecord);
      _ensureSucceeded(updateRecordOutcome);

      final reviewResult = ReviewResultEntity(
        id: '${schedule.id}_${DateTime.now().millisecondsSinceEpoch}',
        userId: schedule.userId,
        reviewScheduleId: schedule.id,
        quality: quality,
        reviewedAt: DateTime.now(),
        similarityScore: similarityScore,
      );
      _ensureSucceeded(await _reviewRepository.saveResult(reviewResult));

      return Right(updated);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  void _ensureSucceeded(Either<Failure, void> outcome) {
    outcome.fold(
      (failure) => throw StateError(failure.message),
      (_) {},
    );
  }
}
