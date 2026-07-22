import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';

class ProgressSummaryCard extends StatelessWidget {
  final ProgressEntity progress;

  const ProgressSummaryCard({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Ayahs', progress.totalMemorizedAyahs.toString(), Icons.check_circle, AppColors.success),
                _buildStatColumn('Streak', '${progress.currentStreak} 🔥', Icons.local_fire_department, AppColors.secondary),
                _buildStatColumn('Level', progress.level.toString(), Icons.star, AppColors.primary),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              value: progress.completionPercentage,
              backgroundColor: AppColors.divider,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${(progress.completionPercentage * 100).toStringAsFixed(1)}% of Quran memorized',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
