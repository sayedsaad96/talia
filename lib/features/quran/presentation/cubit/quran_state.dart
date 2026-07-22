import 'package:equatable/equatable.dart';
import 'package:talia/features/quran/domain/entities/surah_entity.dart';

sealed class QuranState extends Equatable {
  const QuranState();
  @override List<Object?> get props => [];
}
final class QuranInitial extends QuranState { const QuranInitial(); }
final class QuranLoading extends QuranState { const QuranLoading(); }
final class QuranLoaded extends QuranState {
  final List<SurahEntity> surahs;
  const QuranLoaded(this.surahs);
  @override List<Object?> get props => [surahs];
}
final class QuranError extends QuranState {
  final String message;
  const QuranError(this.message);
  @override List<Object?> get props => [message];
}
