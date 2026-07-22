import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';

class AyahDisplayCard extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final int hintLevel;

  const AyahDisplayCard({
    super.key,
    required this.surahNumber,
    required this.ayahNumber,
    this.hintLevel = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              '$surahNumber:$ayahNumber',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (hintLevel == 0)
              const Icon(Icons.visibility_off, size: 64, color: AppColors.divider)
            else
              const Text(
                'Ayah text placeholder...',
                style: TextStyle(
                  fontSize: 28,
                  height: 1.8,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            // Note: A full implementation would mask words based on hintLevel (1 = first word, 2 = full).
            // Here, hintLevel 0 is hidden, anything else is full text for simplicity.
          ],
        ),
      ),
    );
  }
}
