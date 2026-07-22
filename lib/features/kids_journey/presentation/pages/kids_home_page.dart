import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/kids_journey/presentation/cubit/kids_home_cubit.dart';
import 'package:talia/features/kids_journey/presentation/cubit/kids_home_state.dart';
import 'package:talia/features/kids_journey/presentation/widgets/level_badge.dart';
import 'package:talia/features/kids_journey/presentation/widgets/world_zone_card.dart';

class KidsHomePage extends StatelessWidget {
  const KidsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<KidsHomeCubit>()..loadKidsHome(),
      child: const _KidsHomeView(),
    );
  }
}

class _KidsHomeView extends StatelessWidget {
  const _KidsHomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB), // Sky blue background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 4),
                BlocBuilder<KidsHomeCubit, KidsHomeState>(
                  builder: (context, state) {
                    return Text(
                      '${state.progress.totalXp}', // Show XP as stars for kids
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: BlocBuilder<KidsHomeCubit, KidsHomeState>(
        builder: (context, state) {
          if (state.status == KidsHomeStatus.loading || state.status == KidsHomeStatus.initial) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          return SafeArea(
            child: Column(
              children: [
                // Header Avatar
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.secondary, width: 4),
                        ),
                        child: const Center(
                          child: Text('👦', style: TextStyle(fontSize: 40)), // Placeholder avatar
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tariq', // Mock name
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                          ),
                          LevelBadge(level: state.progress.level, size: 40),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // World Map
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: state.juzProgress.length,
                    itemBuilder: (context, index) {
                      final juz = state.juzProgress[index];
                      return Center(
                        child: WorldZoneCard(
                          juzNumber: juz.juzNumber,
                          completionPercentage: juz.completionPercentage,
                          isUnlocked: juz.isUnlocked,
                          onTap: () {
                            context.push(RouteNames.kidsMissionPath, extra: juz.juzNumber);
                          },
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),
                
                // Ground Illustration (Placeholder)
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7CB342), // Grass green
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      l10n.kidsWorldMap,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
