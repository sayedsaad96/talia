import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_badges_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_progress_use_case.dart';
import 'package:talia/features/progress/presentation/cubit/progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final GetProgressUseCase _getProgress;
  final GetBadgesUseCase _getBadges;
  final MemorizationRepository _memorizationRepository;
  final AuthCubit _authCubit;

  ProgressCubit({
    required this._getProgress,
    required this._getBadges,
    required this._memorizationRepository,
    required this._authCubit,
  }) : super(const ProgressState());

  Future<void> loadDashboard() async {
    final authState = _authCubit.state;
    if (authState is! Authenticated) {
      emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: 'User not logged in',
        ),
      );
      return;
    }
    final userId = authState.user.id;

    emit(state.copyWith(status: ProgressStatus.loading));

    final progressResult = await _getProgress(userId);
    final badgesResult = await _getBadges(userId);
    final recordsResult = await _memorizationRepository.getRecords(userId);

    // Group records by day for the heatmap
    final Map<DateTime, int> activityMap = {};
    recordsResult.fold(
      (l) => null, // Ignore failures for heatmap processing
      (records) {
        for (final record in records) {
          final date = DateTime(
            record.memorizedAt.year,
            record.memorizedAt.month,
            record.memorizedAt.day,
          );
          activityMap[date] = (activityMap[date] ?? 0) + 1;
        }
      },
    );

    progressResult.fold(
      (failure) => emit(
        state.copyWith(
          status: ProgressStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (progress) {
        final badges = badgesResult.fold((l) => <dynamic>[], (r) => r);
        emit(
          state.copyWith(
            status: ProgressStatus.loaded,
            progress: progress,
            badges: List.from(badges),
            dailyActivity: activityMap,
          ),
        );
      },
    );
  }
}
