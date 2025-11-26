import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

class NotificationService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách thông báo theo spa
  Future<List<NotificationModel>> getNotifications(String spaId) async {
    final res = await supabase
        .from('notifications')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => NotificationModel.fromMap(e))
        .toList();
  }

  /// Đánh dấu đã đọc
  Future<void> markAsRead(String id) async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }

  /// Xóa thông báo
  Future<void> deleteNotification(String id) async {
    await supabase
        .from('notifications')
        .delete()
        .eq('id', id);
  }
}

