import 'package:equatable/equatable.dart';

enum RecommendationType {
  continueSession,
  weakAyahs,
  dueReviews,
  dailyMemorization,
  quranReading,
}

class CoachRecommendationEntity extends Equatable {
  final RecommendationType type;
  final String title;
  final String description;
  final int priority;
  final Map<String, dynamic>? payload;

  const CoachRecommendationEntity({
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    this.payload,
  });

  @override
  List<Object?> get props => [type, priority];
}
