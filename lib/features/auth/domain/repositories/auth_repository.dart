import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  ResultFuture<UserEntity> login({
    required String email,
    required String password,
  });

  ResultFuture<UserEntity> register({
    required String email,
    required String password,
    String? displayName,
  });

  ResultFuture<void> logout();

  ResultFuture<UserEntity?> getCurrentUser();

  Stream<UserEntity?> watchAuthState();

  ResultFuture<void> forgotPassword({required String email});
}
