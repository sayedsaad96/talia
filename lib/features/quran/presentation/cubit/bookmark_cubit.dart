import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';
import 'package:talia/features/quran/domain/usecases/delete_bookmark_use_case.dart';
import 'package:talia/features/quran/domain/usecases/get_bookmarks_use_case.dart';
import 'package:talia/features/quran/domain/usecases/save_bookmark_use_case.dart';
import 'package:talia/features/quran/presentation/cubit/bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final GetBookmarksUseCase _getBookmarks;
  final SaveBookmarkUseCase _saveBookmark;
  final DeleteBookmarkUseCase _deleteBookmark;

  BookmarkCubit({
    required this._getBookmarks,
    required this._saveBookmark,
    required this._deleteBookmark,
  })  : super(const BookmarkInitial());

  Future<void> loadBookmarks() async {
    emit(const BookmarkLoading());
    final result = await _getBookmarks();
    result.fold(
      (failure) => emit(BookmarkError(failure.message)),
      (bookmarks) => emit(BookmarkLoaded(bookmarks)),
    );
  }

  Future<void> addBookmark({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final page = getPageNumber(surahNumber, ayahNumber);
    final bookmark = BookmarkEntity(
      id: '${surahNumber}_${ayahNumber}_${DateTime.now().millisecondsSinceEpoch}',
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      pageNumber: page,
      surahName: getSurahNameArabic(surahNumber),
      createdAt: DateTime.now(),
    );
    await _saveBookmark(bookmark);
    await loadBookmarks();
  }

  Future<void> deleteBookmark(String id) async {
    await _deleteBookmark(id);
    await loadBookmarks();
  }

  /// Returns highlight list for current bookmarks (for QuranPageView)
  List<HighlightVerse> get highlights {
    if (state is! BookmarkLoaded) return [];
    return (state as BookmarkLoaded).bookmarks.map((b) =>
      HighlightVerse(
        surah: b.surahNumber,
        verseNumber: b.ayahNumber,
        page: b.pageNumber,
        color: const Color(0x66C9A44C), // Gold with opacity
      )
    ).toList();
  }
}
