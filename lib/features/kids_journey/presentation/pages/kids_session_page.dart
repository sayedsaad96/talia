import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/adult_journey/presentation/cubit/session_cubit.dart';
import 'package:talia/features/adult_journey/presentation/cubit/session_state.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

class KidsSessionPage extends StatelessWidget {
  final int surahNumber;

  const KidsSessionPage({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final totalAyahs = getVerseCount(surahNumber);
        return sl<SessionCubit>()..startSession(surahNumber, 1, totalAyahs);
      },
      child: const _KidsSessionView(),
    );
  }
}

class _KidsSessionView extends StatelessWidget {
  const _KidsSessionView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.amber[50], // Warm child-friendly background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 32),
          onPressed: () => context.pop(),
        ),
        actions: [
          _buildStageStars(context),
          const SizedBox(width: AppSpacing.md),
        ],
      ),
      body: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state.session?.stage == SessionStage.completed) {
            context.pushReplacement(RouteNames.kidsRewardPath);
          } else if (state.status == SessionCubitStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? l10n.error)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == SessionCubitStatus.initial || state.status == SessionCubitStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.session == null) {
            return Center(child: Text(l10n.error));
          }

          final currentAyahNumber = state.session!.ayahProgress[state.currentAyahIndex].ayahNumber;
          final stage = state.session!.stage;

          return Column(
            children: [
              // Large Arabic Text Area
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getDisplayText(state.session!.surahNumber, currentAyahNumber, stage),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'QCF2', // Assuming Uthmani font
                            fontSize: 48,
                            height: 1.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (stage == SessionStage.learning || stage == SessionStage.memorizing) ...[
                          const SizedBox(height: AppSpacing.xl),
                          FloatingActionButton.large(
                            heroTag: 'play_audio_btn',
                            backgroundColor: AppColors.primary,
                            onPressed: () {
                              // Play audio
                            },
                            child: const Icon(Icons.play_arrow_rounded, size: 48),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Row(
                  children: [
                    if (stage == SessionStage.reciting || stage == SessionStage.remediation || stage == SessionStage.blockReview) ...[
                      Expanded(
                        child: _KidsButton(
                          label: l10n.kidsHelpMe,
                          color: Colors.orange,
                          icon: Icons.support,
                          onTap: () {
                            _evaluateRecitation(
                              context,
                              currentAyahNumber,
                              0.0,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _KidsButton(
                          label: l10n.kidsIknowIt,
                          color: AppColors.success,
                          icon: Icons.thumb_up,
                          onTap: () {
                            _evaluateRecitation(
                              context,
                              currentAyahNumber,
                              1.0,
                            );
                          },
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: _KidsButton(
                          label: l10n.next,
                          color: AppColors.primary,
                          icon: Icons.arrow_forward_rounded,
                          onTap: () {
                            if (stage == SessionStage.learning) {
                              _completeLearnStep(context, currentAyahNumber);
                            } else if (stage == SessionStage.memorizing) {
                              _completeMemorizeStep(context, currentAyahNumber);
                            }
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        },
      ),
    );
  }

  String _getDisplayText(int surah, int ayah, SessionStage stage) {
    if (stage == SessionStage.reciting || stage == SessionStage.blockReview) {
      return '❓'; // Hide verse
    }
    return 'Ayah text placeholder...';
  }

  Future<void> _completeLearnStep(BuildContext context, int ayahNumber) async {
    final cubit = context.read<SessionCubit>();
    if (await cubit.completeLearnStep(ayahNumber)) {
      await cubit.advanceAfterCurrentAyah();
    }
  }

  Future<void> _completeMemorizeStep(
    BuildContext context,
    int ayahNumber,
  ) async {
    final cubit = context.read<SessionCubit>();
    if (await cubit.completeMemorizeStep(ayahNumber, 0)) {
      await cubit.advanceAfterCurrentAyah();
    }
  }

  Future<void> _evaluateRecitation(
    BuildContext context,
    int ayahNumber,
    double score,
  ) async {
    final cubit = context.read<SessionCubit>();
    if (await cubit.evaluateRecitation(ayahNumber, score)) {
      await cubit.advanceAfterCurrentAyah();
    }
  }

  Widget _buildStageStars(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state.session == null) return const SizedBox.shrink();
        
        // 6 stages total
        final currentStageIndex = state.session!.stage.index;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (index) {
            final isActive = index <= currentStageIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                isActive ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isActive ? Colors.amber : Colors.grey[400],
                size: 24,
              ),
            );
          }),
        );
      },
    );
  }
}

class _KidsButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _KidsButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
