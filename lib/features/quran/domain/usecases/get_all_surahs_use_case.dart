import 'package:talia/features/quran/domain/entities/surah_entity.dart';
import 'package:talia/features/quran/domain/repositories/quran_repository.dart';

class GetAllSurahsUseCase {
  final QuranRepository _repository;
  const GetAllSurahsUseCase(this._repository);
  List<SurahEntity> call() => _repository.getAllSurahs();
}
