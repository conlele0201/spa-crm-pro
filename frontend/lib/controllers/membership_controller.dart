import 'package:flutter/material.dart';
import '../models/membership_model.dart';
import '../services/membership_service.dart';

class MembershipController extends ChangeNotifier {
  final MembershipService _service = MembershipService();

  List<MembershipModel> membershipList = [];
  bool loading = false;

  /// Load toàn bộ membership theo spa
  Future<void> loadMemberships(String spaId) async {
    loading = true;
    notifyListeners();

    membershipList = await _service.getMemberships(spaId);

    loading = false;
    notifyListeners();
  }

  /// Thêm gói hội viên
  Future<void> addMembership(MembershipModel model) async {
    await _service.addMembership(model);
    await loadMemberships(model.spaId);
  }

  /// Cập nhật gói hội viên
  Future<void> updateMembership(String id, MembershipModel model) async {
    await _service.updateMembership(id, model);
    await loadMemberships(model.spaId);
  }

  /// Xóa gói hội viên
  Future<void> deleteMembership(String id, String spaId) async {
    await _service.deleteMembership(id);
    await loadMemberships(spaId);
  }
}

