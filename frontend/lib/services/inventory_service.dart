import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/inventory_model.dart';

class InventoryService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách tồn kho theo spa
  Future<List<InventoryModel>> getInventory(String spaId) async {
    final response = await supabase
        .from('inventory')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((row) => InventoryModel.fromJson(row))
        .toList()
        .cast<InventoryModel>();
  }

  /// Thêm item vào kho
  Future<void> addInventory(InventoryModel item) async {
    await supabase.from('inventory').insert(item.toMap());
  }

  /// Cập nhật item
  Future<void> updateInventory(String id, InventoryModel item) async {
    await supabase
        .from('inventory')
        .update(item.toMap())
        .eq('id', id);
  }

  /// Xóa item
  Future<void> deleteInventory(String id) async {
    await supabase.from('inventory').delete().eq('id', id);
  }
}

