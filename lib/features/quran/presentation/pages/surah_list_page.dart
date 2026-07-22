import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/quran/presentation/cubit/quran_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/quran_state.dart';
import 'package:talia/features/quran/presentation/widgets/surah_list_tile.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuranCubit>()..loadSurahs(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('القرآن الكريم', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push(RouteNames.searchPath), // TODO: verify route name
            ),
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () => context.push(RouteNames.bookmarksPath), // TODO: verify route name
            ),
          ],
        ),
        body: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state is QuranLoading || state is QuranInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuranError) {
              return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
            } else if (state is QuranLoaded) {
              return ListView.builder(
                itemCount: state.surahs.length,
                itemBuilder: (context, index) {
                  final surah = state.surahs[index];
                  return SurahListTile(
                    surah: surah,
                    onTap: (selectedSurah) {
                      context.push(RouteNames.quranReaderPath, extra: selectedSurah.number);
                    },
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
