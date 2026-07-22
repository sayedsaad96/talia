import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/adult_journey/presentation/cubit/home_cubit.dart';
import 'package:talia/features/adult_journey/presentation/cubit/home_state.dart';
import 'package:talia/features/adult_journey/presentation/widgets/coach_action_card.dart';
import 'package:talia/features/adult_journey/presentation/widgets/progress_summary_card.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';

class SmartHomePage extends StatelessWidget {
  const SmartHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => sl<HomeCubit>()..loadDashboard(),
      child: const _SmartHomeView(),
    );
  }
}

class _SmartHomeView extends StatelessWidget {
  const _SmartHomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Talia / تاليا', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(RouteNames.settingsPath),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.sessionSetupPath),
        icon: const Icon(Icons.add),
        label: Text(l10n.startMemorizing),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.initial || state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HomeStatus.error) {
            return Center(child: Text(state.errorMessage ?? l10n.error));
          }

          return RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadDashboard(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.goodMorning, // Should be dynamic based on time
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ProgressSummaryCard(progress: state.progress),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.smartCoach,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (state.recommendations.isNotEmpty)
                    CoachActionCard(
                      recommendation: state.recommendations.first,
                      onTap: () {
                        // Navigate based on recommendation type
                        final type = state.recommendations.first.type.name;
                        if (type == 'continueSession') {
                          context.push(RouteNames.sessionActivePath);
                        } else if (type == 'weakAyahs') {
                          context.push(RouteNames.weakAyahsPath);
                        } else if (type == 'dueReviews') {
                          context.push(RouteNames.reviewPath);
                        } else if (type == 'dailyMemorization') {
                          context.push(RouteNames.sessionSetupPath);
                        } else if (type == 'quranReading') {
                          context.push(RouteNames.quranReaderPath);
                        }
                      },
                    )
                  else
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Text("You're all caught up!"),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          context,
                          l10n.quran,
                          Icons.menu_book,
                          () => context.push(RouteNames.quranReaderPath),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          l10n.review,
                          Icons.replay,
                          () => context.push(RouteNames.reviewPath),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          l10n.bookmarks,
                          Icons.bookmark,
                          () => context.push(RouteNames.bookmarksPath),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          l10n.kids,
                          Icons.child_care,
                          () => context.push(RouteNames.kidsHomePath),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          l10n.progress,
                          Icons.bar_chart_rounded,
                          () => context.push(RouteNames.progressPath),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80), // Fab padding

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
