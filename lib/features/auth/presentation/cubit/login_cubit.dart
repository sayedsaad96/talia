import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/auth/domain/usecases/login_use_case.dart';
import 'package:talia/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:talia/features/auth/presentation/cubit/login_state.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  // Store last logged in user for AuthCubit to pick up
  UserEntity? lastLoggedInUser;

  LoginCubit({
    required this._loginUseCase,
    required this._forgotPasswordUseCase,
  })  : super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());
    final result = await _loginUseCase(email: email, password: password);
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (user) {
        lastLoggedInUser = user;
        emit(const LoginSuccess());
      },
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(const ForgotPasswordLoading());
    final result = await _forgotPasswordUseCase(email: email);
    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.message)),
      (_) => emit(const ForgotPasswordSuccess()),
    );
  }
}
