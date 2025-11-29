import 'package:supabase_flutter/supabase_flutter.dart';

class LicenseService {
  Future<String> checkLicense(String spaId) async {
    final supabase = Supabase.instance.client;

    // Lấy license hiện tại theo spa
    final data = await supabase
        .from('licenses')
        .select()
        .eq('spa_id', spaId)
        .maybeSingle();

    if (data == null) {
      return "NO_LICENSE"; // Không có license
    }

    final bool active = data['active'] ?? false;
    final String? endStr = data['end_date'];

    if (!active) {
      return "INACTIVE"; // License bị tắt
    }

    if (endStr == null) {
      return "INVALID"; // Không có ngày hết hạn
    }

    final endDt = DateTime.tryParse(endStr);
    if (endDt == null) {
      return "INVALID";
    }

    final now = DateTime.now();
    if (now.isAfter(endDt)) {
      return "EXPIRED"; // License hết hạn
    }

    return "OK"; // License hợp lệ
  }
}
