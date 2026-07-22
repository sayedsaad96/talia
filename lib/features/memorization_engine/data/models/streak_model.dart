import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/streak_entity.dart';

class StreakModel extends StreakEntity {
  const StreakModel({
    super.currentStreak,
    super.longestStreak,
    super.lastActivityDate,
  });

  factory StreakModel.fromJson(DataMap json) {
    return StreakModel(
      currentStreak: (json['current_streak'] as int?) ?? 0,
      longestStreak: (json['longest_streak'] as int?) ?? 0,
      lastActivityDate: json['last_activity_date'] != null
          ? DateTime.parse(json['last_activity_date'] as String)
          : null,
    );
  }

  DataMap toJson() => {
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_activity_date': lastActivityDate?.toIso8601String(),
      };

  static StreakModel fromEntity(StreakEntity entity) {
    return StreakModel(
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      lastActivityDate: entity.lastActivityDate,
    );
  }
}
