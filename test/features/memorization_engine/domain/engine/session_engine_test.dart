import 'package:flutter_test/flutter_test.dart';
import 'package:talia/features/memorization_engine/domain/engine/session_engine.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

void main() {
  final sessionEngine = SessionEngine();

  group('SessionEngine', () {
    test('rejects a session whose ayah range is reversed', () {
      final invalidSession = _createSession(startAyah: 5, endAyah: 4);

      expect(
        () => sessionEngine.initializeSession(invalidSession),
        throwsStateError,
      );
    });

    test('returns failed block-review ayahs to remediation', () {
      var activeSession = _prepareForBlockReview(sessionEngine);

      activeSession = sessionEngine.evaluateRecitation(activeSession, 1, 0.0);
      activeSession = sessionEngine.evaluateRecitation(activeSession, 2, 1.0);
      final remediatingSession = sessionEngine.advanceStage(activeSession);

      expect(remediatingSession.stage, SessionStage.remediation);
      expect(
        sessionEngine.nextActionableAyahIndex(remediatingSession),
        0,
      );
      expect(remediatingSession.ayahProgress[1].isPassed, isTrue);
    });

    test('completes only after every block-review ayah passes', () {
      var activeSession = _prepareForBlockReview(sessionEngine);

      activeSession = sessionEngine.evaluateRecitation(activeSession, 1, 1.0);
      activeSession = sessionEngine.evaluateRecitation(activeSession, 2, 1.0);
      final completedSession = sessionEngine.completeSession(activeSession);

      expect(completedSession.stage, SessionStage.completed);
      expect(completedSession.xpEarned, greaterThan(0));
    });
  });
}

SessionEntity _prepareForBlockReview(SessionEngine sessionEngine) {
  var activeSession = sessionEngine.initializeSession(_createSession());
  activeSession = sessionEngine.completeLearnStep(activeSession, 1);
  activeSession = sessionEngine.completeLearnStep(activeSession, 2);
  activeSession = sessionEngine.advanceStage(activeSession);
  activeSession = sessionEngine.completeMemorizeStep(activeSession, 1, 0);
  activeSession = sessionEngine.completeMemorizeStep(activeSession, 2, 0);
  activeSession = sessionEngine.advanceStage(activeSession);
  activeSession = sessionEngine.evaluateRecitation(activeSession, 1, 1.0);
  activeSession = sessionEngine.evaluateRecitation(activeSession, 2, 1.0);
  return sessionEngine.advanceStage(activeSession);
}

SessionEntity _createSession({int startAyah = 1, int endAyah = 2}) {
  return SessionEntity(
    id: 'session-id',
    userId: 'user-id',
    surahNumber: 1,
    startAyah: startAyah,
    endAyah: endAyah,
    createdAt: DateTime(2026),
  );
}
