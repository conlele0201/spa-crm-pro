import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/billing_model.dart';

class BillingService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách bill theo spa
  Future<List<BillingModel>> getBillingList(String spaId) async {
    final response = await supabase
        .from('billing')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((row) => BillingModel.fromJson(row))
        .toList()
        .cast<BillingModel>();
  }

  /// Thêm bill (hóa đơn)
  Future<void> addBilling(BillingModel bill) async {
    await supabase.from('billing').insert(bill.toMap());
  }

  /// Cập nhật bill
  Future<void> updateBilling(String id, BillingModel bill) async {
    await supabase
        .from('billing')
        .update(bill.toMap())
        .eq('id', id);
  }

  /// Xóa bill
  Future<void> deleteBilling(String id) async {
    await supabase.from('billing').delete().eq('id', id);
  }
}

