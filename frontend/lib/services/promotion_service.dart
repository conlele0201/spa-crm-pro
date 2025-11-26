import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/promotion_model.dart';

class PromotionService {
  final supabase = Supabase.instance.client;

  /// Lấy danh sách khuyến mãi theo spa
  Future<List<PromotionModel>> getPromotions(String spaId) async {
    final response = await supabase
        .from('promotions')
        .select()
        .eq('spa_id', spaId)
        .order('created_at', ascending: false);

    return response
        .map((row) => PromotionModel.fromMap(row))
        .toList()
        .cast<PromotionModel>();
  }

  /// Thêm khuyến mãi
  Future<void> addPromotion(PromotionModel model) async {
    await supabase.from('promotions').insert(model.toMap());
  }

  /// Cập nhật khuyến mãi
  Future<void> updatePromotion(String id, PromotionModel model) async {
    await supabase
        .from('promotions')
        .update(model.toMap())
        .eq('id', id);
  }

  /// Xóa khuyến mãi
  Future<void> deletePromotion(String id) async {
    await supabase
        .from('promotions')
        .delete()
        .eq('id', id);
  }
}

