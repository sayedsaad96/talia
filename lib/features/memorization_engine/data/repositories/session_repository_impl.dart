import 'package:dartz/dartz.dart';
import 'package:talia/core/error/exceptions.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/data/datasources/memorization_local_data_source.dart';
import 'package:talia/features/memorization_engine/data/models/session_model.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final MemorizationLocalDataSource _localDataSource;
  const SessionRepositoryImpl(this._localDataSource);

  @override
  ResultFuture<SessionEntity> createSession({
    required String userId,
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  }) async {
    try {
      final session = SessionModel(
        id: '${userId}_${surahNumber}_${startAyah}_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        surahNumber: surahNumber,
        startAyah: startAyah,
        endAyah: endAyah,
        createdAt: DateTime.now(),
      );
      await _localDataSource.saveSession(session);
      return Right(session);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<SessionEntity?> getActiveSession(String userId) async {
    try {
      final session = await _localDataSource.getActiveSession(userId);
      return Right(session);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> saveSession(SessionEntity session) async {
    try {
      await _localDataSource.saveSession(SessionModel.fromEntity(session));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<SessionEntity>> getCompletedSessions(
      String userId) async {
    try {
      final sessions =
          await _localDataSource.getCompletedSessions(userId);
      return Right(sessions);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
