import 'package:flutter/material.dart';
import 'package:talia/core/localization/generated/app_localizations.dart';

class WeakAyahsPage extends StatelessWidget {
  const WeakAyahsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // In a real implementation, this would use a Cubit to load the MemorizationRecords
    // and filter for confidence < 0.4.
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weakAyahs),
      ),
      body: const Center(
        child: Text('No weak ayahs found!'),
      ),
    );
  }
}
