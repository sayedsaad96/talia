import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/router/auth_guard.dart';
import 'package:talia/features/auth/presentation/pages/splash_page.dart';
import 'package:talia/features/auth/presentation/pages/onboarding_page.dart';
import 'package:talia/features/auth/presentation/pages/login_page.dart';
import 'package:talia/features/auth/presentation/pages/register_page.dart';
import 'package:talia/features/quran/presentation/cubit/bookmark_cubit.dart';
import 'package:talia/features/adult_journey/presentation/pages/smart_home_page.dart';
import 'package:talia/features/adult_journey/presentation/pages/session_setup_page.dart';
import 'package:talia/features/adult_journey/presentation/pages/session_page.dart';
import 'package:talia/features/adult_journey/presentation/pages/session_complete_page.dart';
import 'package:talia/features/adult_journey/presentation/pages/review_page.dart';
import 'package:talia/features/adult_journey/presentation/pages/weak_ayahs_page.dart';
import 'package:talia/features/kids_journey/presentation/pages/kids_home_page.dart';
import 'package:talia/features/kids_journey/presentation/pages/kids_mission_page.dart';
import 'package:talia/features/kids_journey/presentation/pages/kids_session_page.dart';
import 'package:talia/features/kids_journey/presentation/pages/kids_reward_page.dart';
import 'package:talia/features/quran/presentation/pages/surah_list_page.dart';
import 'package:talia/features/quran/presentation/pages/quran_reader_page.dart';
import 'package:talia/features/quran/presentation/pages/search_page.dart';
import 'package:talia/features/quran/presentation/pages/bookmarks_page.dart';
import 'package:talia/features/progress/presentation/pages/progress_page.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splashPath,
    debugLogDiagnostics: true,
    redirect: authGuard,
    routes: [
      // ── Auth Routes ──────────────────────────────────
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.onboardingPath,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),

      // ── Main App Routes ───────────────────────────────
      GoRoute(
        path: RouteNames.homePath,
        name: RouteNames.home,
        builder: (context, state) => const SmartHomePage(),
      ),

      // ── Quran Routes (share a BookmarkCubit) ──────────
      ShellRoute(
        builder: (context, state, child) => BlocProvider<BookmarkCubit>(
          create: (_) => sl<BookmarkCubit>()..loadBookmarks(),
          child: child,
        ),
        routes: [
          GoRoute(
            path: RouteNames.quranReaderPath,
            name: RouteNames.quranReader,
            builder: (context, state) {
              final surahNumber = (state.extra as int?) ?? 1;
              return QuranReaderPage(initialSurahNumber: surahNumber);
            },
          ),
          GoRoute(
            path: RouteNames.searchPath,
            name: RouteNames.search,
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: RouteNames.bookmarksPath,
            name: RouteNames.bookmarks,
            builder: (context, state) => const BookmarksPage(),
          ),
        ],
      ),

      // ── Surah List (standalone, gets own BookmarkCubit) ──
      GoRoute(
        path: '${RouteNames.quranReaderPath}/surahs',
        name: '${RouteNames.quranReader}-surahs',
        builder: (context, state) => const SurahListPage(),
      ),

      // ── Phase 4: Adult Journey ───────────────────────
      GoRoute(
        path: RouteNames.sessionSetupPath,
        name: RouteNames.sessionSetup,
        builder: (context, state) => const SessionSetupPage(),
      ),
      GoRoute(
        path: RouteNames.sessionActivePath,
        name: RouteNames.sessionActive,
        builder: (context, state) {
          final surahNumber = (state.extra as Map<String, dynamic>?)?['surah'] ?? 1;
          final startAyah = (state.extra as Map<String, dynamic>?)?['start'] ?? 1;
          final endAyah = (state.extra as Map<String, dynamic>?)?['end'] ?? 1;
          return SessionPage(
            surahNumber: surahNumber,
            startAyah: startAyah,
            endAyah: endAyah,
          );
        },
      ),
      GoRoute(
        path: RouteNames.sessionCompletePath,
        name: RouteNames.sessionComplete,
        builder: (context, state) => const SessionCompletePage(),
      ),
      GoRoute(
        path: RouteNames.reviewPath,
        name: RouteNames.review,
        builder: (context, state) => const ReviewPage(),
      ),
      GoRoute(
        path: RouteNames.weakAyahsPath,
        name: RouteNames.weakAyahs,
        builder: (context, state) => const WeakAyahsPage(),
      ),

      // ── Phase 5: Kids Journey ────────────────────────
      GoRoute(
        path: RouteNames.kidsHomePath,
        name: RouteNames.kidsHome,
        builder: (context, state) => const KidsHomePage(),
      ),
      GoRoute(
        path: RouteNames.kidsMissionPath,
        name: RouteNames.kidsMission,
        builder: (context, state) {
          final juz = (state.extra as int?) ?? 1;
          return KidsMissionPage(juzNumber: juz);
        },
      ),
      GoRoute(
        path: RouteNames.kidsSessionPath,
        name: RouteNames.kidsSession,
        builder: (context, state) {
          final surahNumber = (state.extra as Map<String, dynamic>?)?['surah'] ?? 1;
          return KidsSessionPage(surahNumber: surahNumber);
        },
      ),
      GoRoute(
        path: RouteNames.kidsRewardPath,
        name: RouteNames.kidsReward,
        builder: (context, state) => const KidsRewardPage(),
      ),

      // ── Placeholder Routes (future phases) ───────────
      GoRoute(
        path: RouteNames.memorizationPath,
        name: RouteNames.memorization,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Memorization'),
      ),
      GoRoute(
        path: RouteNames.progressPath,
        name: RouteNames.progress,
        builder: (context, state) => const ProgressPage(),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Settings'),
      ),
      GoRoute(
        path: RouteNames.parentDashboardPath,
        name: RouteNames.parentDashboard,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Parent Dashboard'),
      ),
      GoRoute(
        path: RouteNames.azkarPath,
        name: RouteNames.azkar,
        builder: (context, state) => const _PlaceholderPage(title: 'Azkar'),
      ),
      GoRoute(
        path: RouteNames.digitalRosaryPath,
        name: RouteNames.digitalRosary,
        builder: (context, state) =>
            const _PlaceholderPage(title: 'Digital Rosary'),
      ),
    ],
  );
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
