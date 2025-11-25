import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/treatment_session_model.dart';

class TreatmentSessionService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách buổi liệu trình theo spa
  Future<List<TreatmentSessionModel>> getSessions(String spaId) async {
    final response = await supabase
        .from('treatment_sessions')
        .select()
        .eq('spa_id', spaId)
        .order('session_number', ascending: true);

    return response
        .map((row) => TreatmentSessionModel.fromJson(row))
        .toList()
        .cast<TreatmentSessionModel>();
  }

  /// Thêm buổi liệu trình
  Future<void> addSession(TreatmentSessionModel session) async {
    await supabase.from('treatment_sessions').insert(session.toMap());
  }

  /// Cập nhật buổi liệu trình
  Future<void> updateSession(String id, TreatmentSessionModel session) async {
    await supabase
        .from('treatment_sessions')
        .update(session.toMap())
        .eq('id', id);
  }

  /// Xóa buổi liệu trình
  Future<void> deleteSession(String id) async {
    await supabase.from('treatment_sessions').delete().eq('id', id);
  }
}

