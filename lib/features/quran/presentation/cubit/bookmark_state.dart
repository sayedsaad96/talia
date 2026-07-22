import 'package:equatable/equatable.dart';
import 'package:talia/features/quran/domain/entities/bookmark_entity.dart';

sealed class BookmarkState extends Equatable {
  const BookmarkState();
  @override List<Object?> get props => [];
}
final class BookmarkInitial extends BookmarkState { const BookmarkInitial(); }
final class BookmarkLoading extends BookmarkState { const BookmarkLoading(); }
final class BookmarkLoaded extends BookmarkState {
  final List<BookmarkEntity> bookmarks;
  const BookmarkLoaded(this.bookmarks);
  @override List<Object?> get props => [bookmarks];
}
final class BookmarkError extends BookmarkState {
  final String message;
  const BookmarkError(this.message);
  @override List<Object?> get props => [message];
}
