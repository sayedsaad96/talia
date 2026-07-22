import 'package:equatable/equatable.dart';

class ReadingProgressEntity extends Equatable {
  final int lastSurahNumber;  // 1-114
  final int lastAyahNumber;   // 1-N
  final int lastPageNumber;   // 1-604
  final String lastSurahName; // For display
  final DateTime updatedAt;

  const ReadingProgressEntity({
    required this.lastSurahNumber,
    required this.lastAyahNumber,
    required this.lastPageNumber,
    required this.lastSurahName,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [lastSurahNumber, lastAyahNumber, lastPageNumber];
}
