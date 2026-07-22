import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class GetBookmarksUseCase {
  final QuranRepository _repository;
  const GetBookmarksUseCase(this._repository);
  ResultFuture<List<BookmarkEntity>> call() => _repository.getBookmarks();
}
