import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> notifications = [];
  bool loading = false;

  /// Load danh sách thông báo
  Future<void> load(String spaId) async {
    loading = true;
    notifyListeners();

    notifications = await _service.getNotifications(spaId);

    loading = false;
    notifyListeners();
  }

  /// Đánh dấu đã đọc
  Future<void> markRead(String id, String spaId) async {
    await _service.markAsRead(id);
    await load(spaId);
  }

  /// Xóa thông báo
  Future<void> delete(String id, String spaId) async {
    await _service.deleteNotification(id);
    await load(spaId);
  }
}

