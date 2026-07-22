import 'package:dartz/dartz.dart';
import 'package:talia/core/error/exceptions.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/memorization_engine/data/datasources/memorization_local_data_source.dart';
import 'package:talia/features/memorization_engine/data/models/memorization_record_model.dart';
import 'package:talia/features/memorization_engine/domain/entities/memorization_record_entity.dart';
import 'package:talia/features/memorization_engine/domain/repositories/memorization_repository.dart';

class MemorizationRepositoryImpl implements MemorizationRepository {
  final MemorizationLocalDataSource _localDataSource;
  const MemorizationRepositoryImpl(this._localDataSource);

  @override
  ResultFuture<void> saveRecord(MemorizationRecordEntity record) async {
    try {
      await _localDataSource
          .saveRecord(MemorizationRecordModel.fromEntity(record));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<MemorizationRecordEntity>> getRecords(
      String userId) async {
    try {
      final records = await _localDataSource.getRecords(userId);
      return Right(records);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<MemorizationRecordEntity?> getRecord(
      String userId, int surahNumber, int ayahNumber) async {
    try {
      final record = await _localDataSource.getRecord(
          userId, surahNumber, ayahNumber);
      return Right(record);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> updateRecord(MemorizationRecordEntity record) async {
    try {
      await _localDataSource
          .updateRecord(MemorizationRecordModel.fromEntity(record));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
