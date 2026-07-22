import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  ResultFuture<UserEntity> call({required String email, required String password, String? displayName}) {
    return _repository.register(email: email, password: password, displayName: displayName);
  }
}
