import 'package:flutter/material.dart';
import '../models/promotion_model.dart';
import '../services/promotion_service.dart';

class PromotionController extends ChangeNotifier {
  final PromotionService _service = PromotionService();

  List<PromotionModel> promotionList = [];
  bool loading = false;

  /// Load danh sách khuyến mãi theo spa
  Future<void> loadPromotions(String spaId) async {
    loading = true;
    notifyListeners();

    promotionList = await _service.getPromotions(spaId);

    loading = false;
    notifyListeners();
  }

  /// Thêm khuyến mãi
  Future<void> addPromotion(PromotionModel promo) async {
    await _service.addPromotion(promo);
    await loadPromotions(promo.spaId);
  }

  /// Cập nhật khuyến mãi
  Future<void> updatePromotion(String id, PromotionModel promo) async {
    await _service.updatePromotion(id, promo);
    await loadPromotions(promo.spaId);
  }

  /// Xóa khuyến mãi
  Future<void> deletePromotion(String id, String spaId) async {
    await _service.deletePromotion(id);
    await loadPromotions(spaId);
  }
}
