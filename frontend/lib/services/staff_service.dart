import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/staff_model.dart';
import 'supabase_service.dart';

class StaffService {
  final SupabaseClient _client = SupabaseService.client;

  /// Lấy danh sách nhân viên theo spa
  Future<List<StaffModel>> getStaff(String spaId) async {
    final response = await _client
        .from('staff')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((json) => StaffModel.fromJson(json))
        .toList()
        .cast<StaffModel>();
  }

  /// Thêm nhân viên
  Future<bool> addStaff({
    required String spaId,
    required String fullName,
    String? phone,
    String? email,
    String? role,
  }) async {
    final data = {
      'spa_id': spaId,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'role': role,
      'is_active': true,
    };

    try {
      await _client.from('staff').insert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cập nhật nhân viên
  Future<bool> updateStaff({
    required String id,
    required String fullName,
    String? phone,
    String? email,
    String? role,
    bool? isActive,
  }) async {
    final data = {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'role': role,
      'is_active': isActive ?? true,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      await _client.from('staff').update(data).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Xóa nhân viên
  Future<bool> deleteStaff(String id) async {
    try {
      await _client.from('staff').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}

