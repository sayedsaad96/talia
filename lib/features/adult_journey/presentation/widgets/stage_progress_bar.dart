import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

class StageProgressBar extends StatelessWidget {
  final SessionStage currentStage;

  const StageProgressBar({
    super.key,
    required this.currentStage,
  });

  @override
  Widget build(BuildContext context) {
    const stages = [
      SessionStage.learning,
      SessionStage.memorizing,
      SessionStage.reciting,
      SessionStage.remediation,
      SessionStage.blockReview,
    ];

    final currentIndex = stages.indexOf(currentStage);

    return Row(
      children: stages.map((stage) {
        final index = stages.indexOf(stage);
        final isActive = index == currentIndex;
        final isCompleted = index < currentIndex;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : isCompleted
                      ? AppColors.success
                      : AppColors.divider,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
