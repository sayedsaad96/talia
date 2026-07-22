import 'package:flutter/material.dart';
import 'package:talia/app.dart';
import 'package:talia/core/di/injection_container.dart';
import 'package:talia/core/logging/app_logger.dart';

/// Application entry point.
///
/// Initializes all dependencies (config, Supabase, DI) before launching the app.
/// Order: Binding → DI (includes config + Supabase) → Run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (loads .env, initializes Supabase, registers all services)
  await initDependencies();

  AppLogger.i('Talia application starting');

  runApp(const TaliaApp());
}
