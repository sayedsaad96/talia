import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/features/quran/presentation/cubit/search_cubit.dart';
import 'package:talia/features/quran/presentation/cubit/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late final SearchCubit _searchCubit;

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchCubit.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchCubit.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchCubit,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search the Holy Quran...', // TODO: localize
              border: InputBorder.none,
            ),
            onChanged: _onSearchChanged,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchCubit.clear();
              },
            ),
          ],
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: AppColors.textSecondary),
                    SizedBox(height: 16),
                    Text('Search the Holy Quran', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              );
            } else if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchEmpty) {
              return Center(child: Text('No results found for "${state.query}"'));
            } else if (state is SearchError) {
              return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
            } else if (state is SearchLoaded) {
              return ListView.builder(
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final result = state.results[index];
                  return ListTile(
                    title: Text(
                      getSurahNameArabic(result.surahNumber),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      textDirection: TextDirection.rtl,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ayah ${result.ayahNumber} · Page ${result.pageNumber}'), // TODO: localize
                        const SizedBox(height: 4),
                        Text(
                          result.text,
                          style: const TextStyle(fontSize: 16),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                    onTap: () {
                      context.push(RouteNames.quranReaderPath, extra: result.surahNumber);
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
