import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/features/quran/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }
    emit(const SearchLoading());
    try {
      final normalized = normalise(query.trim());
      final rawResults = searchWords(normalized);
      final resultList = (rawResults['result'] as List<dynamic>?) ?? [];
      if (resultList.isEmpty) {
        emit(SearchEmpty(query));
        return;
      }
      final results = resultList.map((item) {
        final map = item as Map<dynamic, dynamic>;
        final surah = (map['sora'] as num).toInt();
        final ayah = (map['aya_no'] as num).toInt();
        return SearchResult(
          surahNumber: surah,
          ayahNumber: ayah,
          text: map['text'] as String? ?? '',
          pageNumber: getPageNumber(surah, ayah),
        );
      }).toList();
      emit(SearchLoaded(results: results, query: query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clear() => emit(const SearchInitial());
}
