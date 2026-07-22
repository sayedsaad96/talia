import 'package:equatable/equatable.dart';

enum ReadingMode { mushaf, surah }

final class ReaderState extends Equatable {
  final int currentPage;      // 1-604 (Mushaf mode)
  final int currentSurah;     // 1-114
  final int currentAyah;      // 1-N
  final bool isTajweed;
  final bool isDarkMode;
  final double fontSize;
  final ReadingMode mode;
  final bool isFontLoaded;
  final double fontLoadProgress;

  const ReaderState({
    this.currentPage = 1,
    this.currentSurah = 1,
    this.currentAyah = 1,
    this.isTajweed = true,
    this.isDarkMode = false,
    this.fontSize = 25.0,
    this.mode = ReadingMode.mushaf,
    this.isFontLoaded = false,
    this.fontLoadProgress = 0.0,
  });

  ReaderState copyWith({
    int? currentPage,
    int? currentSurah,
    int? currentAyah,
    bool? isTajweed,
    bool? isDarkMode,
    double? fontSize,
    ReadingMode? mode,
    bool? isFontLoaded,
    double? fontLoadProgress,
  }) {
    return ReaderState(
      currentPage: currentPage ?? this.currentPage,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      isTajweed: isTajweed ?? this.isTajweed,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontSize: fontSize ?? this.fontSize,
      mode: mode ?? this.mode,
      isFontLoaded: isFontLoaded ?? this.isFontLoaded,
      fontLoadProgress: fontLoadProgress ?? this.fontLoadProgress,
    );
  }

  @override
  List<Object?> get props => [
        currentPage, currentSurah, currentAyah, isTajweed,
        isDarkMode, fontSize, mode, isFontLoaded, fontLoadProgress
      ];
}
