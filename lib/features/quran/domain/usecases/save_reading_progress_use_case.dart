import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class SaveReadingProgressUseCase {
  final QuranRepository _repository;
  const SaveReadingProgressUseCase(this._repository);
  ResultFuture<void> call(ReadingProgressEntity progress) => _repository.saveReadingProgress(progress);
}
