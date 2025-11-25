import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/staff_shift_model.dart';

class StaffShiftService {
  final supabase = Supabase.instance.client;

  /// Lấy tất cả ca làm theo spa
  Future<List<StaffShiftModel>> getShifts(String spaId) async {
    final response = await supabase
        .from('staff_shifts')
        .select()
        .eq('spa_id', spaId)
        .order('shift_date', ascending: false);

    return response
        .map((row) => StaffShiftModel.fromJson(row))
        .toList()
        .cast<StaffShiftModel>();
  }

  /// Thêm ca làm
  Future<void> addShift(StaffShiftModel shift) async {
    await supabase.from('staff_shifts').insert(shift.toMap());
  }

  /// Cập nhật ca làm
  Future<void> updateShift(String id, StaffShiftModel shift) async {
    await supabase
        .from('staff_shifts')
        .update(shift.toMap())
        .eq('id', id);
  }

  /// Xóa ca làm
  Future<void> deleteShift(String id) async {
    await supabase.from('staff_shifts').delete().eq('id', id);
  }
}

