import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';

class ReviewScheduleModel extends ReviewScheduleEntity {
  const ReviewScheduleModel({
    required super.id,
    required super.userId,
    required super.memorRecordId,
    required super.surahNumber,
    required super.ayahNumber,
    required super.nextReviewDate,
    super.intervalDays,
    super.easeFactor,
    super.consecutiveCorrect,
  });

  factory ReviewScheduleModel.fromJson(DataMap json) {
    return ReviewScheduleModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ??
          _userIdFromRecordId(json['memor_record_id'] as String),
      memorRecordId: json['memor_record_id'] as String,
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      nextReviewDate: DateTime.parse(json['next_review_date'] as String),
      intervalDays: (json['interval_days'] as int?) ?? 1,
      easeFactor: (json['ease_factor'] as num?)?.toDouble() ?? 2.5,
      consecutiveCorrect: (json['consecutive_correct'] as int?) ?? 0,
    );
  }

  DataMap toJson() => {
        'id': id,
        'user_id': userId,
        'memor_record_id': memorRecordId,
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'next_review_date': nextReviewDate.toIso8601String(),
        'interval_days': intervalDays,
        'ease_factor': easeFactor,
        'consecutive_correct': consecutiveCorrect,
      };

  static ReviewScheduleModel fromEntity(ReviewScheduleEntity entity) {
    return ReviewScheduleModel(
      id: entity.id,
      userId: entity.userId,
      memorRecordId: entity.memorRecordId,
      surahNumber: entity.surahNumber,
      ayahNumber: entity.ayahNumber,
      nextReviewDate: entity.nextReviewDate,
      intervalDays: entity.intervalDays,
      easeFactor: entity.easeFactor,
      consecutiveCorrect: entity.consecutiveCorrect,
    );
  }

  static String _userIdFromRecordId(String recordId) {
    final separatorIndex = recordId.lastIndexOf('_');
    final secondSeparatorIndex = recordId.lastIndexOf('_', separatorIndex - 1);
    return secondSeparatorIndex == -1
        ? recordId
        : recordId.substring(0, secondSeparatorIndex);
  }
}
