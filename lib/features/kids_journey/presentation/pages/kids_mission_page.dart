import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/features/kids_journey/presentation/widgets/mission_card.dart';

class KidsMissionPage extends StatelessWidget {
  final int juzNumber;

  const KidsMissionPage({super.key, required this.juzNumber});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Get Surahs in this Juz using qcf_quran_plus
    // For simplicity, we mock this based on Juz number for the UI build
    // In reality we would map Surahs that start/end in this Juz
    final mockSurahs = _getMockSurahsForJuz(juzNumber);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.kidsZone(juzNumber)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: mockSurahs.length,
        itemBuilder: (context, index) {
          final surah = mockSurahs[index];
          return MissionCard(
            surahNumber: surah['number'] as int,
            surahName: surah['name'] as String,
            earnedStars: surah['stars'] as int,
            isUnlocked: surah['unlocked'] as bool,
            onTap: () {
              context.push(RouteNames.kidsSessionPath, extra: {'surah': surah['number']});
            },
          );
        },
      ),
    );
  }

  // Helper mock to quickly get something on screen for a Juz
  List<Map<String, dynamic>> _getMockSurahsForJuz(int juz) {
    if (juz == 30) {
      return [
        {'number': 78, 'name': 'An-Naba', 'stars': 3, 'unlocked': true},
        {'number': 79, 'name': 'An-Nazi\'at', 'stars': 2, 'unlocked': true},
        {'number': 80, 'name': 'Abasa', 'stars': 0, 'unlocked': true},
        {'number': 81, 'name': 'At-Takwir', 'stars': 0, 'unlocked': false},
      ];
    } else if (juz == 1) {
      return [
        {'number': 1, 'name': 'Al-Fatihah', 'stars': 3, 'unlocked': true},
        {'number': 2, 'name': 'Al-Baqarah', 'stars': 1, 'unlocked': true},
      ];
    }
    return [
      {'number': 3, 'name': 'Ali \'Imran', 'stars': 0, 'unlocked': true},
    ];
  }
}
