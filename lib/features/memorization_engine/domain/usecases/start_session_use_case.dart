import 'package:dartz/dartz.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class StartSessionUseCase {
  final SessionRepository _sessionRepository;
  final SessionEngine _sessionEngine;

  const StartSessionUseCase(this._sessionRepository, this._sessionEngine);

  ResultFuture<SessionEntity> call({
    required String userId,
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  }) async {
    final result = await _sessionRepository.createSession(
      userId: userId,
      surahNumber: surahNumber,
      startAyah: startAyah,
      endAyah: endAyah,
    );
    return result.fold(
      Left.new,
      (session) {
        final initialized = _sessionEngine.initializeSession(session);
        _sessionRepository.saveSession(initialized);
        return Right(initialized);
      },
    );
  }
}
