import 'package:dartz/dartz.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/ayah_progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/engine/progress_calculator.dart';
import 'package:talia/features/memorization_engine/domain/engine/review_engine.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/review_repository.dart';
import 'package:talia/features/memorization_engine/domain/repositories/session_repository.dart';

/// Orchestrates session completion:
/// 1. Complete session via engine
/// 2. Create MemorizationRecords for passed ayahs
/// 3. Create initial ReviewSchedules
/// 4. Update streak
/// 5. Check badges
class CompleteSessionUseCase {
  final SessionRepository _sessionRepository;
  final MemorizationRepository _memorizationRepository;
  final ReviewRepository _reviewRepository;
  final SessionEngine _sessionEngine;
  final ReviewEngine _reviewEngine;
  final ProgressCalculator _progressCalculator;

  const CompleteSessionUseCase(
    this._sessionRepository,
    this._memorizationRepository,
    this._reviewRepository,
    this._sessionEngine,
    this._reviewEngine,
    this._progressCalculator,
  );

  ResultFuture<SessionEntity> call(SessionEntity session) async {
    try {
      final completed = _sessionEngine.completeSession(session);
      await _saveCompletedSession(completed);
      await _createRecordsAndSchedules(completed);
      await _updateStreak(completed.userId);
      await _updateBadges(completed.userId);

      return Right(completed);
    } on StateError catch (error) {
      return Left(UnexpectedFailure(message: error.message));
    } on ArgumentError catch (error) {
      return Left(UnexpectedFailure(message: error.message?.toString() ?? 'Invalid session'));
    } catch (error) {
      return Left(UnexpectedFailure(message: error.toString()));
    }
  }

  Future<void> _saveCompletedSession(SessionEntity completed) async {
    _readOrThrow(await _sessionRepository.saveSession(completed));
  }

  Future<void> _createRecordsAndSchedules(SessionEntity completed) async {
    for (final ayah in completed.ayahProgress.where((ayah) => ayah.isPassed)) {
      final record = MemorizationRecordEntity(
        id: '${completed.userId}_${ayah.surahNumber}_${ayah.ayahNumber}',
        userId: completed.userId,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        qualityScore: _calculateQuality(ayah),
        totalAttempts: ayah.attempts,
        memorizedAt: DateTime.now(),
        lastReviewedAt: DateTime.now(),
      );
      _readOrThrow(await _memorizationRepository.saveRecord(record));
      _readOrThrow(
        await _reviewRepository.saveSchedule(
          _reviewEngine.createInitialSchedule(record),
        ),
      );
    }
  }

  Future<void> _updateStreak(String userId) async {
    final streak = _readOrThrow(await _reviewRepository.getStreak(userId));
    final updated = _progressCalculator.updateStreak(streak, DateTime.now());
    _readOrThrow(await _reviewRepository.saveStreak(userId, updated));
  }

  Future<void> _updateBadges(String userId) async {
    final records = _readOrThrow(await _memorizationRepository.getRecords(userId));
    final streak = _readOrThrow(await _reviewRepository.getStreak(userId));
    final badges = _readOrThrow(await _reviewRepository.getBadges(userId));
    final sessions = _readOrThrow(await _sessionRepository.getCompletedSessions(userId));
    final totalXp = sessions.fold(0, (sum, session) => sum + session.xpEarned);
    final progress = _progressCalculator.calculateProgress(records, streak, totalXp);
    final updatedBadges = _progressCalculator.checkBadges(progress, badges);
    for (final badge in updatedBadges.where((badge) => badge.isUnlocked)) {
      _readOrThrow(await _reviewRepository.saveBadge(userId, badge));
    }
  }

  T _readOrThrow<T>(Either<Failure, T> outcome) {
    return outcome.fold(
      (failure) => throw StateError(failure.message),
      (resolved) => resolved,
    );
  }

  double _calculateQuality(AyahProgressEntity ayah) {
    double quality = ayah.similarityScore;
    if (ayah.hintLevel == 1) quality *= 0.8;
    if (ayah.hintLevel == 2) quality *= 0.5;
    return quality.clamp(0.0, 1.0).toDouble();
  }
}
