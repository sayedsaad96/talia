import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talia/core/config/app_config.dart';
import 'package:talia/core/logging/app_logger.dart';
import 'package:talia/core/router/app_router.dart';

// Auth
import 'package:talia/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:talia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';
import 'package:talia/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:talia/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:talia/features/auth/domain/usecases/login_use_case.dart';
import 'package:talia/features/auth/domain/usecases/logout_use_case.dart';
import 'package:talia/features/auth/domain/usecases/register_use_case.dart';
import 'package:talia/features/auth/domain/usecases/watch_auth_state_use_case.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/login_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/register_cubit.dart';

// Quran
import 'package:talia/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:talia/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';
import 'package:talia/features/quran/domain/usecases/delete_bookmark_use_case.dart';
import 'package:talia/features/quran/domain/usecases/get_all_surahs_use_case.dart';
import 'package:talia/features/quran/domain/usecases/get_bookmarks_use_case.dart';
import 'package:talia/features/quran/domain/usecases/get_reading_progress_use_case.dart';
import 'package:talia/features/quran/domain/usecases/save_bookmark_use_case.dart';
import 'package:talia/features/quran/domain/usecases/save_reading_progress_use_case.dart';
import 'package:talia/features/quran/presentation/cubit/bookmark_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/reader_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/search_cubit.dart';

// Memorization Engine
import 'package:talia/features/memorization_engine/data/datasources/memorization_local_data_source.dart';
import 'package:talia/features/memorization_engine/data/repositories/memorization_repository_impl.dart';
import 'package:talia/features/memorization_engine/data/repositories/review_repository_impl.dart';
import 'package:talia/features/memorization_engine/data/repositories/session_repository_impl.dart';
import 'package:talia/features/memorization_engine/domain/engine/progress_calculator.dart';
import 'package:talia/features/memorization_engine/domain/engine/review_engine.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/engine/smart_coach.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';
import 'package:talia/features/memorization_engine/domain/usecases/advance_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/complete_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/evaluate_recitation_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_active_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_badges_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_due_reviews_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_progress_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/get_recommendations_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/start_session_use_case.dart';
import 'package:talia/features/memorization_engine/domain/usecases/submit_review_use_case.dart';

