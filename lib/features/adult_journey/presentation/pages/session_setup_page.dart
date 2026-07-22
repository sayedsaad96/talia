import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qcf_quran_plus/qcf_quran_plus.dart';
import 'package:talia/core/router/route_names.dart';
import 'package:talia/core/theme/app_colors.dart';
import 'package:talia/core/theme/app_spacing.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';

class SessionSetupPage extends StatefulWidget {
  const SessionSetupPage({super.key});

  @override
  State<SessionSetupPage> createState() => _SessionSetupPageState();
}

class _SessionSetupPageState extends State<SessionSetupPage> {
  int _selectedSurah = 1;
  int _startAyah = 1;
  int _endAyah = 7; // For testing

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.startSession),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.selectSurah, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<int>(
              initialValue: _selectedSurah,
              items: List.generate(114, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text('Surah ${index + 1}'),
                );
              }),
              onChanged: (val) {
                if (val != null) setState(() => _selectedSurah = val);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.startAyah, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        initialValue: _startAyah.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => _startAyah = int.tryParse(val) ?? 1,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.endAyah, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(
                        initialValue: _endAyah.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => _endAyah = int.tryParse(val) ?? 1,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final verseCount = getVerseCount(_selectedSurah);
                final isValidRange =
                    _startAyah >= 1 &&
                    _endAyah >= _startAyah &&
                    _endAyah <= verseCount;
                if (!isValidRange) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.invalidAyahRange)),
                  );
                  return;
                }
                context.push(
                  RouteNames.sessionActivePath,
                  extra: {
                    'surah': _selectedSurah,
                    'start': _startAyah,
                    'end': _endAyah,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: Text(l10n.startSession, style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
