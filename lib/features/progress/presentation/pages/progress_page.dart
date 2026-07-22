import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/progress/presentation/cubit/progress_cubit.dart';
import 'package:talia/features/progress/presentation/cubit/progress_state.dart';
import 'package:talia/features/progress/presentation/widgets/activity_heatmap.dart';
import 'package:talia/features/progress/presentation/widgets/badge_card.dart';
import 'package:talia/features/progress/presentation/widgets/stat_card.dart';
import 'package:talia/features/progress/presentation/widgets/streak_display.dart';
import 'package:talia/features/progress/presentation/widgets/xp_progress_bar.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProgressCubit>()..loadDashboard(),
      child: const _ProgressView(),
    );
  }
}

class _ProgressView extends StatelessWidget {
  const _ProgressView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.progressDashboard),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ProgressCubit, ProgressState>(
        builder: (context, state) {
          if (state.status == ProgressStatus.initial || state.status == ProgressStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProgressStatus.error || state.progress == null) {
            return Center(child: Text(state.errorMessage ?? l10n.error));
          }

          final progress = state.progress!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Level & XP)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppSpacing.borderRadiusLg,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.person, color: Colors.white, size: 36),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${l10n.level} ${progress.level}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${progress.totalXp} XP',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      XpProgressBar(totalXp: progress.totalXp, level: progress.level),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 2. Stats Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      icon: Icons.menu_book_rounded,
                      label: l10n.totalMemorized,
                      value: progress.totalMemorizedAyahs.toString(),
                      color: AppColors.primary,
                    ),
                    StatCard(
                      icon: Icons.loop_rounded,
                      label: l10n.totalReviews,
                      value: progress.totalReviewedAyahs.toString(),
                      color: Colors.blue,
                    ),
                    StatCard(
                      icon: Icons.check_circle_outline,
                      label: l10n.completionRate,
                      value: '${(progress.completionPercentage * 100).toStringAsFixed(1)}%',
                      color: AppColors.success,
                    ),
                    StatCard(
                      icon: Icons.warning_amber_rounded,
                      label: l10n.weakAyahs,
                      value: progress.weakAyahsCount.toString(),
                      color: Colors.orange,
                      subtitle: progress.weakAyahsCount > 0 ? l10n.needsReview : l10n.allGood,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // 3. Streak
                StreakDisplay(
                  currentStreak: progress.currentStreak,
                  longestStreak: progress.longestStreak,
                ),
                const SizedBox(height: AppSpacing.xl),

                // 4. Activity Heatmap
                Text(
                  l10n.activityHeatmap,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                ActivityHeatmap(dailyActivity: state.dailyActivity),
                const SizedBox(height: AppSpacing.xl),

                // 5. Achievements
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.achievements,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${state.badges.where((b) => b.isUnlocked).length}/${state.badges.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: state.badges.length,
                  itemBuilder: (context, index) {
                    return BadgeCard(badge: state.badges[index]);
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}
