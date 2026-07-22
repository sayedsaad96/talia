import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';

/// Redirect function that protects authenticated routes.
///
/// Reads [AuthCubit] state to determine access:
/// - [Unauthenticated] on protected route → redirect to login
/// - [Authenticated] on auth route → redirect to home
/// - [AuthGuest] → allow only public routes
String? authGuard(BuildContext context, GoRouterState state) {
  final authState = context.read<AuthCubit>().state;
  final currentPath = state.matchedLocation;

  // Define route categories
  final isAuthRoute = currentPath == RouteNames.loginPath ||
      currentPath == RouteNames.registerPath;

  final isSplashRoute = currentPath == RouteNames.splashPath;
  final isOnboardingRoute = currentPath == RouteNames.onboardingPath;

  final isQuranRoute = currentPath == RouteNames.quranReaderPath ||
      currentPath == RouteNames.searchPath ||
      currentPath == RouteNames.bookmarksPath ||
      currentPath == '${RouteNames.quranReaderPath}/surahs';

  final isPublicRoute = isAuthRoute ||
      isSplashRoute ||
      isOnboardingRoute ||
      isQuranRoute;

  // During initial loading, don't redirect (splash handles navigation)
  if (authState is AuthInitial || authState is AuthLoading) {
    return null;
  }

  // Authenticated user trying to visit auth pages → send to home
  if (authState is Authenticated && (isAuthRoute || isOnboardingRoute)) {
    return RouteNames.homePath;
  }

  // Unauthenticated user trying to visit protected route → send to login
  if (authState is Unauthenticated && !isPublicRoute) {
    return RouteNames.loginPath;
  }

  // Guest user → allow only public routes + home (restricted)
  if (authState is AuthGuest) {
    if (!isPublicRoute && currentPath != RouteNames.homePath) {
      return RouteNames.homePath;
    }
  }

  return null;
}
