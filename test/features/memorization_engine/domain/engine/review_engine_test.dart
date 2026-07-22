import 'package:flutter_test/flutter_test.dart';
import 'package:talia/features/memorization_engine/domain/engine/review_engine.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/entities/review_result_entity.dart';

void main() {
  final reviewEngine = ReviewEngine();

  group('ReviewEngine', () {
    test('preserves the record owner in its initial review schedule', () {
      final schedule = reviewEngine.createInitialSchedule(_createRecord());

      expect(schedule.userId, 'user-id');
    });

    test('adjusts confidence in the direction of the review outcome', () {
      final lowerConfidence =
          reviewEngine.updateConfidence(0.6, ReviewQuality.forgot);
      final higherConfidence =
          reviewEngine.updateConfidence(0.6, ReviewQuality.easy);

      expect(lowerConfidence, lessThan(0.6));
      expect(higherConfidence, greaterThan(0.6));
    });
  });
}

MemorizationRecordEntity _createRecord() {
  return MemorizationRecordEntity(
    id: 'user-id_1_1',
    userId: 'user-id',
    surahNumber: 1,
    ayahNumber: 1,
    qualityScore: 1,
    totalAttempts: 1,
    memorizedAt: DateTime(2026),
    lastReviewedAt: DateTime(2026),
  );
}
