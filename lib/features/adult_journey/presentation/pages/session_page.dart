import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/adult_journey/presentation/cubit/session_cubit.dart';
import 'package:talia/features/adult_journey/presentation/cubit/session_state.dart';
import 'package:talia/features/adult_journey/presentation/widgets/ayah_display_card.dart';
import 'package:talia/features/adult_journey/presentation/widgets/stage_progress_bar.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/ayah_progress_entity.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';

class SessionPage extends StatelessWidget {
  final int surahNumber;
  final int startAyah;
  final int endAyah;

  const SessionPage({
    super.key,
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionCubit>(
      create: (_) => sl<SessionCubit>()..startSession(surahNumber, startAyah, endAyah),
      child: const _SessionView(),
    );
  }
}

class _SessionView extends StatelessWidget {
  const _SessionView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memorizationSession),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(), // Exit session safely
        ),
      ),
      body: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state.status == SessionCubitStatus.completed) {
            context.pushReplacement(RouteNames.sessionCompletePath);
          }
        },
        builder: (context, state) {
          if (state.status == SessionCubitStatus.loading || state.status == SessionCubitStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == SessionCubitStatus.error) {
            return Center(child: Text(state.errorMessage ?? l10n.error));
          }

          final session = state.session!;
          final ayahProgress = session.ayahProgress[state.currentAyahIndex];

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StageProgressBar(currentStage: session.stage),
                const SizedBox(height: AppSpacing.sm),
                Center(
                  child: Text(
                    session.stage.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AyahDisplayCard(
                  surahNumber: session.surahNumber,
                  ayahNumber: ayahProgress.ayahNumber,
                  hintLevel: _getHintLevelForStage(session.stage),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: state.currentAyahIndex > 0
                          ? () => context.read<SessionCubit>().previousAyah()
                          : null,
                    ),
                    Text('${state.currentAyahIndex + 1} / ${session.ayahProgress.length}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: state.currentAyahIndex < session.ayahProgress.length - 1
                          ? () => context.read<SessionCubit>().nextAyah()
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildActionButtons(context, session.stage, ayahProgress),
              ],
            ),
          );
        },
      ),
    );
  }

  int _getHintLevelForStage(SessionStage stage) {
    switch (stage) {
      case SessionStage.learning:
      case SessionStage.blockReview:
      case SessionStage.remediation:
        return 2; // Full text
      case SessionStage.memorizing:
        return 1; // First word hint
      case SessionStage.reciting:
      case SessionStage.completed:
      case SessionStage.created:
        return 0; // Hidden
    }
  }

  Widget _buildActionButtons(BuildContext context, SessionStage stage, AyahProgressEntity ayah) {
    final cubit = context.read<SessionCubit>();
    final l10n = AppLocalizations.of(context);

    switch (stage) {
      case SessionStage.learning:
        return ElevatedButton(
          onPressed: () {
            _completeLearnStep(cubit, ayah.ayahNumber);
          },
          child: Text(l10n.iveLearnedThis),
        );
      case SessionStage.memorizing:
        return ElevatedButton(
          onPressed: () {
            _completeMemorizeStep(cubit, ayah.ayahNumber);
          },
          child: Text(l10n.readyToRecite),
        );
      case SessionStage.reciting:
      case SessionStage.remediation:
      case SessionStage.blockReview:
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _evaluateRecitation(cubit, ayah.ayahNumber, 1.0);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: Text(l10n.iRecitedCorrectly, style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () {
                _evaluateRecitation(cubit, ayah.ayahNumber, 0.0);
              },
              child: Text(l10n.iNeedHelp),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _completeLearnStep(SessionCubit cubit, int ayahNumber) async {
    if (await cubit.completeLearnStep(ayahNumber)) {
      await cubit.advanceAfterCurrentAyah();
    }
  }

  Future<void> _completeMemorizeStep(
    SessionCubit cubit,
    int ayahNumber,
  ) async {
    if (await cubit.completeMemorizeStep(ayahNumber, 1)) {
      await cubit.advanceAfterCurrentAyah();
    }
  }

  Future<void> _evaluateRecitation(
    SessionCubit cubit,
    int ayahNumber,
    double score,
  ) async {
    if (await cubit.evaluateRecitation(ayahNumber, score)) {
      await cubit.advanceAfterCurrentAyah();
    }
  }
}
