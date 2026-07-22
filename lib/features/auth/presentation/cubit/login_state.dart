import 'package:equatable/equatable.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess();
}

final class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
  @override
  List<Object?> get props => [message];
}

final class ForgotPasswordLoading extends LoginState {
  const ForgotPasswordLoading();
}

final class ForgotPasswordSuccess extends LoginState {
  const ForgotPasswordSuccess();
}

final class ForgotPasswordFailure extends LoginState {
  final String message;
  const ForgotPasswordFailure(this.message);
  @override
  List<Object?> get props => [message];
}
