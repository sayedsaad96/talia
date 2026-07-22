import 'package:equatable/equatable.dart';

class StreakEntity extends Equatable {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const StreakEntity({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastActivityDate,
  });

  bool get isActiveToday {
    if (lastActivityDate == null) return false;
    final now = DateTime.now();
    return lastActivityDate!.year == now.year &&
        lastActivityDate!.month == now.month &&
        lastActivityDate!.day == now.day;
  }

  StreakEntity copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastActivityDate,
  }) {
    return StreakEntity(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }

  @override
  List<Object?> get props => [currentStreak, longestStreak, lastActivityDate];
}
