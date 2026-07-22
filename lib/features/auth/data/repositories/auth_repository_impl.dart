import 'package:dartz/dartz.dart';
import 'package:talia/core/error/exceptions.dart' as app;
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<UserEntity> login({required String email, required String password}) async {
    try {
      final user = await _remoteDataSource.signInWithEmail(email, password);
      return Right(user);
    } on app.AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on app.ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<UserEntity> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmail(email, password, displayName);
      return Right(user);
    } on app.AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on app.ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on app.ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  ResultFuture<UserEntity?> getCurrentUser() async {
    try {
      final user = _remoteDataSource.getCurrentUser();
      return Right(user);
    } on app.ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<UserEntity?> watchAuthState() {
    return _remoteDataSource.onAuthStateChange();
  }

  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      await _remoteDataSource.sendPasswordReset(email);
      return const Right(null);
    } on app.AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on app.ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
