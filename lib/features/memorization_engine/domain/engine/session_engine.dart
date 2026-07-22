import 'package:talia/features/memorization_engine/domain/entities/ayah_progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/xp_config.dart';

/// The Session Engine implements the fixed 6-stage memorization lifecycle.
/// Created → Learning → Memorizing → Reciting → Remediation → Block Review → Completed
///
/// Pure business logic — no UI, no Flutter, no persistence.
class SessionEngine {
  static const double _recitationPassThreshold = 0.7;

  /// Create initial ayah progress entries for a new session.
  SessionEntity initializeSession(SessionEntity session) {
    if (session.totalAyahs <= 0) {
      throw StateError('Session end ayah must not precede its start ayah');
    }

    final progress = List.generate(
      session.totalAyahs,
      (i) => AyahProgressEntity(
        surahNumber: session.surahNumber,
        ayahNumber: session.startAyah + i,
      ),
    );
    return session.copyWith(
      stage: SessionStage.learning,
      ayahProgress: progress,
    );
  }

  /// Advance to the next stage if the current stage is complete.
  SessionEntity advanceStage(SessionEntity session) {
    if (session.isCompleted) {
      throw StateError('Cannot advance a completed session');
    }
    if (!isStageComplete(session)) {
      throw StateError('Current stage is not complete: ${session.stage}');
    }

    switch (session.stage) {
      case SessionStage.created:
        return initializeSession(session);
      case SessionStage.learning:
        return session.copyWith(stage: SessionStage.memorizing);
      case SessionStage.memorizing:
        return session.copyWith(stage: SessionStage.reciting);
      case SessionStage.reciting:
        final hasFailed = session.ayahProgress.any((a) => a.isFailed);
        return hasFailed
            ? session.copyWith(stage: SessionStage.remediation)
            : _startBlockReview(session);
      case SessionStage.remediation:
        return _startBlockReview(session);
      case SessionStage.blockReview:
        final hasNewFailures = session.ayahProgress.any((a) => a.isFailed);
        if (hasNewFailures) {
          return session.copyWith(stage: SessionStage.remediation);
        }
        return completeSession(session);
      case SessionStage.completed:
        throw StateError('Session is already completed');
    }
  }

  /// Mark an ayah as learned (learning stage).
  SessionEntity completeLearnStep(SessionEntity session, int ayahNumber) {
    _assertStage(session, SessionStage.learning);
    return _updateAyahProgress(
      session,
      ayahNumber,
      (ayah) => ayah.copyWith(status: AyahStatus.learning),
    );
  }

  /// Mark an ayah's memorization attempt (with optional hint).
  SessionEntity completeMemorizeStep(
    SessionEntity session,
    int ayahNumber,
    int hintLevel,
  ) {
    _assertStage(session, SessionStage.memorizing);
    if (hintLevel < 0 || hintLevel > 2) {
      throw ArgumentError.value(hintLevel, 'hintLevel', 'Must be between 0 and 2');
    }
    return _updateAyahProgress(
      session,
      ayahNumber,
      (ayah) => ayah.copyWith(
        status: AyahStatus.memorizing,
        hintLevel: hintLevel,
        attempts: ayah.attempts + 1,
        lastAttemptAt: DateTime.now(),
      ),
    );
  }

  /// Evaluate a recitation attempt. Pass/fail based on similarity threshold.
  SessionEntity evaluateRecitation(
    SessionEntity session,
    int ayahNumber,
    double similarityScore,
  ) {
    if (session.stage != SessionStage.reciting &&
        session.stage != SessionStage.remediation &&
        session.stage != SessionStage.blockReview) {
      throw StateError(
          'Cannot evaluate recitation in stage: ${session.stage}');
    }
    if (similarityScore < 0 || similarityScore > 1) {
      throw ArgumentError.value(
        similarityScore,
        'similarityScore',
        'Must be between 0 and 1',
      );
    }

    final passed = similarityScore >= _recitationPassThreshold;
    return _updateAyahProgress(
      session,
      ayahNumber,
      (ayah) => ayah.copyWith(
        status: passed ? AyahStatus.passed : AyahStatus.failed,
        similarityScore: similarityScore,
        attempts: ayah.attempts + 1,
        lastAttemptAt: DateTime.now(),
      ),
    );
  }

