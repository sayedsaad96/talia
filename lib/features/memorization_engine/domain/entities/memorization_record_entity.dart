import 'package:equatable/equatable.dart';

/// Permanent record created when an ayah is successfully memorized.
/// Immutable after creation — only reviewCount, lastReviewedAt, and confidence update.
class MemorizationRecordEntity extends Equatable {
  final String id;
  final String userId;
  final int surahNumber;
  final int ayahNumber;
  final double qualityScore;     // 0.0-1.0 (reduced by hints)
  final int totalAttempts;
  final DateTime memorizedAt;
  final DateTime lastReviewedAt;
  final int reviewCount;
  final double confidence;       // 0.0-1.0 (updated after reviews)

  const MemorizationRecordEntity({
    required this.id,
    required this.userId,
    required this.surahNumber,
    required this.ayahNumber,
    required this.qualityScore,
    required this.totalAttempts,
    required this.memorizedAt,
    required this.lastReviewedAt,
    this.reviewCount = 0,
    this.confidence = 1.0,
  });

  bool get isWeak => confidence < 0.4;
  bool get isStrong => confidence >= 0.8;

  MemorizationRecordEntity copyWith({
    DateTime? lastReviewedAt,
    int? reviewCount,
    double? confidence,
  }) {
    return MemorizationRecordEntity(
      id: id,
      userId: userId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      qualityScore: qualityScore,
      totalAttempts: totalAttempts,
      memorizedAt: memorizedAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      reviewCount: reviewCount ?? this.reviewCount,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  List<Object?> get props => [id, surahNumber, ayahNumber, confidence];
}
