import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_model.dart';
import 'supabase_service.dart';

class ServiceService {
  final SupabaseClient _client = SupabaseService.client;

  /// Lấy danh sách dịch vụ theo spa
  Future<List<ServiceModel>> getServices(String spaId) async {
    final response = await _client
        .from('services')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((json) => ServiceModel.fromJson(json))
        .toList()
        .cast<ServiceModel>();
  }

  /// Thêm dịch vụ
  Future<bool> addService({
    required String spaId,
    required String name,
    String? description,
    required int price,
    required int duration,
  }) async {
    final data = {
      'spa_id': spaId,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'is_active': true,
    };

    try {
      await _client.from('services').insert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cập nhật dịch vụ
  Future<bool> updateService({
    required String id,
    required String name,
    String? description,
    required int price,
    required int duration,
    bool? isActive,
  }) async {
    final data = {
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'is_active': isActive ?? true,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      await _client.from('services').update(data).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Xóa dịch vụ
  Future<bool> deleteService(String id) async {
    try {
      await _client.from('services').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}

