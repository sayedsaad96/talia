import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  ResultFuture<void> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
