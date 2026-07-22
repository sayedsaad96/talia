import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/quran/presentation/cubit/bookmark_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/reader_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/reader_state.dart';
import 'package:talia/features/quran/presentation/widgets/reader_controls_bar.dart';

class QuranReaderPage extends StatefulWidget {
  final int initialSurahNumber;
  
  const QuranReaderPage({super.key, this.initialSurahNumber = 1});

  @override
  State<QuranReaderPage> createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  late final ReaderCubit _readerCubit;
  late final BookmarkCubit _bookmarkCubit;
  final PageController _pageController = PageController();
  final ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    _readerCubit = sl<ReaderCubit>();
    _bookmarkCubit = sl<BookmarkCubit>()..loadBookmarks();
    
    _initReader();
  }

  Future<void> _initReader() async {
    await _readerCubit.loadFonts();
    if (widget.initialSurahNumber > 1) {
      _readerCubit.navigateToSurah(widget.initialSurahNumber);
    } else {
      await _readerCubit.loadLastProgress();
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_readerCubit.state.currentPage - 1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _readerCubit.close();
    _bookmarkCubit.close();
    super.dispose();
  }

  void _showBookmarkDialog(int surah, int ayah, int page) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Bookmark'), // TODO: localize
        content: Text('Add bookmark at Surah ${getSurahNameArabic(surah)}, Ayah $ayah?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _bookmarkCubit.addBookmark(surahNumber: surah, ayahNumber: ayah);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _readerCubit),
        BlocProvider.value(value: _bookmarkCubit),
      ],
      child: BlocBuilder<ReaderCubit, ReaderState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: state.isDarkMode ? AppColors.darkBackground : AppColors.background,
            appBar: AppBar(
              title: Text(
                '${getSurahNameArabic(state.currentSurah)} - Juz ${getJuzNumber(state.currentSurah, state.currentAyah)}',
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                if (!state.isFontLoaded)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          const Text('جاري تحميل الخطوط...', style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 8),
                          Text('${(state.fontLoadProgress * 100).toInt()}%', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  )
                else if (state.mode == ReadingMode.mushaf)
                  QuranPageView(
                    pageController: _pageController,
                    highlights: _bookmarkCubit.highlights,
                    isDarkMode: state.isDarkMode,
                    isTajweed: state.isTajweed,
                    onPageChanged: _readerCubit.onPageChanged,
                    onLongPress: (surah, ayah, details) => _showBookmarkDialog(surah, ayah, getPageNumber(surah, ayah)),
                  )
                else
                  QuranSurahListView(
                    surahNumber: state.currentSurah,
                    itemScrollController: _scrollController,
                    highlights: _bookmarkCubit.highlights,
                    fontSize: state.fontSize,
                    isTajweed: state.isTajweed,
                    isDarkMode: state.isDarkMode,
                    ayahBuilder: (ctx, s, v, page, widget, isHighlighted, color) {
                      return InkWell(
                        onLongPress: () => _showBookmarkDialog(s, v, page),
                        child: widget,
                      );
                    },
                  ),
                
                // Controls Bar
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ReaderControlsBar(
                      state: state,
                      onToggleTajweed: _readerCubit.toggleTajweed,
                      onToggleMode: _readerCubit.toggleMode,
                      onDecreaseFontSize: _readerCubit.decreaseFontSize,
                      onIncreaseFontSize: _readerCubit.increaseFontSize,
                      onBookmark: () => _showBookmarkDialog(state.currentSurah, state.currentAyah, state.currentPage),
                      onClose: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
