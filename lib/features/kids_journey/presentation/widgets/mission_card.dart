import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/kids_journey/presentation/widgets/star_rating.dart';

class MissionCard extends StatelessWidget {
  final int surahNumber;
  final String surahName;
  final int earnedStars;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const MissionCard({
    super.key,
    required this.surahNumber,
    required this.surahName,
    required this.earnedStars,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isUnlocked ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      color: isUnlocked ? AppColors.surface : Colors.grey[200],
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: isUnlocked ? onTap : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? AppColors.primaryLight.withValues(alpha: 0.2)
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isUnlocked
                      ? Text(
                          '$surahNumber',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        )
                      : Icon(Icons.lock, color: Colors.grey[500]),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked
                            ? AppColors.textPrimary
                            : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (isUnlocked)
                      StarRating(earnedStars: earnedStars, starSize: 24)
                    else
                      Text('Locked', style: TextStyle(color: Colors.grey[500])),
                  ],
                ),
              ),
              if (isUnlocked)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