// Adult Journey
import 'package:talia/features/adult_journey/presentation/cubit/home_cubit.dart';
import 'package:talia/features/adult_journey/presentation/cubit/session_cubit.dart';
import 'package:talia/features/adult_journey/presentation/cubit/review_cubit.dart';
import 'package:talia/features/kids_journey/presentation/cubit/kids_home_cubit.dart';
import 'package:talia/features/progress/presentation/cubit/progress_cubit.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initializes all dependencies in the application.
///
/// Registration order: Configuration → Supabase → Core → Data Sources
///                     → Repositories → Use Cases → Cubits
///
/// Must be called before [runApp].
Future<void> initDependencies() async {
  // ──────────────────────────────────────────────
  // Phase 0: Configuration
  // ──────────────────────────────────────────────
  await AppConfig.init();
  AppLogger.i('AppConfig initialized');

  // ──────────────────────────────────────────────
  // Phase 1: Supabase
  // ──────────────────────────────────────────────
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );
  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );
  AppLogger.i('Supabase initialized');

  // ──────────────────────────────────────────────
  // Phase 0: Core Services
  // ──────────────────────────────────────────────
  sl.registerLazySingleton(() => AppRouter.router);

  // ──────────────────────────────────────────────
  // Phase 1: Auth — Data Sources
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  // ──────────────────────────────────────────────
  // Phase 2: Quran — Data Sources
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<QuranLocalDataSource>(
    () => QuranLocalDataSourceImpl(),
  );

  // ──────────────────────────────────────────────
  // Phase 3: Memorization Engine — Engines (pure logic singletons)
  // ──────────────────────────────────────────────
  sl.registerLazySingleton(() => SessionEngine());
  sl.registerLazySingleton(() => ReviewEngine());
  sl.registerLazySingleton(() => SmartCoach());
  sl.registerLazySingleton(() => ProgressCalculator());

  // ──────────────────────────────────────────────
  // Phase 3: Memorization Engine — Data Sources
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<MemorizationLocalDataSource>(
    () => MemorizationLocalDataSourceImpl(),
  );

  // ──────────────────────────────────────────────
  // Repositories
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<QuranRepository>(
    () => QuranRepositoryImpl(sl<QuranLocalDataSource>()),
  );

  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(sl<MemorizationLocalDataSource>()),
  );
  sl.registerLazySingleton<MemorizationRepository>(
    () => MemorizationRepositoryImpl(sl<MemorizationLocalDataSource>()),
  );
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(sl<MemorizationLocalDataSource>()),
  );

  // ──────────────────────────────────────────────
  // Phase 1: Auth — Use Cases
  // ──────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => WatchAuthStateUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));

  // ──────────────────────────────────────────────
  // Phase 2: Quran — Use Cases
  // ──────────────────────────────────────────────
  sl.registerLazySingleton(() => GetAllSurahsUseCase(sl<QuranRepository>()));
  sl.registerLazySingleton(() => SaveBookmarkUseCase(sl<QuranRepository>()));
  sl.registerLazySingleton(() => GetBookmarksUseCase(sl<QuranRepository>()));
  sl.registerLazySingleton(() => DeleteBookmarkUseCase(sl<QuranRepository>()));
  sl.registerLazySingleton(() => SaveReadingProgressUseCase(sl<QuranRepository>()));
  sl.registerLazySingleton(() => GetReadingProgressUseCase(sl<QuranRepository>()));

  // ──────────────────────────────────────────────
  // Phase 3: Memorization Engine — Use Cases
  // ──────────────────────────────────────────────
  sl.registerLazySingleton(
    () => StartSessionUseCase(sl<SessionRepository>(), sl<SessionEngine>()),
  );
  sl.registerLazySingleton(
    () => AdvanceSessionUseCase(sl<SessionRepository>(), sl<SessionEngine>()),
  );
  sl.registerLazySingleton(
    () => EvaluateRecitationUseCase(sl<SessionRepository>(), sl<SessionEngine>()),
  );
  sl.registerLazySingleton(
    () => CompleteSessionUseCase(
      sl<SessionRepository>(),
      sl<MemorizationRepository>(),
      sl<ReviewRepository>(),
      sl<SessionEngine>(),
      sl<ReviewEngine>(),
      sl<ProgressCalculator>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetActiveSessionUseCase(sl<SessionRepository>()),
  );
  sl.registerLazySingleton(
    () => SubmitReviewUseCase(
      sl<ReviewRepository>(),
      sl<MemorizationRepository>(),
      sl<ReviewEngine>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDueReviewsUseCase(sl<ReviewRepository>(), sl<ReviewEngine>()),
  );
  sl.registerLazySingleton(
    () => GetRecommendationsUseCase(
      sl<SessionRepository>(),
      sl<ReviewRepository>(),
      sl<MemorizationRepository>(),
      sl<SmartCoach>(),
      sl<ProgressCalculator>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetProgressUseCase(
      sl<MemorizationRepository>(),
      sl<ReviewRepository>(),
      sl<SessionRepository>(),
      sl<ProgressCalculator>(),
    ),
  );
  sl.registerLazySingleton(
    () => GetBadgesUseCase(sl<ReviewRepository>()),
  );

  // ──────────────────────────────────────────────
  // Phase 1: Auth — Cubits
  // ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getCurrentUser: sl<GetCurrentUserUseCase>(),
      logout: sl<LogoutUseCase>(),
      watchAuthState: sl<WatchAuthStateUseCase>(),
    ),
  );
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: sl<LoginUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
    ),
  );
  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(registerUseCase: sl<RegisterUseCase>()),
  );

  // ──────────────────────────────────────────────
  // Phase 2: Quran — Cubits
  // ──────────────────────────────────────────────
  sl.registerFactory<QuranCubit>(
    () => QuranCubit(sl<GetAllSurahsUseCase>()),
  );
  sl.registerFactory<ReaderCubit>(
    () => ReaderCubit(
      saveProgress: sl<SaveReadingProgressUseCase>(),
      getProgress: sl<GetReadingProgressUseCase>(),
    ),
  );
  sl.registerFactory<BookmarkCubit>(
    () => BookmarkCubit(
      getBookmarks: sl<GetBookmarksUseCase>(),
      saveBookmark: sl<SaveBookmarkUseCase>(),
      deleteBookmark: sl<DeleteBookmarkUseCase>(),
    ),
  );
  sl.registerFactory<SearchCubit>(() => SearchCubit());

  // ──────────────────────────────────────────────
  // Phase 4: Adult Journey — Cubits
  // ──────────────────────────────────────────────
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getRecommendations: sl<GetRecommendationsUseCase>(),
      getProgress: sl<GetProgressUseCase>(),
      getActiveSession: sl<GetActiveSessionUseCase>(),
      getDueReviews: sl<GetDueReviewsUseCase>(),
      authCubit: sl<AuthCubit>(),
    ),
  );
  sl.registerFactory<SessionCubit>(
    () => SessionCubit(
      startSession: sl<StartSessionUseCase>(),
      getActiveSession: sl<GetActiveSessionUseCase>(),
      advanceSession: sl<AdvanceSessionUseCase>(),
      evaluateRecitation: sl<EvaluateRecitationUseCase>(),
      completeSession: sl<CompleteSessionUseCase>(),
      sessionEngine: sl<SessionEngine>(),
      sessionRepository: sl<SessionRepository>(),
      authCubit: sl<AuthCubit>(),
    ),
  );
  sl.registerFactory<ReviewCubit>(
    () => ReviewCubit(
      getDueReviews: sl<GetDueReviewsUseCase>(),
      submitReview: sl<SubmitReviewUseCase>(),
      authCubit: sl<AuthCubit>(),
    ),
  );

  sl.registerFactory<KidsHomeCubit>(
    () => KidsHomeCubit(
      getRecommendations: sl<GetRecommendationsUseCase>(),
      getProgress: sl<GetProgressUseCase>(),
      getActiveSession: sl<GetActiveSessionUseCase>(),
      authCubit: sl<AuthCubit>(),
    ),
  );

  sl.registerFactory<ProgressCubit>(
    () => ProgressCubit(
      getProgress: sl<GetProgressUseCase>(),
      getBadges: sl<GetBadgesUseCase>(),
      memorizationRepository: sl<MemorizationRepository>(),
      authCubit: sl<AuthCubit>(),
    ),
  );

  AppLogger.i('Dependency injection initialization complete');
}
