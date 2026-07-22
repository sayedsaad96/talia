import 'package:dartz/dartz.dart';
import 'package:talia/core/error/exceptions.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/data/datasources/memorization_local_data_source.dart';
import 'package:talia/features/memorization_engine/data/models/review_result_model.dart';
import 'package:talia/features/memorization_engine/data/models/review_schedule_model.dart';
import 'package:talia/features/memorization_engine/data/models/streak_model.dart';
import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/streak_entity.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final MemorizationLocalDataSource _localDataSource;
  const ReviewRepositoryImpl(this._localDataSource);

  @override
  ResultFuture<void> saveSchedule(ReviewScheduleEntity schedule) async {
    try {
      await _localDataSource
          .saveSchedule(ReviewScheduleModel.fromEntity(schedule));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<ReviewScheduleEntity>> getSchedules(
      String userId) async {
    try {
      final schedules = await _localDataSource.getSchedules(userId);
      return Right(schedules);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> updateSchedule(ReviewScheduleEntity schedule) async {
    try {
      await _localDataSource
          .updateSchedule(ReviewScheduleModel.fromEntity(schedule));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> saveResult(ReviewResultEntity result) async {
    try {
      final model = ReviewResultModel(
        id: result.id,
        userId: result.userId,
        reviewScheduleId: result.reviewScheduleId,
        quality: result.quality,
        reviewedAt: result.reviewedAt,
        similarityScore: result.similarityScore,
      );
      await _localDataSource.saveResult(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<StreakEntity> getStreak(String userId) async {
    try {
      final streak = await _localDataSource.getStreak(userId);
      return Right(streak);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> saveStreak(String userId, StreakEntity streak) async {
    try {
      await _localDataSource.saveStreak(
        userId,
        StreakModel.fromEntity(streak),
      );
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<BadgeEntity>> getBadges(String userId) async {
    try {
      final badges = await _localDataSource.getBadges(userId);
      return Right(badges);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> saveBadge(String userId, BadgeEntity badge) async {
    try {
      await _localDataSource.saveBadge(userId, badge);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
