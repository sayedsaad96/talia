import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    assert(url != null, 'SUPABASE_URL not found in .env');
    return url ?? '';
  }

  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    assert(key != null, 'SUPABASE_ANON_KEY not found in .env');
    return key ?? '';
  }
}
