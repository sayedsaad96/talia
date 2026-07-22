import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

final class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.statusCode});
}

final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

final class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.statusCode});
}
