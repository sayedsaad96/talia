import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/streak_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/xp_config.dart';

/// Computes aggregate progress from memorization records.
/// This class reads data only — it never persists anything.
class ProgressCalculator {
  /// Calculate overall progress from memorization records.
  ProgressEntity calculateProgress(
    List<MemorizationRecordEntity> records,
    StreakEntity streak,
    int totalXp,
  ) {
    final memorized = records.length;
    final reviewed = records.where((r) => r.reviewCount > 0).length;
    final weak = records.where((r) => r.isWeak).length;

    return ProgressEntity(
      totalMemorizedAyahs: memorized,
      totalReviewedAyahs: reviewed,
      weakAyahsCount: weak,
      currentStreak: streak.currentStreak,
      longestStreak: streak.longestStreak,
      totalXp: totalXp,
      level: XpConfig.levelFromXp(totalXp),
      lastActivityDate: streak.lastActivityDate,
      completionPercentage: memorized / ProgressEntity.totalQuranAyahs,
    );
  }

  /// Update streak based on new activity date.
  StreakEntity updateStreak(StreakEntity current, DateTime activityDate) {
    final activityDay = DateTime(
        activityDate.year, activityDate.month, activityDate.day);

    if (current.lastActivityDate != null) {
      final lastDay = DateTime(
        current.lastActivityDate!.year,
        current.lastActivityDate!.month,
        current.lastActivityDate!.day,
      );
      if (activityDay == lastDay) return current;

      final difference = activityDay.difference(lastDay).inDays;
      if (difference == 1) {
        final newStreak = current.currentStreak + 1;
        return current.copyWith(
          currentStreak: newStreak,
          longestStreak: newStreak > current.longestStreak
              ? newStreak
              : current.longestStreak,
          lastActivityDate: activityDate,
        );
      } else {
        return current.copyWith(
          currentStreak: 1,
          lastActivityDate: activityDate,
        );
      }
    }

    return current.copyWith(
      currentStreak: 1,
      longestStreak: 1,
      lastActivityDate: activityDate,
    );
  }

  /// Check which badges should be unlocked based on progress.
  List<BadgeEntity> checkBadges(
    ProgressEntity progress,
    List<BadgeEntity> existing,
  ) {
    return existing.map((badge) {
      if (badge.isUnlocked) return badge;
      final shouldUnlock = _checkBadgeCondition(badge.type, progress);
      return shouldUnlock ? badge.unlock() : badge;
    }).toList();
  }

  bool _checkBadgeCondition(BadgeType type, ProgressEntity progress) {
    switch (type) {
      case BadgeType.firstBlock:
        return progress.totalMemorizedAyahs >= 1;
      case BadgeType.firstWeek:
        return progress.currentStreak >= 7;
      case BadgeType.thirtyDayStreak:
        return progress.longestStreak >= 30;
      case BadgeType.completeJuz:
        return progress.totalMemorizedAyahs >= 200;
      case BadgeType.hundredAyahs:
        return progress.totalMemorizedAyahs >= 100;
      case BadgeType.fiveHundredAyahs:
        return progress.totalMemorizedAyahs >= 500;
      case BadgeType.thousandAyahs:
        return progress.totalMemorizedAyahs >= 1000;
    }
  }

  /// Calculate level from XP.
  int calculateLevel(int totalXp) => XpConfig.levelFromXp(totalXp);
}
