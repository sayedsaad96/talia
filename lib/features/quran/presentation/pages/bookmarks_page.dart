import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/quran/presentation/cubit/bookmark_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/bookmark_state.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late final BookmarkCubit _bookmarkCubit;

  @override
  void initState() {
    super.initState();
    _bookmarkCubit = sl<BookmarkCubit>()..loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookmarkCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks / المفضلة'), // TODO: localize
          centerTitle: true,
        ),
        body: BlocBuilder<BookmarkCubit, BookmarkState>(
          builder: (context, state) {
            if (state is BookmarkLoading || state is BookmarkInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookmarkError) {
              return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
            } else if (state is BookmarkLoaded) {
              if (state.bookmarks.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark, size: 64, color: AppColors.secondary),
                      SizedBox(height: 16),
                      Text('No bookmarks yet', style: TextStyle(color: AppColors.textSecondary)), // TODO: localize
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = state.bookmarks[index];
                  return Dismissible(
                    key: Key(bookmark.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: AppColors.error,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      _bookmarkCubit.deleteBookmark(bookmark.id);
                    },
                    child: ListTile(
                      title: Text(
                        bookmark.surahName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Text('Ayah ${bookmark.ayahNumber} · Page ${bookmark.pageNumber}\n${bookmark.createdAt.toString().split(' ')[0]}'), // TODO: localize
                      isThreeLine: true,
                      onTap: () {
                        context.push(RouteNames.quranReaderPath, extra: bookmark.surahNumber);
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
