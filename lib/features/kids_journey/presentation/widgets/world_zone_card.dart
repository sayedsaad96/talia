import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';

class WorldZoneCard extends StatelessWidget {
  final int juzNumber;
  final double completionPercentage;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const WorldZoneCard({
    super.key,
    required this.juzNumber,
    required this.completionPercentage,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double size = 120.0;
    final bool isCompleted = completionPercentage >= 1.0;

    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUnlocked ? AppColors.surface : Colors.grey[300],
          border: Border.all(
            color: isUnlocked ? AppColors.primary : Colors.grey[400]!,
            width: isUnlocked ? 4.0 : 2.0,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isUnlocked)
              CircularProgressIndicator(
                value: completionPercentage,
                strokeWidth: 6,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.success,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isUnlocked)
                  Icon(Icons.lock, color: Colors.grey[500], size: 32)
                else if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 32,
                  )
                else
                  Text(
                    '$juzNumber',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Zone $juzNumber', // TODO localize
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
