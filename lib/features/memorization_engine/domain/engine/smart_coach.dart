import 'package:talia/features/memorization_engine/domain/entities/coach_recommendation_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_schedule_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

/// The Smart Coach provides priority-ordered recommendations.
/// It reads memorization data but NEVER writes or modifies it.
///
/// Priority order (from spec):
/// 1. Continue interrupted session
/// 2. Weak verses requiring remediation
/// 3. Scheduled reviews
/// 4. Daily memorization
/// 5. General Quran reading
class SmartCoach {
  List<CoachRecommendationEntity> getRecommendations({
    required SessionEntity? activeSession,
    required List<ReviewScheduleEntity> reviews,
    required ProgressEntity progress,
  }) {
    final recommendations = <CoachRecommendationEntity>[];

    // Priority 1: Continue interrupted session
    if (activeSession != null && activeSession.isActive) {
      recommendations.add(CoachRecommendationEntity(
        type: RecommendationType.continueSession,
        title: 'Continue Session',
        description:
            'Resume your memorization of ${activeSession.surahAyahRange}',
        priority: 1,
        payload: {'sessionId': activeSession.id},
      ));
    }

    // Priority 2: Weak verses
    final weakAyahs = reviews.where((r) => r.easeFactor < 1.8).toList();
    if (weakAyahs.isNotEmpty) {
      recommendations.add(CoachRecommendationEntity(
        type: RecommendationType.weakAyahs,
        title: 'Weak Ayahs',
        description: '${weakAyahs.length} verses need extra practice',
        priority: 2,
        payload: {'count': weakAyahs.length},
      ));
    }

    // Priority 3: Due reviews
    final dueReviews =
        reviews.where((r) => r.isOverdue || r.isDueToday).toList();
    if (dueReviews.isNotEmpty) {
      recommendations.add(CoachRecommendationEntity(
        type: RecommendationType.dueReviews,
        title: 'Due Reviews',
        description: '${dueReviews.length} reviews are waiting',
        priority: 3,
        payload: {'count': dueReviews.length},
      ));
    }

    // Priority 4: Daily memorization (always available)
    recommendations.add(const CoachRecommendationEntity(
      type: RecommendationType.dailyMemorization,
      title: 'New Memorization',
      description: 'Start memorizing new verses',
      priority: 4,
    ));

    // Priority 5: General reading (always available)
    recommendations.add(const CoachRecommendationEntity(
      type: RecommendationType.quranReading,
      title: 'Quran Reading',
      description: 'Continue reading the Quran',
      priority: 5,
    ));

    recommendations.sort((a, b) => a.priority.compareTo(b.priority));
    return recommendations;
  }
}
