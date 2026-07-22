import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/adult_journey/presentation/widgets/xp_earned_animation.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';

class SessionCompletePage extends StatelessWidget {
  const SessionCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: AppColors.secondary),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.sessionComplete,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const XpEarnedAnimation(xp: 150), // Hardcoded for now
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: () {
                  context.go(RouteNames.homePath);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                child: Text(l10n.backToHome, style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
