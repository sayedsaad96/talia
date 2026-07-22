import 'package:flutter/material.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/memorization_engine/domain/entities/xp_config.dart';

class XpProgressBar extends StatelessWidget {
  final int totalXp;
  final int level;

  const XpProgressBar({
    super.key,
    required this.totalXp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final xpForCurrentLevel = XpConfig.xpForLevel(level);
    final xpForNextLevel = XpConfig.xpForLevel(level + 1);
    
    final int currentLevelProgress = totalXp - xpForCurrentLevel;
    final int xpNeededForNext = xpForNextLevel - xpForCurrentLevel;
    
    final double progress = (currentLevelProgress / xpNeededForNext).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${l10n.level} $level',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            Text(
              '$currentLevelProgress / $xpNeededForNext XP',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    tween: Tween<double>(begin: 0.0, end: progress),
                    builder: (context, value, child) {
                      return Container(
                        width: constraints.maxWidth * value,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: AppSpacing.borderRadiusFull,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
