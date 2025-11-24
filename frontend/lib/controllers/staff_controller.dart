import 'package:flutter/material.dart';
import '../services/staff_service.dart';
import '../models/staff_model.dart';

class StaffController extends ChangeNotifier {
  final StaffService _service = StaffService();

  List<StaffModel> staffList = [];
  bool isLoading = false;
  String? error;

  /// Load danh sách nhân viên
  Future<void> loadStaff(String spaId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      staffList = await _service.getStaff(spaId);

    } catch (e) {
      error = "Không thể tải danh sách nhân viên.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Thêm nhân viên
  Future<bool> addStaff({
    required String spaId,
    required String fullName,
    String? phone,
    String? email,
    String? role,
  }) async {
    final ok = await _service.addStaff(
      spaId: spaId,
      fullName: fullName,
      phone: phone,
      email: email,
      role: role,
    );

    if (ok) {
      await loadStaff(spaId);
    }

    return ok;
  }

  /// Cập nhật nhân viên
  Future<bool> updateStaff({
    required String id,
    required String spaId,
    required String fullName,
    String? phone,
    String? email,
    String? role,
    bool? isActive,
  }) async {
    final ok = await _service.updateStaff(
      id: id,
      fullName: fullName,
      phone: phone,
      email: email,
      role: role,
      isActive: isActive,
    );

    if (ok) {
      await loadStaff(spaId);
    }

    return ok;
  }

  /// Xóa nhân viên
  Future<bool> deleteStaff(String id, String spaId) async {
    final ok = await _service.deleteStaff(id);

    if (ok) {
      await loadStaff(spaId);
    }

    return ok;
  }
}

