import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_active_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_due_reviews_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_progress_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_recommendations_use_case.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/progress_entity.dart';
import 'package:talia/features/adult_journey/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetRecommendationsUseCase _getRecommendations;
  final GetProgressUseCase _getProgress;
  final GetActiveSessionUseCase _getActiveSession;
  final GetDueReviewsUseCase _getDueReviews;
  final AuthCubit _authCubit;

  HomeCubit({
    required this._getRecommendations,
    required this._getProgress,
    required this._getActiveSession,
    required this._getDueReviews,
    required this._authCubit,
  }) : super(const HomeState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final authState = _authCubit.state;
    final userId = authState is Authenticated ? authState.user.id : 'guest';

    // Fetch everything in parallel
    final results = await Future.wait([
      _getRecommendations(userId),
      _getProgress(userId),
      _getActiveSession(userId),
      _getDueReviews(userId),
    ]);

    final recommendationsResult = results[0] as dynamic;
    final progressResult = results[1] as dynamic;
    final activeSessionResult = results[2] as dynamic;
    final dueReviewsResult = results[3] as dynamic;

    var recommendations = <dynamic>[];
    ProgressEntity? progress;
    SessionEntity? activeSession;
    var dueReviewsCount = 0;

    recommendationsResult.fold((l) => null, (r) => recommendations = r);
    progressResult.fold((l) => null, (r) => progress = r);
    activeSessionResult.fold((l) => null, (r) => activeSession = r);
    dueReviewsResult.fold((l) => null, (r) => dueReviewsCount = r.length);

    emit(
      state.copyWith(
        status: HomeStatus.loaded,
        recommendations: recommendations.cast(),
        progress: progress,
        activeSession: activeSession,
        dueReviewsCount: dueReviewsCount,
      ),
    );
  }
}
