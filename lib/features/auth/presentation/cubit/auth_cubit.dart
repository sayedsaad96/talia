import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';
import 'package:talia/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:talia/features/auth/domain/usecases/logout_use_case.dart';
import 'package:talia/features/auth/domain/usecases/watch_auth_state_use_case.dart';
import 'package:talia/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;
  final WatchAuthStateUseCase _watchAuthState;

  StreamSubscription<UserEntity?>? _authSubscription;

  AuthCubit({
    required this._getCurrentUser,
    required this._logout,
    required this._watchAuthState,
  })  : super(const AuthInitial());

  /// Check if user has existing session on app start.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(const Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
          _startWatchingAuthState();
        } else {
          emit(const Unauthenticated());
        }
      },
    );
  }

  /// Enter guest mode — restricted access.
  void continueAsGuest() {
    emit(const AuthGuest());
  }

  /// Sign out and clear session.
  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await _logout();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        _authSubscription?.cancel();
        emit(const Unauthenticated());
      },
    );
  }

  /// Called after successful login/register to update global state.
  void userAuthenticated(UserEntity user) {
    emit(Authenticated(user));
    _startWatchingAuthState();
  }

  void _startWatchingAuthState() {
    _authSubscription?.cancel();
    _authSubscription = _watchAuthState().listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const Unauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
