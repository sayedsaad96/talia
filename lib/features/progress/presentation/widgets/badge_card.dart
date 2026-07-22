import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/memorization_engine/domain/entities/badge_entity.dart';

class BadgeCard extends StatelessWidget {
  final BadgeEntity badge;

  const BadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = badge.isUnlocked;

    return GestureDetector(
      onTap: () => _showBadgeDetails(context),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.surface : Colors.grey[100],
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(
            color: isUnlocked ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
            width: 2,
          ),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.3,
              child: Text(
                _getEmojiForBadge(badge.type),
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isUnlocked ? badge.name : '???',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? AppColors.textPrimary : Colors.grey[500],
                fontSize: 14,
              ),
            ),
            if (isUnlocked && badge.unlockedAt != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                DateFormat.yMMMd().format(badge.unlockedAt!),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String _getEmojiForBadge(BadgeType type) {
    switch (type) {
      case BadgeType.firstBlock:
        return '🌱';
      case BadgeType.firstWeek:
        return '📅';
      case BadgeType.thirtyDayStreak:
        return '🔥';
      case BadgeType.completeJuz:
        return '🌟';
      case BadgeType.hundredAyahs:
        return '💯';
      case BadgeType.fiveHundredAyahs:
        return '🦅';
      case BadgeType.thousandAyahs:
        return '👑';
    }
  }

  void _showBadgeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Text(_getEmojiForBadge(badge.type), style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(badge.isUnlocked ? badge.name : '???')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badge.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              badge.isUnlocked
                  ? '${AppLocalizations.of(context).badgeUnlocked} ${DateFormat.yMMMMd().format(badge.unlockedAt ?? DateTime.now())}'
                  : AppLocalizations.of(context).badgeLocked,
              style: TextStyle(
                color: badge.isUnlocked ? AppColors.success : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ],
      ),
    );
  }
}
