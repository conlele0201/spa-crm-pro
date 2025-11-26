import 'package:flutter/material.dart';
import '../models/promotion_model.dart';
import '../services/promotion_service.dart';

class PromotionController extends ChangeNotifier {
  final PromotionService _service = PromotionService();

  List<PromotionModel> promotions = [];
  bool isLoading = false;

  /// Load danh sách khuyến mãi
  Future<void> loadPromotions(String spaId) async {
    isLoading = true;
    notifyListeners();

    promotions = await _service.getPromotions(spaId);

    isLoading = false;
    notifyListeners();
  }

  /// Thêm khuyến mãi
  Future<bool> addPromotion(PromotionModel promotion) async {
    final result = await _service.createPromotion(promotion);
    if (result) {
      promotions.add(promotion);
      notifyListeners();
    }
    return result;
  }

  /// Cập nhật khuyến mãi
  Future<bool> updatePromotion(PromotionModel updated) async {
    final result = await _service.updatePromotion(updated);
    if (result) {
      int index = promotions.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        promotions[index] = updated;
      }
      notifyListeners();
    }
    return result;
  }

  /// Xóa khuyến mãi
  Future<bool> deletePromotion(String id) async {
    final result = await _service.deletePromotion(id);
    if (result) {
      promotions.removeWhere((p) => p.id == id);
      notifyListeners();
    }
    return result;
  }
}

