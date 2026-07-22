import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';

class MemorizationRecordModel extends MemorizationRecordEntity {
  const MemorizationRecordModel({
    required super.id,
    required super.userId,
    required super.surahNumber,
    required super.ayahNumber,
    required super.qualityScore,
    required super.totalAttempts,
    required super.memorizedAt,
    required super.lastReviewedAt,
    super.reviewCount,
    super.confidence,
  });

  factory MemorizationRecordModel.fromJson(DataMap json) {
    return MemorizationRecordModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      qualityScore: (json['quality_score'] as num).toDouble(),
      totalAttempts: json['total_attempts'] as int,
      memorizedAt: DateTime.parse(json['memorized_at'] as String),
      lastReviewedAt: DateTime.parse(json['last_reviewed_at'] as String),
      reviewCount: (json['review_count'] as int?) ?? 0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
    );
  }

  DataMap toJson() => {
        'id': id,
        'user_id': userId,
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'quality_score': qualityScore,
        'total_attempts': totalAttempts,
        'memorized_at': memorizedAt.toIso8601String(),
        'last_reviewed_at': lastReviewedAt.toIso8601String(),
        'review_count': reviewCount,
        'confidence': confidence,
      };

  static MemorizationRecordModel fromEntity(
      MemorizationRecordEntity entity) {
    return MemorizationRecordModel(
      id: entity.id,
      userId: entity.userId,
      surahNumber: entity.surahNumber,
      ayahNumber: entity.ayahNumber,
      qualityScore: entity.qualityScore,
      totalAttempts: entity.totalAttempts,
      memorizedAt: entity.memorizedAt,
      lastReviewedAt: entity.lastReviewedAt,
      reviewCount: entity.reviewCount,
      confidence: entity.confidence,
    );
  }
}
