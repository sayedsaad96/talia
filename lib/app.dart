import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/router/app_router.dart';
import 'package:talia/core/theme/app_theme.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';

/// Root widget of the Talia application.
///
/// Provides [AuthCubit] at the top level so the auth guard and all
/// descendants can read auth state. Uses [MaterialApp.router] with
/// GoRouter for declarative navigation.
class TaliaApp extends StatelessWidget {
  const TaliaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: sl<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp.router(
        title: 'Talia',
        debugShowCheckedModeBanner: false,

        // ── Routing ──
        routerConfig: AppRouter.router,

        // ── Theme ──
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,

        // ── Localization ──
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: null, // Follow system locale
      ),
    );
  }
}
