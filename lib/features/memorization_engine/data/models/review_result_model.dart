import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';

class ReviewResultModel extends ReviewResultEntity {
  const ReviewResultModel({
    required super.id,
    required super.userId,
    required super.reviewScheduleId,
    required super.quality,
    required super.reviewedAt,
    super.similarityScore,
  });

  factory ReviewResultModel.fromJson(DataMap json) {
    return ReviewResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String? ??
          _userIdFromScheduleId(json['review_schedule_id'] as String),
      reviewScheduleId: json['review_schedule_id'] as String,
      quality: ReviewQuality.values.firstWhere(
        (q) => q.name == (json['quality'] as String),
        orElse: () => ReviewQuality.good,
      ),
      reviewedAt: DateTime.parse(json['reviewed_at'] as String),
      similarityScore:
          (json['similarity_score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  DataMap toJson() => {
        'id': id,
        'user_id': userId,
        'review_schedule_id': reviewScheduleId,
        'quality': quality.name,
        'reviewed_at': reviewedAt.toIso8601String(),
        'similarity_score': similarityScore,
      };

  static String _userIdFromScheduleId(String scheduleId) {
    const suffix = '_review';
    final recordId = scheduleId.endsWith(suffix)
        ? scheduleId.substring(0, scheduleId.length - suffix.length)
        : scheduleId;
    final separatorIndex = recordId.lastIndexOf('_');
    final secondSeparatorIndex = recordId.lastIndexOf('_', separatorIndex - 1);
    return secondSeparatorIndex == -1
        ? recordId
        : recordId.substring(0, secondSeparatorIndex);
  }
}
