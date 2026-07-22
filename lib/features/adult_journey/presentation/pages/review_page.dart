import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/adult_journey/presentation/cubit/review_cubit.dart';
import 'package:talia/features/adult_journey/presentation/cubit/review_state.dart';
import 'package:talia/features/adult_journey/presentation/widgets/ayah_display_card.dart';
import 'package:talia/features/adult_journey/presentation/widgets/review_quality_selector.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReviewCubit>(
      create: (_) => sl<ReviewCubit>()..loadDueReviews(),
      child: const _ReviewView(),
    );
  }
}

class _ReviewView extends StatefulWidget {
  const _ReviewView();

  @override
  State<_ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<_ReviewView> {
  bool _isReciting = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dueReviews),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state.status == ReviewStatus.completed) {
            // Can go to a completion screen, but back home is fine for now
            context.pushReplacement(RouteNames.homePath);
          } else if (state.status == ReviewStatus.active) {
            // Reset to reciting state for the new review
            setState(() {
              _isReciting = true;
            });
          }
        },
        builder: (context, state) {
          if (state.status == ReviewStatus.initial || state.status == ReviewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ReviewStatus.error) {
            return Center(child: Text(state.errorMessage ?? l10n.error));
          }
          if (state.dueReviews.isEmpty || state.status == ReviewStatus.completed) {
            return Center(child: Text('No due reviews!'));
          }

          final review = state.currentReview!;
          
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(
                  value: (state.currentIndex) / state.dueReviews.length,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${state.currentIndex + 1} of ${state.dueReviews.length} reviews',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                AyahDisplayCard(
                  surahNumber: review.surahNumber,
                  ayahNumber: review.ayahNumber,
                  hintLevel: _isReciting ? 0 : 2, // Hidden while reciting, full text after evaluating
                ),
                const Spacer(),
                if (_isReciting)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isReciting = false;
                      });
                    },
                    child: const Text('Show Answer'),
                  )
                else
                  ReviewQualitySelector(
                    onSelected: (quality) {
                      context.read<ReviewCubit>().submitReview(quality, 1.0); // 1.0 is dummy similarity
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
