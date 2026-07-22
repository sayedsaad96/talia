import 'package:equatable/equatable.dart';

enum AyahStatus { notStarted, learning, memorizing, recited, failed, remediated, passed }

class AyahProgressEntity extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final AyahStatus status;
  final int hintLevel;           // 0=none, 1=firstWord, 2=fullVerse
  final double similarityScore;  // 0.0-1.0 from recitation evaluation
  final int attempts;
  final DateTime? lastAttemptAt;

  const AyahProgressEntity({
    required this.surahNumber,
    required this.ayahNumber,
    this.status = AyahStatus.notStarted,
    this.hintLevel = 0,
    this.similarityScore = 0.0,
    this.attempts = 0,
    this.lastAttemptAt,
  });

  bool get isPassed => status == AyahStatus.passed;
  bool get isFailed => status == AyahStatus.failed;
  bool get needsRemediation => status == AyahStatus.failed || status == AyahStatus.remediated;
  bool get usedHints => hintLevel > 0;

  AyahProgressEntity copyWith({
    AyahStatus? status,
    int? hintLevel,
    double? similarityScore,
    int? attempts,
    DateTime? lastAttemptAt,
  }) {
    return AyahProgressEntity(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      status: status ?? this.status,
      hintLevel: hintLevel ?? this.hintLevel,
      similarityScore: similarityScore ?? this.similarityScore,
      attempts: attempts ?? this.attempts,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  List<Object?> get props => [surahNumber, ayahNumber, status, hintLevel, similarityScore, attempts];
}
