import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  ResultFuture<UserEntity> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
