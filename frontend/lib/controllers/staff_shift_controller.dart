import 'package:flutter/material.dart';
import '../models/staff_shift_model.dart';
import '../services/staff_shift_service.dart';

class StaffShiftController extends ChangeNotifier {
  final StaffShiftService _service = StaffShiftService();

  List<StaffShiftModel> shiftList = [];
  bool loading = false;

  /// Load toàn bộ ca làm của 1 spa
  Future<void> loadShifts(String spaId) async {
    loading = true;
    notifyListeners();

    shiftList = await _service.getShifts(spaId);

    loading = false;
    notifyListeners();
  }

  /// Thêm ca làm
  Future<void> addShift(StaffShiftModel shift) async {
    await _service.addShift(shift);
    await loadShifts(shift.spaId);
  }

  /// Cập nhật ca làm
  Future<void> updateShift(String id, StaffShiftModel shift) async {
    await _service.updateShift(id, shift);
    await loadShifts(shift.spaId);
  }

  /// Xóa ca làm
  Future<void> deleteShift(String id, String spaId) async {
    await _service.deleteShift(id);
    await loadShifts(spaId);
  }
}

