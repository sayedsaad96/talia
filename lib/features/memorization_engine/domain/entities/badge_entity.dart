import 'package:equatable/equatable.dart';

enum BadgeType {
  firstBlock,
  firstWeek,
  thirtyDayStreak,
  completeJuz,
  hundredAyahs,
  fiveHundredAyahs,
  thousandAyahs,
}

class BadgeEntity extends Equatable {
  final BadgeType type;
  final String name;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeEntity({
    required this.type,
    required this.name,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  BadgeEntity unlock() => BadgeEntity(
        type: type,
        name: name,
        description: description,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );

  @override
  List<Object?> get props => [type, isUnlocked];
}
