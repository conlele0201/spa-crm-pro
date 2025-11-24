import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardController extends ChangeNotifier {
  final SupabaseClient client = Supabase.instance.client;

  bool loading = false;
  int todayCustomers = 0;
  int todayAppointments = 0;
  int todayRevenue = 0;
  List<Map<String, dynamic>> todaySchedule = [];
  List<Map<String, dynamic>> revenue7Days = [];

  Future<void> loadDashboard(String spaId) async {
    loading = true;
    notifyListeners();

    final today = DateTime.now().toIso8601String().substring(0, 10);

    try {
      // khách hôm nay
      final c = await client
          .from('customers')
          .select()
          .eq('spa_id', spaId)
          .gte('created_at', '$today 00:00:00');

      todayCustomers = c.length;

      // lịch hẹn hôm nay
      final a = await client
          .from('appointments')
          .select()
          .eq('spa_id', spaId)
          .gte('scheduled_at', '$today 00:00:00')
          .lte('scheduled_at', '$today 23:59:59')
          .order('scheduled_at', ascending: true);

      todayAppointments = a.length;
      todaySchedule = a;

      // doanh thu hôm nay
      final b = await client
          .from('billing')
          .select('amount')
          .eq('spa_id', spaId)
          .gte('created_at', '$today 00:00:00')
          .lte('created_at', '$today 23:59:59');

      todayRevenue = b.fold(0, (sum, item) => sum + (item['amount'] as int));

      // doanh thu 7 ngày
      final r = await client
          .from('billing')
          .select('amount, created_at')
          .eq('spa_id', spaId)
          .order('created_at', ascending: false)
          .limit(50);

      revenue7Days = r;

    } catch (e) {
      print("Dashboard error: $e");
    }

    loading = false;
    notifyListeners();
  }
}

