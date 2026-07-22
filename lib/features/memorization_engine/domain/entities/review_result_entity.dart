import 'package:equatable/equatable.dart';

enum ReviewQuality { forgot, hard, good, easy }

class ReviewResultEntity extends Equatable {
  final String id;
  final String userId;
  final String reviewScheduleId;
  final ReviewQuality quality;
  final DateTime reviewedAt;
  final double similarityScore;

  const ReviewResultEntity({
    required this.id,
    required this.userId,
    required this.reviewScheduleId,
    required this.quality,
    required this.reviewedAt,
    this.similarityScore = 0.0,
  });

  bool get isSuccessful => quality == ReviewQuality.good || quality == ReviewQuality.easy;
  bool get isFailed => quality == ReviewQuality.forgot;

  @override
  List<Object?> get props => [id, userId, reviewScheduleId, quality, reviewedAt];
}
