import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

abstract class SessionRepository {
  ResultFuture<SessionEntity> createSession({
    required String userId,
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  });

  ResultFuture<SessionEntity?> getActiveSession(String userId);
  ResultFuture<void> saveSession(SessionEntity session);
  ResultFuture<List<SessionEntity>> getCompletedSessions(String userId);
}
