import 'package:dartz/dartz.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/coach_recommendation_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/streak_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/progress_calculator.dart';
import 'package:talia/features/memorization_engine/domain/engine/smart_coach.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class GetRecommendationsUseCase {
  final SessionRepository _sessionRepository;
  final ReviewRepository _reviewRepository;
  final MemorizationRepository _memorizationRepository;
  final SmartCoach _smartCoach;
  final ProgressCalculator _progressCalculator;

  const GetRecommendationsUseCase(
    this._sessionRepository,
    this._reviewRepository,
    this._memorizationRepository,
    this._smartCoach,
    this._progressCalculator,
  );

  ResultFuture<List<CoachRecommendationEntity>> call(String userId) async {
    try {
      final activeSessionResult =
          await _sessionRepository.getActiveSession(userId);
      final reviewsResult =
          await _reviewRepository.getSchedules(userId);
      final recordsResult =
          await _memorizationRepository.getRecords(userId);
      final streakResult = await _reviewRepository.getStreak(userId);

      final activeSession =
          activeSessionResult.fold((_) => null, (s) => s);
      final reviews = reviewsResult.fold(
          (_) => <ReviewScheduleEntity>[], (r) => r);
      final records = recordsResult.fold(
          (_) => <MemorizationRecordEntity>[], (r) => r);
      final streak =
          streakResult.fold((_) => const StreakEntity(), (s) => s);

      final progress =
          _progressCalculator.calculateProgress(records, streak, 0);

      final recommendations = _smartCoach.getRecommendations(
        activeSession: activeSession,
        reviews: reviews,
        progress: progress,
      );

      return Right(recommendations);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
