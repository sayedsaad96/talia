import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  final int totalMemorizedAyahs;
  final int totalReviewedAyahs;
  final int weakAyahsCount;
  final int currentStreak;
  final int longestStreak;
  final int totalXp;
  final int level;
  final DateTime? lastActivityDate;
  final double completionPercentage;

  const ProgressEntity({
    this.totalMemorizedAyahs = 0,
    this.totalReviewedAyahs = 0,
    this.weakAyahsCount = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalXp = 0,
    this.level = 1,
    this.lastActivityDate,
    this.completionPercentage = 0.0,
  });

  static const int totalQuranAyahs = 6236;

  @override
  List<Object?> get props => [
        totalMemorizedAyahs,
        totalReviewedAyahs,
        weakAyahsCount,
        currentStreak,
        longestStreak,
        totalXp,
        level,
      ];
}
