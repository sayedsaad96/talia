import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/streak_entity.dart';

abstract class ReviewRepository {
  ResultFuture<void> saveSchedule(ReviewScheduleEntity schedule);
  ResultFuture<List<ReviewScheduleEntity>> getSchedules(String userId);
  ResultFuture<void> updateSchedule(ReviewScheduleEntity schedule);
  ResultFuture<void> saveResult(ReviewResultEntity result);
  ResultFuture<StreakEntity> getStreak(String userId);
  ResultFuture<void> saveStreak(String userId, StreakEntity streak);
  ResultFuture<List<BadgeEntity>> getBadges(String userId);
  ResultFuture<void> saveBadge(String userId, BadgeEntity badge);
}
