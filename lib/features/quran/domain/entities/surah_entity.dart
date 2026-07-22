import 'package:equatable/equatable.dart';

class SurahEntity extends Equatable {
  final int number;           // 1-114
  final String arabicName;    // الفاتحة
  final String englishName;   // Al-Faatiha
  final String transliteration; // Al-Faatiha
  final int verseCount;       // 7
  final String placeOfRevelation; // Makkah / Madinah

  const SurahEntity({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.transliteration,
    required this.verseCount,
    required this.placeOfRevelation,
  });

  bool get isMakki => placeOfRevelation.toLowerCase() == 'makkah';
  bool get isMadani => !isMakki;

  @override
  List<Object?> get props => [number];
}
