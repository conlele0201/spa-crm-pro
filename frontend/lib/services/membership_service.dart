import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/membership_model.dart';

class MembershipService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách hội viên theo spa
  Future<List<MembershipModel>> getMemberships(String spaId) async {
    final response = await supabase
        .from('memberships')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((row) => MembershipModel.fromMap(row))
        .toList()
        .cast<MembershipModel>();
  }

  /// Thêm gói hội viên
  Future<void> addMembership(MembershipModel model) async {
    await supabase.from('memberships').insert(model.toMap());
  }

  /// Cập nhật gói hội viên
  Future<void> updateMembership(String id, MembershipModel model) async {
    await supabase
        .from('memberships')
        .update(model.toMap())
        .eq('id', id);
  }

  /// Xóa gói hội viên
  Future<void> deleteMembership(String id) async {
    await supabase
        .from('memberships')
        .delete()
        .eq('id', id);
  }
}

