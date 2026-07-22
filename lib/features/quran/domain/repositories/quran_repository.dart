import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';
import 'package:talia/features/quran/domain/entities/surah_entity.dart';

abstract class QuranRepository {
  /// Returns all 114 surahs from the local data source.
  List<SurahEntity> getAllSurahs();

  /// Saves a bookmark to local storage.
  ResultFuture<void> saveBookmark(BookmarkEntity bookmark);

  /// Retrieves all saved bookmarks, sorted by createdAt descending.
  ResultFuture<List<BookmarkEntity>> getBookmarks();

  /// Deletes a bookmark by its [id].
  ResultFuture<void> deleteBookmark(String id);

  /// Persists the current reading position.
  ResultFuture<void> saveReadingProgress(ReadingProgressEntity progress);

  /// Retrieves the last saved reading position, or null if never read.
  ResultFuture<ReadingProgressEntity?> getReadingProgress();
}
