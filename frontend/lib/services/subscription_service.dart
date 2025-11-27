import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/subscription_model.dart';

class SubscriptionService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách các subscription của 1 spa
  Future<List<SubscriptionModel>> getSubscriptions(String spaId) async {
    final res = await supabase
        .from('subscriptions')
        .select()
        .eq('spa_id', spaId)
        .order('start_date', ascending: false);

    return (res as List)
        .map((e) => SubscriptionModel.fromMap(e))
        .toList();
  }

  /// Thêm mới subscription
  Future<void> addSubscription(SubscriptionModel sub) async {
    await supabase.from('subscriptions').insert(sub.toMap());
  }

  /// Cập nhật subscription
  Future<void> updateSubscription(String id, SubscriptionModel sub) async {
    await supabase.from('subscriptions').update(sub.toMap()).eq('id', id);
  }

  /// Xóa subscription
  Future<void> deleteSubscription(String id) async {
    await supabase.from('subscriptions').delete().eq('id', id);
  }

  /// Kiểm tra spa có đang active không
  Future<bool> isActiveSpa(String spaId) async {
    final res = await supabase
        .from('subscriptions')
        .select()
        .eq('spa_id', spaId)
        .eq('active', true)
        .limit(1);

    return res.isNotEmpty;
  }

  /// Tự động disable nếu hết hạn
  Future<void> autoDeactivateExpired(String spaId) async {
    final now = DateTime.now().toIso8601String();

    await supabase
        .from('subscriptions')
        .update({'active': false})
        .lt('end_date', now)
        .eq('spa_id', spaId);
  }
}

