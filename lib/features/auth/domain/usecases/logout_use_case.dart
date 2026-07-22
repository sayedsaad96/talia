import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  ResultFuture<void> call() {
    return _repository.logout();
  }
}
