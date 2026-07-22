import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/surah_entity.dart';

class SurahModel extends SurahEntity {
  const SurahModel({
    required super.number,
    required super.arabicName,
    required super.englishName,
    required super.transliteration,
    required super.verseCount,
    required super.placeOfRevelation,
  });

  factory SurahModel.fromJson(DataMap json) {
    return SurahModel(
      number: json['number'] as int,
      arabicName: json['arabic_name'] as String,
      englishName: json['english_name'] as String,
      transliteration: json['transliteration'] as String,
      verseCount: json['verse_count'] as int,
      placeOfRevelation: json['place_of_revelation'] as String,
    );
  }

  DataMap toJson() => {
    'number': number,
    'arabic_name': arabicName,
    'english_name': englishName,
    'transliteration': transliteration,
    'verse_count': verseCount,
    'place_of_revelation': placeOfRevelation,
  };
}
