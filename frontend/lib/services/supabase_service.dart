import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';   // ⭐ THÊM IMPORT NÀY

class SupabaseService {
  static final SupabaseClient client = SupabaseClient(
    SupabaseConfig.SUPABASE_URL,
    SupabaseConfig.SUPABASE_ANON_KEY,
  );
}
