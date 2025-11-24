import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/customer_model.dart';
import 'supabase_service.dart';

class CustomerService {
  final SupabaseClient _client = SupabaseService.client;

  /// Lấy danh sách khách hàng theo spa
  Future<List<CustomerModel>> getCustomers(String spaId) async {
    final response = await _client
        .from('customers')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((json) => CustomerModel.fromJson(json))
        .toList()
        .cast<CustomerModel>();
  }

  /// Thêm khách hàng mới
  Future<bool> addCustomer({
    required String spaId,
    required String fullName,
    required String phone,
    String? gender,
    String? dateOfBirth,
    String? customerType,
    String? source,
    String? note,
  }) async {
    final data = {
      'spa_id': spaId,
      'full_name': fullName,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'customer_type': customerType,
      'source': source,
      'note': note,
    };

    try {
      await _client.from('customers').insert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Cập nhật khách hàng
  Future<bool> updateCustomer({
    required String id,
    required String fullName,
    required String phone,
    String? gender,
    String? dateOfBirth,
    String? customerType,
    String? source,
    String? note,
  }) async {
    final data = {
      'full_name': fullName,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'customer_type': customerType,
      'source': source,
      'note': note,
      'updated_at': DateTime.now().toIso8601String(),
    };

    try {
      await _client.from('customers').update(data).eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Xóa khách hàng theo id
  Future<bool> deleteCustomer(String id) async {
    try {
      await _client.from('customers').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}

