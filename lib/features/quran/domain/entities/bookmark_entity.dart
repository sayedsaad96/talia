import 'package:equatable/equatable.dart';

class BookmarkEntity extends Equatable {
  final String id;           // UUID
  final int surahNumber;     // 1-114
  final int ayahNumber;      // 1-N
  final int pageNumber;      // 1-604
  final String surahName;    // For display
  final DateTime createdAt;
  final String? note;

  const BookmarkEntity({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.surahName,
    required this.createdAt,
    this.note,
  });

  @override
  List<Object?> get props => [id];
}
