import 'package:dartz/dartz.dart';
import 'package:talia/core/error/exceptions.dart';
import 'package:talia/core/error/failures.dart';
import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:talia/features/quran/data/models/bookmark_model.dart';
import 'package:talia/features/quran/data/models/reading_progress_model.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';
import 'package:talia/features/quran/domain/entities/surah_entity.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource _localDataSource;

  const QuranRepositoryImpl(this._localDataSource);

  @override
  List<SurahEntity> getAllSurahs() {
    return _localDataSource.getAllSurahs();
  }

  @override
  ResultFuture<void> saveBookmark(BookmarkEntity bookmark) async {
    try {
      final model = BookmarkModel(
        id: bookmark.id,
        surahNumber: bookmark.surahNumber,
        ayahNumber: bookmark.ayahNumber,
        pageNumber: bookmark.pageNumber,
        surahName: bookmark.surahName,
        createdAt: bookmark.createdAt,
        note: bookmark.note,
      );
      await _localDataSource.saveBookmark(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<BookmarkEntity>> getBookmarks() async {
    try {
      final models = await _localDataSource.getBookmarks();
      return Right(models);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> deleteBookmark(String id) async {
    try {
      await _localDataSource.deleteBookmark(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> saveReadingProgress(ReadingProgressEntity progress) async {
    try {
      final model = ReadingProgressModel(
        lastSurahNumber: progress.lastSurahNumber,
        lastAyahNumber: progress.lastAyahNumber,
        lastPageNumber: progress.lastPageNumber,
        lastSurahName: progress.lastSurahName,
        updatedAt: progress.updatedAt,
      );
      await _localDataSource.saveReadingProgress(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<ReadingProgressEntity?> getReadingProgress() async {
    try {
      final model = await _localDataSource.getReadingProgress();
      return Right(model);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
