import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/ayah_progress_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/session_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.id,
    required super.userId,
    required super.surahNumber,
    required super.startAyah,
    required super.endAyah,
    super.stage,
    required super.createdAt,
    super.completedAt,
    super.ayahProgress,
    super.xpEarned,
  });

  factory SessionModel.fromJson(DataMap json) {
    return SessionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      surahNumber: json['surah_number'] as int,
      startAyah: json['start_ayah'] as int,
      endAyah: json['end_ayah'] as int,
      stage: SessionStage.values.firstWhere(
        (s) => s.name == (json['stage'] as String),
        orElse: () => SessionStage.created,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      ayahProgress: (json['ayah_progress'] as List<dynamic>? ?? [])
          .map((e) => _ayahFromJson(e as Map<String, dynamic>))
          .toList(),
      xpEarned: (json['xp_earned'] as int?) ?? 0,
    );
  }

  DataMap toJson() => {
        'id': id,
        'user_id': userId,
        'surah_number': surahNumber,
        'start_ayah': startAyah,
        'end_ayah': endAyah,
        'stage': stage.name,
        'created_at': createdAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'ayah_progress': ayahProgress.map(_ayahToJson).toList(),
        'xp_earned': xpEarned,
      };

  static SessionModel fromEntity(SessionEntity entity) {
    return SessionModel(
      id: entity.id,
      userId: entity.userId,
      surahNumber: entity.surahNumber,
      startAyah: entity.startAyah,
      endAyah: entity.endAyah,
      stage: entity.stage,
      createdAt: entity.createdAt,
      completedAt: entity.completedAt,
      ayahProgress: entity.ayahProgress,
      xpEarned: entity.xpEarned,
    );
  }

  static AyahProgressEntity _ayahFromJson(Map<String, dynamic> json) {
    return AyahProgressEntity(
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      status: AyahStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String),
        orElse: () => AyahStatus.notStarted,
      ),
      hintLevel: (json['hint_level'] as int?) ?? 0,
      similarityScore:
          (json['similarity_score'] as num?)?.toDouble() ?? 0.0,
      attempts: (json['attempts'] as int?) ?? 0,
      lastAttemptAt: json['last_attempt_at'] != null
          ? DateTime.parse(json['last_attempt_at'] as String)
          : null,
    );
  }

  static Map<String, dynamic> _ayahToJson(AyahProgressEntity ayah) => {
        'surah_number': ayah.surahNumber,
        'ayah_number': ayah.ayahNumber,
        'status': ayah.status.name,
        'hint_level': ayah.hintLevel,
        'similarity_score': ayah.similarityScore,
        'attempts': ayah.attempts,
        'last_attempt_at': ayah.lastAttemptAt?.toIso8601String(),
      };
}
