import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';

class ReadingProgressModel extends ReadingProgressEntity {
  const ReadingProgressModel({
    required super.lastSurahNumber,
    required super.lastAyahNumber,
    required super.lastPageNumber,
    required super.lastSurahName,
    required super.updatedAt,
  });

  factory ReadingProgressModel.fromJson(DataMap json) {
    return ReadingProgressModel(
      lastSurahNumber: json['last_surah_number'] as int,
      lastAyahNumber: json['last_ayah_number'] as int,
      lastPageNumber: json['last_page_number'] as int,
      lastSurahName: json['last_surah_name'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  DataMap toJson() => {
    'last_surah_number': lastSurahNumber,
    'last_ayah_number': lastAyahNumber,
    'last_page_number': lastPageNumber,
    'last_surah_name': lastSurahName,
    'updated_at': updatedAt.toIso8601String(),
  };
}
