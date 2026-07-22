import 'package:talia/core/utils/typedefs.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';

class BookmarkModel extends BookmarkEntity {
  const BookmarkModel({
    required super.id,
    required super.surahNumber,
    required super.ayahNumber,
    required super.pageNumber,
    required super.surahName,
    required super.createdAt,
    super.note,
  });

  factory BookmarkModel.fromJson(DataMap json) {
    return BookmarkModel(
      id: json['id'] as String,
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      pageNumber: json['page_number'] as int,
      surahName: json['surah_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      note: json['note'] as String?,
    );
  }

  DataMap toJson() => {
    'id': id,
    'surah_number': surahNumber,
    'ayah_number': ayahNumber,
    'page_number': pageNumber,
    'surah_name': surahName,
    'created_at': createdAt.toIso8601String(),
    'note': note,
  };
}
