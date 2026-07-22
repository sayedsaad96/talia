import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class GetReadingProgressUseCase {
  final QuranRepository _repository;
  const GetReadingProgressUseCase(this._repository);
  ResultFuture<ReadingProgressEntity?> call() => _repository.getReadingProgress();
}
