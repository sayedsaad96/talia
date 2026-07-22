import 'package:equatable/equatable.dart';

class ReviewScheduleEntity extends Equatable {
  final String id;
  final String userId;
  final String memorRecordId;
  final int surahNumber;
  final int ayahNumber;
  final DateTime nextReviewDate;
  final int intervalDays;
  final double easeFactor;       // SM-2 ease factor, default 2.5
  final int consecutiveCorrect;

  const ReviewScheduleEntity({
    required this.id,
    required this.userId,
    required this.memorRecordId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.nextReviewDate,
    this.intervalDays = 1,
    this.easeFactor = 2.5,
    this.consecutiveCorrect = 0,
  });

  bool get isOverdue => DateTime.now().isAfter(nextReviewDate);
  bool get isDueToday {
    final now = DateTime.now();
    return nextReviewDate.year == now.year &&
        nextReviewDate.month == now.month &&
        nextReviewDate.day == now.day;
  }

  ReviewScheduleEntity copyWith({
    DateTime? nextReviewDate,
    int? intervalDays,
    double? easeFactor,
    int? consecutiveCorrect,
  }) {
    return ReviewScheduleEntity(
      id: id,
      userId: userId,
      memorRecordId: memorRecordId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        surahNumber,
        ayahNumber,
        nextReviewDate,
        intervalDays,
      ];
}
