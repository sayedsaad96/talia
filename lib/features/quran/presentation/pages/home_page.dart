import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/quran/domain/entities/reading_progress_entity.dart';
import 'package:talia/features/quran/domain/usecases/get_reading_progress_use_case.dart';
import 'package:talia/features/quran/presentation/widgets/last_read_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ReadingProgressEntity?> _progressFuture;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  void _loadProgress() {
    final useCase = sl<GetReadingProgressUseCase>();
    _progressFuture = useCase().then((result) => result.fold((l) => null, (r) => r));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talia / تاليا', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          IconButton(icon: const Icon(Icons.logout), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Good morning, Guest', // TODO: dynamic greeting
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.lg),
              FutureBuilder<ReadingProgressEntity?>(
                future: _progressFuture,
                builder: (context, snapshot) {
                  return LastReadCard(
                    progress: snapshot.data,
                    onTap: () {
                      if (snapshot.data != null) {
                        context.push(RouteNames.quranReaderPath, extra: snapshot.data!.lastSurahNumber);
                      } else {
                        context.push(RouteNames.quranReaderPath);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Quran',
                      Icons.menu_book,
                      () => context.push(RouteNames.quranReaderPath),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Search',
                      Icons.search,
                      () => context.push(RouteNames.searchPath), // Ensure route exists
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildActionCard(
                      context,
                      'Bookmarks',
                      Icons.bookmark,
                      () => context.push(RouteNames.bookmarksPath), // Ensure route exists
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              const Center(
                child: Text(
                  'Phase 4: Smart Coach coming soon',
                  style: TextStyle(color: AppColors.secondary, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
