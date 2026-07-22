import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';
import 'package:talia/features/quran/domain/usecases/get_reading_progress_use_case.dart';
import 'package:talia/features/quran/domain/usecases/save_reading_progress_use_case.dart';
import 'package:talia/features/quran/presentation/cubit/reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  final SaveReadingProgressUseCase _saveProgress;
  final GetReadingProgressUseCase _getProgress;

  ReaderCubit({
    required this._saveProgress,
    required this._getProgress,
  })  : super(const ReaderState());

  Future<void> loadLastProgress() async {
    final result = await _getProgress();
    result.fold(
      (_) {},
      (progress) {
        if (progress != null) {
          emit(state.copyWith(
            currentPage: progress.lastPageNumber,
            currentSurah: progress.lastSurahNumber,
            currentAyah: progress.lastAyahNumber,
          ));
        }
      },
    );
  }

  Future<void> loadFonts() async {
    await QcfFontLoader.setupFontsAtStartup(
      onProgress: (progress) {
        emit(state.copyWith(fontLoadProgress: progress));
      },
    );
    emit(state.copyWith(isFontLoaded: true, fontLoadProgress: 1.0));
  }

  void navigateToSurah(int surahNumber) {
    final page = getPageNumber(surahNumber, 1);
    emit(state.copyWith(
      currentPage: page,
      currentSurah: surahNumber,
      currentAyah: 1,
    ));
    _persistProgress(surahNumber, 1, page);
  }

  void onPageChanged(int pageNumber) {
    emit(state.copyWith(currentPage: pageNumber));
    // Persist after page change (debounce could be added)
    _persistProgress(state.currentSurah, state.currentAyah, pageNumber);
  }

  void onAyahVisible(int surah, int ayah) {
    final page = getPageNumber(surah, ayah);
    emit(state.copyWith(currentSurah: surah, currentAyah: ayah, currentPage: page));
    _persistProgress(surah, ayah, page);
  }

  void toggleTajweed() => emit(state.copyWith(isTajweed: !state.isTajweed));
  void toggleDarkMode() => emit(state.copyWith(isDarkMode: !state.isDarkMode));
  void toggleMode() => emit(state.copyWith(
        mode: state.mode == ReadingMode.mushaf ? ReadingMode.surah : ReadingMode.mushaf));
  void increaseFontSize() => emit(state.copyWith(fontSize: (state.fontSize + 2).clamp(16, 40)));
  void decreaseFontSize() => emit(state.copyWith(fontSize: (state.fontSize - 2).clamp(16, 40)));

  void _persistProgress(int surah, int ayah, int page) {
    _saveProgress(ReadingProgressEntity(
      lastSurahNumber: surah,
      lastAyahNumber: ayah,
      lastPageNumber: page,
      lastSurahName: getSurahNameArabic(surah),
      updatedAt: DateTime.now(),
    ));
  }
}
