import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final int pageNumber;

  const SearchResult({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.pageNumber,
  });
  @override List<Object?> get props => [surahNumber, ayahNumber];
}

sealed class SearchState extends Equatable {
  const SearchState();
  @override List<Object?> get props => [];
}
final class SearchInitial extends SearchState { const SearchInitial(); }
final class SearchLoading extends SearchState { const SearchLoading(); }
final class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final String query;
  const SearchLoaded({required this.results, required this.query});
  @override List<Object?> get props => [results, query];
}
final class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);
  @override List<Object?> get props => [query];
}
final class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override List<Object?> get props => [message];
}
