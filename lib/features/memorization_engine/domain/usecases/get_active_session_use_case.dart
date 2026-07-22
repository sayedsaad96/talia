import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class GetActiveSessionUseCase {
  final SessionRepository _sessionRepository;
  const GetActiveSessionUseCase(this._sessionRepository);

  ResultFuture<SessionEntity?> call(String userId) =>
      _sessionRepository.getActiveSession(userId);
}