  /// Complete block review — evaluate all ayahs.
  SessionEntity completeBlockReview(
    SessionEntity session,
    Map<int, double> ayahScores,
  ) {
    _assertStage(session, SessionStage.blockReview);
    final updated = session.ayahProgress.map((a) {
      final score = ayahScores[a.ayahNumber];
      if (score == null) return a;
      final passed = score >= _recitationPassThreshold;
      return a.copyWith(
        status: passed ? AyahStatus.passed : AyahStatus.failed,
        similarityScore: score,
        attempts: a.attempts + 1,
        lastAttemptAt: DateTime.now(),
      );
    }).toList();
    return session.copyWith(ayahProgress: updated);
  }

  /// Finalize session — calculate XP, mark completed.
  SessionEntity completeSession(SessionEntity session) {
    _assertStage(session, SessionStage.blockReview);
    if (session.ayahProgress.any((ayah) => !ayah.isPassed)) {
      throw StateError('All ayahs must pass block review before completion');
    }

    int xp = 0;
    for (final ayah in session.ayahProgress) {
      if (ayah.isPassed) {
        xp += XpConfig.ayahXp(ayah.hintLevel);
        if (ayah.similarityScore >= 0.95) {
          xp += XpConfig.perfectRecitation;
        }
      }
    }
    xp += XpConfig.blockReviewBonus;

    return session.copyWith(
      stage: SessionStage.completed,
      completedAt: DateTime.now(),
      xpEarned: xp,
    );
  }

  /// Check if all ayahs in the current stage are done.
  bool isStageComplete(SessionEntity session) {
    switch (session.stage) {
      case SessionStage.created:
        return true;
      case SessionStage.learning:
        return session.ayahProgress.every((a) => a.status == AyahStatus.learning);
      case SessionStage.memorizing:
        return session.ayahProgress
            .every((a) => a.status == AyahStatus.memorizing);
      case SessionStage.reciting:
        return session.ayahProgress.every(
            (a) => a.status == AyahStatus.passed || a.status == AyahStatus.failed);
      case SessionStage.remediation:
        return !session.ayahProgress.any((a) => a.status == AyahStatus.failed);
      case SessionStage.blockReview:
        return session.ayahProgress.every(
            (a) => a.status == AyahStatus.passed || a.status == AyahStatus.failed);
      case SessionStage.completed:
        return true;
    }
  }

  /// Returns the next ayah that needs user input in the current stage.
  int? nextActionableAyahIndex(
    SessionEntity session, {
    int afterIndex = -1,
  }) {
    final progress = session.ayahProgress;
    if (progress.isEmpty) return null;

    for (var offset = 1; offset <= progress.length; offset++) {
      final index = (afterIndex + offset) % progress.length;
      if (_needsAction(session.stage, progress[index].status)) return index;
    }
    return null;
  }

  SessionEntity _startBlockReview(SessionEntity session) {
    return session.copyWith(
      stage: SessionStage.blockReview,
      ayahProgress: session.ayahProgress
          .map((ayah) => ayah.copyWith(status: AyahStatus.recited))
          .toList(),
    );
  }

  bool _needsAction(SessionStage stage, AyahStatus status) {
    switch (stage) {
      case SessionStage.created:
      case SessionStage.completed:
        return false;
      case SessionStage.learning:
        return status == AyahStatus.notStarted;
      case SessionStage.memorizing:
        return status == AyahStatus.learning;
      case SessionStage.reciting:
        return status == AyahStatus.memorizing;
      case SessionStage.remediation:
        return status == AyahStatus.failed;
      case SessionStage.blockReview:
        return status == AyahStatus.recited;
    }
  }

  void _assertStage(SessionEntity session, SessionStage expected) {
    if (session.stage != expected) {
      throw StateError('Expected stage $expected but got ${session.stage}');
    }
  }

  SessionEntity _updateAyahProgress(
    SessionEntity session,
    int ayahNumber,
    AyahProgressEntity Function(AyahProgressEntity) updater,
  ) {
    if (!session.ayahProgress.any((ayah) => ayah.ayahNumber == ayahNumber)) {
      throw ArgumentError.value(ayahNumber, 'ayahNumber', 'Not in this session');
    }
    final updated = session.ayahProgress.map((a) {
      if (a.ayahNumber == ayahNumber) return updater(a);
      return a;
    }).toList();
    return session.copyWith(ayahProgress: updated);
  }
}
