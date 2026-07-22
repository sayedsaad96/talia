import 'package:dartz/dartz.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class EvaluateRecitationUseCase {
  final SessionRepository _sessionRepository;
  final SessionEngine _sessionEngine;

  const EvaluateRecitationUseCase(
      this._sessionRepository, this._sessionEngine);

  ResultFuture<SessionEntity> call({
    required SessionEntity session,
    required int ayahNumber,
    required double similarityScore,
  }) async {
    try {
      final evaluated = _sessionEngine.evaluateRecitation(
          session, ayahNumber, similarityScore);
      await _sessionRepository.saveSession(evaluated);
      return Right(evaluated);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
