import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/memorization_engine/domain/entities/coach_recommendation_entity.dart';

class CoachActionCard extends StatelessWidget {
  final CoachRecommendationEntity recommendation;
  final VoidCallback onTap;

  const CoachActionCard({
    super.key,
    required this.recommendation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    IconData icon;

    switch (recommendation.type) {
      case RecommendationType.continueSession:
        cardColor = AppColors.primary;
        icon = Icons.play_circle_fill;
        break;
      case RecommendationType.weakAyahs:
        cardColor = AppColors.error;
        icon = Icons.warning;
        break;
      case RecommendationType.dueReviews:
        cardColor = AppColors.secondary;
        icon = Icons.replay;
        break;
      case RecommendationType.dailyMemorization:
        cardColor = AppColors.primaryLight;
        icon = Icons.add_circle;
        break;
      case RecommendationType.quranReading:
        cardColor = Colors.grey;
        icon = Icons.menu_book;
        break;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      recommendation.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
