import 'dart:convert';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talia/core/error/exceptions.dart';
import 'package:talia/features/quran/data/models/bookmark_model.dart';
import 'package:talia/features/quran/data/models/reading_progress_model.dart';
import 'package:talia/features/quran/data/models/surah_model.dart';

abstract class QuranLocalDataSource {
  List<SurahModel> getAllSurahs();
  Future<void> saveBookmark(BookmarkModel bookmark);
  Future<List<BookmarkModel>> getBookmarks();
  Future<void> deleteBookmark(String id);
  Future<void> saveReadingProgress(ReadingProgressModel progress);
  Future<ReadingProgressModel?> getReadingProgress();
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  static const String _bookmarksKey = 'quran_bookmarks';
  static const String _progressKey = 'quran_reading_progress';

  @override
  List<SurahModel> getAllSurahs() {
    return List.generate(114, (index) {
      final number = index + 1;
      return SurahModel(
        number: number,
        arabicName: getSurahNameArabic(number),
        englishName: getSurahNameEnglish(number),
        transliteration: getSurahNameEnglish(number),
        verseCount: getVerseCount(number),
        placeOfRevelation: getPlaceOfRevelation(number),
      );
    });
  }

  @override
  Future<void> saveBookmark(BookmarkModel bookmark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getBookmarks();
      // Remove if already bookmarked at same location
      existing.removeWhere(
          (b) => b.surahNumber == bookmark.surahNumber && b.ayahNumber == bookmark.ayahNumber);
      existing.insert(0, bookmark); // Most recent first
      final encoded = existing.map((b) => jsonEncode(b.toJson())).toList();
      await prefs.setStringList(_bookmarksKey, encoded);
    } catch (e) {
      throw CacheException(message: 'Failed to save bookmark: $e');
    }
  }

  @override
  Future<List<BookmarkModel>> getBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getStringList(_bookmarksKey) ?? [];
      return encoded
          .map((e) => BookmarkModel.fromJson(jsonDecode(e) as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to load bookmarks: $e');
    }
  }

  @override
  Future<void> deleteBookmark(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existing = await getBookmarks();
      existing.removeWhere((b) => b.id == id);
      final encoded = existing.map((b) => jsonEncode(b.toJson())).toList();
      await prefs.setStringList(_bookmarksKey, encoded);
    } catch (e) {
      throw CacheException(message: 'Failed to delete bookmark: $e');
    }
  }

  @override
  Future<void> saveReadingProgress(ReadingProgressModel progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_progressKey, jsonEncode(progress.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to save reading progress: $e');
    }
  }

  @override
  Future<ReadingProgressModel?> getReadingProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_progressKey);
      if (stored == null) return null;
      return ReadingProgressModel.fromJson(jsonDecode(stored) as Map<String, dynamic>);
    } catch (e) {
      throw CacheException(message: 'Failed to load reading progress: $e');
    }
  }
}
