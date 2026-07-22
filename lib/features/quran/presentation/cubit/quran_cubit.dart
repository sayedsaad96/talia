import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talia/features/quran/domain/usecases/get_all_surahs_use_case.dart';
import 'package:talia/features/quran/presentation/cubit/quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final GetAllSurahsUseCase _getAllSurahs;
  QuranCubit(this._getAllSurahs) : super(const QuranInitial());

  void loadSurahs() {
    emit(const QuranLoading());
    try {
      final surahs = _getAllSurahs();
      emit(QuranLoaded(surahs));
    } catch (e) {
      emit(QuranError(e.toString()));
    }
  }
}
