import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';

class ReviewQualitySelector extends StatelessWidget {
  final ValueChanged<ReviewQuality> onSelected;

  const ReviewQualitySelector({
    super.key,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton('Forgot', ReviewQuality.forgot, AppColors.error),
        _buildButton('Hard', ReviewQuality.hard, Colors.orange),
        _buildButton('Good', ReviewQuality.good, AppColors.primaryLight),
        _buildButton('Easy', ReviewQuality.easy, AppColors.success),
      ],
    );
  }

  Widget _buildButton(String label, ReviewQuality quality, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
          ),
          onPressed: () => onSelected(quality),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}
