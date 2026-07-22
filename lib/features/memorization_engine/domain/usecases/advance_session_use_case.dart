import 'package:dartz/dartz.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class AdvanceSessionUseCase {
  final SessionRepository _sessionRepository;
  final SessionEngine _sessionEngine;

  const AdvanceSessionUseCase(this._sessionRepository, this._sessionEngine);

  ResultFuture<SessionEntity> call(SessionEntity session) async {
    try {
      final advanced = _sessionEngine.advanceStage(session);
      await _sessionRepository.saveSession(advanced);
      return Right(advanced);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
