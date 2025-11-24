import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;

  SupabaseService._internal();

  static SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase when the app starts
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.SUPABASE_URL,
      anonKey: SupabaseConfig.SUPABASE_ANON_KEY,
    );
  }
}

