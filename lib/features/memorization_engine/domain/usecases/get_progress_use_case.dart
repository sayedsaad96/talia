import 'package:dartz/dartz.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/streak_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/progress_calculator.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class GetProgressUseCase {
  final MemorizationRepository _memorizationRepository;
  final ReviewRepository _reviewRepository;
  final SessionRepository _sessionRepository;
  final ProgressCalculator _progressCalculator;

  const GetProgressUseCase(
    this._memorizationRepository,
    this._reviewRepository,
    this._sessionRepository,
    this._progressCalculator,
  );

  ResultFuture<ProgressEntity> call(String userId) async {
    try {
      final recordsResult =
          await _memorizationRepository.getRecords(userId);
      final streakResult = await _reviewRepository.getStreak(userId);
      final sessionsResult = await _sessionRepository.getCompletedSessions(userId);

      final records = recordsResult.fold(
          (_) => <MemorizationRecordEntity>[], (r) => r);
      final streak =
          streakResult.fold((_) => const StreakEntity(), (s) => s);

      final completedSessions = sessionsResult.fold(
        (_) => <SessionEntity>[],
        (sessions) => sessions,
      );
      final totalXp = completedSessions.fold(
        0,
        (sum, session) => sum + session.xpEarned,
      );

      return Right(
          _progressCalculator.calculateProgress(records, streak, totalXp));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
