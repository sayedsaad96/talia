import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class DeleteBookmarkUseCase {
  final QuranRepository _repository;
  const DeleteBookmarkUseCase(this._repository);
  ResultFuture<void> call(String id) => _repository.deleteBookmark(id);
}
