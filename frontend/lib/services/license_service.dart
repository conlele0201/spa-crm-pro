import 'package:supabase_flutter/supabase_flutter.dart';

class LicenseService {
  final supabase = Supabase.instance.client;

  /// Lấy license theo spa_id
  Future<Map<String, dynamic>?> getLicense(String spaId) async {
    final res = await supabase
        .from('licenses')
        .select()
        .eq('spa_id', spaId)
        .maybeSingle();

    return res;
  }

  /// Kiểm tra license SPA còn hạn hay không
  ///
  /// Trả về:
  /// - "OK"
  /// - "EXPIRED"
  /// - "NO_LICENSE"
  /// - "INACTIVE"
  Future<String> checkLicense(String spaId) async {
    final license = await getLicense(spaId);

    if (license == null) return "NO_LICENSE";

    bool active = license['active'] ?? false;
    String? endDateStr = license['end_date'];

    if (!active) return "INACTIVE";

    if (endDateStr == null) return "NO_LICENSE";

    final endDate = DateTime.parse(endDateStr);
    final today = DateTime.now();

    if (today.isAfter(endDate)) {
      // tự tắt
      await deactivateLicense(spaId);
      return "EXPIRED";
    }

    return "OK";
  }

  /// Gia hạn license theo số tháng
  Future<void> renewLicense({
    required String spaId,
    required int months,
  }) async {
    final license = await getLicense(spaId);

    final now = DateTime.now();
    final newStart = now;
    final newEnd = DateTime(now.year, now.month + months, now.day);

    if (license == null) {
      // tạo mới
      await supabase.from('licenses').insert({
        'spa_id': spaId,
        'active': true,
        'start_date': newStart.toIso8601String(),
        'end_date': newEnd.toIso8601String(),
      });
    } else {
      // cập nhật license
      await supabase
          .from('licenses')
          .update({
            'active': true,
            'start_date': newStart.toIso8601String(),
            'end_date': newEnd.toIso8601String(),
          })
          .eq('spa_id', spaId);
    }
  }

  /// Tắt license
  Future<void> deactivateLicense(String spaId) async {
    await supabase
        .from('licenses')
        .update({'active': false})
        .eq('spa_id', spaId);
  }

  /// Bật lại license (khi renew)
  Future<void> activateLicense(String spaId) async {
    await supabase
        .from('licenses')
        .update({'active': true})
        .eq('spa_id', spaId);
  }
}

