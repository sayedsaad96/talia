import 'package:equatable/equatable.dart';
import 'package:talia/features/memorization_engine/domain/entities/ayah_progress_entity.dart';

enum SessionStage { created, learning, memorizing, reciting, remediation, blockReview, completed }

class SessionEntity extends Equatable {
  final String id;
  final String userId;
  final int surahNumber;
  final int startAyah;
  final int endAyah;
  final SessionStage stage;
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<AyahProgressEntity> ayahProgress;
  final int xpEarned;

  const SessionEntity({
    required this.id,
    required this.userId,
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
    this.stage = SessionStage.created,
    required this.createdAt,
    this.completedAt,
    this.ayahProgress = const [],
    this.xpEarned = 0,
  });

  bool get isCompleted => stage == SessionStage.completed;
  bool get isActive => !isCompleted;
  int get totalAyahs => endAyah - startAyah + 1;
  String get surahAyahRange => '$surahNumber:$startAyah-$endAyah';

  /// Returns ayah progress for a specific ayah, or null if not found.
  AyahProgressEntity? getAyahProgress(int ayahNumber) {
    try {
      return ayahProgress.firstWhere((a) => a.ayahNumber == ayahNumber);
    } catch (_) {
      return null;
    }
  }

  /// Count of ayahs in a specific status.
  int countByStatus(AyahStatus status) =>
      ayahProgress.where((a) => a.status == status).length;

  SessionEntity copyWith({
    SessionStage? stage,
    DateTime? completedAt,
    List<AyahProgressEntity>? ayahProgress,
    int? xpEarned,
  }) {
    return SessionEntity(
      id: id,
      userId: userId,
      surahNumber: surahNumber,
      startAyah: startAyah,
      endAyah: endAyah,
      stage: stage ?? this.stage,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      ayahProgress: ayahProgress ?? this.ayahProgress,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }

  @override
  List<Object?> get props => [id, stage, ayahProgress, xpEarned];
}
