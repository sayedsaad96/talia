import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';

/// Implements the SM-2 spaced repetition algorithm for Quran review scheduling.
class ReviewEngine {
  /// Calculate the next review schedule after a review attempt.
  ReviewScheduleEntity calculateNextReview(
    ReviewScheduleEntity schedule,
    ReviewQuality quality,
  ) {
    final q = _qualityToSm2(quality);

    double newEase =
        schedule.easeFactor + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02));
    newEase = newEase.clamp(1.3, 3.0);

    int newInterval;
    int newConsecutive;

    if (q < 3) {
      newInterval = 1;
      newConsecutive = 0;
    } else {
      newConsecutive = schedule.consecutiveCorrect + 1;
      if (newConsecutive == 1) {
        newInterval = 1;
      } else if (newConsecutive == 2) {
        newInterval = 6;
      } else {
        newInterval = (schedule.intervalDays * newEase).round();
      }
    }

    return schedule.copyWith(
      nextReviewDate: DateTime.now().add(Duration(days: newInterval)),
      intervalDays: newInterval,
      easeFactor: newEase,
      consecutiveCorrect: newConsecutive,
    );
  }

  /// Get all overdue reviews.
  List<ReviewScheduleEntity> getOverdueReviews(
      List<ReviewScheduleEntity> schedules) {
    return schedules.where((s) => s.isOverdue).toList()
      ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));
  }

  /// Get reviews due today (including overdue).
  List<ReviewScheduleEntity> getDueReviews(
      List<ReviewScheduleEntity> schedules) {
    return schedules.where((s) => s.isOverdue || s.isDueToday).toList()
      ..sort((a, b) => a.nextReviewDate.compareTo(b.nextReviewDate));
  }

  /// Get weak ayahs — low ease factor indicates many failed reviews.
  List<ReviewScheduleEntity> getWeakAyahs(
    List<ReviewScheduleEntity> schedules, {
    double threshold = 1.8,
  }) {
    return schedules.where((s) => s.easeFactor < threshold).toList();
  }

  /// Create initial review schedule after first memorization.
  ReviewScheduleEntity createInitialSchedule(MemorizationRecordEntity record) {
    return ReviewScheduleEntity(
      id: '${record.id}_review',
      userId: record.userId,
      memorRecordId: record.id,
      surahNumber: record.surahNumber,
      ayahNumber: record.ayahNumber,
      nextReviewDate: DateTime.now().add(const Duration(days: 1)),
      intervalDays: 1,
      easeFactor: 2.5,
      consecutiveCorrect: 0,
    );
  }

  double updateConfidence(double confidence, ReviewQuality quality) {
    final adjustment = switch (quality) {
      ReviewQuality.forgot => -0.25,
      ReviewQuality.hard => -0.1,
      ReviewQuality.good => 0.1,
      ReviewQuality.easy => 0.2,
    };
    return (confidence + adjustment).clamp(0.0, 1.0).toDouble();
  }

  int _qualityToSm2(ReviewQuality quality) {
    switch (quality) {
      case ReviewQuality.forgot:
        return 0;
      case ReviewQuality.hard:
        return 2;
      case ReviewQuality.good:
        return 4;
      case ReviewQuality.easy:
        return 5;
    }
  }
}
