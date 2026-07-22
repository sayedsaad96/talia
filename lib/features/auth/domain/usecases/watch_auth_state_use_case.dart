import 'package:talia/features/auth/domain/entities/user_entity.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository _repository;

  const WatchAuthStateUseCase(this._repository);

  Stream<UserEntity?> call() {
    return _repository.watchAuthState();
  }
}
