import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class SaveBookmarkUseCase {
  final QuranRepository _repository;
  const SaveBookmarkUseCase(this._repository);
  ResultFuture<void> call(BookmarkEntity bookmark) => _repository.saveBookmark(bookmark);
}
