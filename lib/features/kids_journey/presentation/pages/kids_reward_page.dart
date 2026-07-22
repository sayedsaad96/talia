import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/kids_journey/presentation/widgets/confetti_animation.dart';
import 'package:talia/features/kids_journey/presentation/widgets/star_rating.dart';

class KidsRewardPage extends StatelessWidget {
  const KidsRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.blue[900], // Deep space / celebratory dark blue
      body: Stack(
        children: [
          // Background Confetti
          const ConfettiAnimation(),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 100)),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    l10n.kidsGreatJob,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Stars
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const StarRating(
                      earnedStars: 3, // Mock earned stars
                      starSize: 64,
                      animate: true,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    l10n.kidsRewardUnlocked,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Mock Badge
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/placeholder_badge.png',
                        ), // Need to add or ignore for now
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Text('🏆', style: TextStyle(fontSize: 60)),
                    ),
                  ),

                  const SizedBox(height: 80),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                        onPressed: () {
                          // Return to kids home
                          context.go(RouteNames.kidsHomePath);
                        },
                        child: Text(
                          l10n.kidsBackToMap,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
