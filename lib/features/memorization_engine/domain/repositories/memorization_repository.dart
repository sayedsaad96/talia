import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';

abstract class MemorizationRepository {
  ResultFuture<void> saveRecord(MemorizationRecordEntity record);
  ResultFuture<List<MemorizationRecordEntity>> getRecords(String userId);
  ResultFuture<MemorizationRecordEntity?> getRecord(
      String userId, int surahNumber, int ayahNumber);
  ResultFuture<void> updateRecord(MemorizationRecordEntity record);
}
