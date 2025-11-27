import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../services/subscription_service.dart';

class SubscriptionController extends ChangeNotifier {
  final SubscriptionService _service = SubscriptionService();

  List<SubscriptionModel> subscriptions = [];
  bool loading = false;

  /// Load tất cả subscriptions của spa
  Future<void> load(String spaId) async {
    loading = true;
    notifyListeners();

    subscriptions = await _service.getSubscriptions(spaId);

    loading = false;
    notifyListeners();
  }

  /// Thêm gói mới
  Future<void> addSubscription(SubscriptionModel sub) async {
    await _service.addSubscription(sub);
    await load(sub.spaId);
  }

  /// Cập nhật gói
  Future<void> updateSubscription(String id, SubscriptionModel sub) async {
    await _service.updateSubscription(id, sub);
    await load(sub.spaId);
  }

  /// Xóa gói
  Future<void> deleteSubscription(String id, String spaId) async {
    await _service.deleteSubscription(id);
    await load(spaId);
  }

  /// Check spa còn hoạt động không (license)
  Future<bool> isActive(String spaId) async {
    return await _service.isActiveSpa(spaId);
  }

  /// Tự động khóa gói hết hạn
  Future<void> deactivateExpired(String spaId) async {
    await _service.autoDeactivateExpired(spaId);
    await load(spaId);
  }
}

