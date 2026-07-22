import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/entities/user_entity.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  const GetCurrentUserUseCase(this._repository);

  ResultFuture<UserEntity?> call() {
    return _repository.getCurrentUser();
  }
}
