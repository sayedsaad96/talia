// ignore_for_file: prefer_initializing_formals
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_progress_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_recommendations_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_active_session_use_case.dart';
import 'package:talia/features/kids_journey/presentation/cubit/kids_home_state.dart';

class KidsHomeCubit extends Cubit<KidsHomeState> {
  final GetRecommendationsUseCase _getRecommendations;
  final GetProgressUseCase _getProgress;
  final GetActiveSessionUseCase _getActiveSession;
  final AuthCubit _authCubit;

  KidsHomeCubit({
    required GetRecommendationsUseCase getRecommendations,
    required GetProgressUseCase getProgress,
    required GetActiveSessionUseCase getActiveSession,
    required AuthCubit authCubit,
  })  : _getRecommendations = getRecommendations,
        _getProgress = getProgress,
        _getActiveSession = getActiveSession,
        _authCubit = authCubit,
        super(const KidsHomeState());

  Future<void> loadKidsHome() async {
    emit(state.copyWith(status: KidsHomeStatus.loading));

    final authState = _authCubit.state;
    final userId = authState is Authenticated ? authState.user.id : 'guest';

    // Parallel fetch
    final results = await Future.wait([
      _getRecommendations(userId),
      _getProgress(userId),
      _getActiveSession(userId),
    ]);

    final recommendationsResult = results[0] as dynamic;
    final progressResult = results[1] as dynamic;
    final sessionResult = results[2] as dynamic;

    var recommendations = <dynamic>[];
    var progress = state.progress;
    var activeSession = state.activeSession;

    recommendationsResult.fold((l) => null, (r) => recommendations = r);
    progressResult.fold((l) => null, (r) {
      if (r != null) progress = r;
    });
    sessionResult.fold((l) => null, (r) => activeSession = r);

    // Mock Juz Progress for Map (1-30)
    // Real implementation would calculate this based on memorization records
    final juzProgress = List.generate(30, (index) {
      final juzNumber = index + 1;
      return JuzProgress(
        juzNumber: juzNumber,
        ayahsMemorized: index < 2
            ? 100
            : 0, // Mock: first two juz have some progress
        totalAyahs: 100, // Mock total
        isUnlocked: index <= 2, // Mock: up to Juz 3 unlocked
      );
    });

    emit(
      state.copyWith(
        status: KidsHomeStatus.loaded,
        recommendations: recommendations,
        progress: progress,
        activeSession: activeSession,
        juzProgress: juzProgress,
      ),
    );
  }
}
