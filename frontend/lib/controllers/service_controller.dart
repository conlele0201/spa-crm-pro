import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';

class ServiceController extends ChangeNotifier {
  final ServiceService _service = ServiceService();

  List<ServiceModel> services = [];
  bool isLoading = false;
  String? error;

  /// Load danh sách dịch vụ
  Future<void> loadServices(String spaId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      services = await _service.getServices(spaId);

    } catch (e) {
      error = "Không thể tải danh sách dịch vụ.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Thêm dịch vụ
  Future<bool> addService({
    required String spaId,
    required String name,
    String? description,
    required int price,
    required int duration,
  }) async {
    final ok = await _service.addService(
      spaId: spaId,
      name: name,
      description: description,
      price: price,
      duration: duration,
    );

    if (ok) {
      await loadServices(spaId);
    }

    return ok;
  }

  /// Cập nhật dịch vụ
  Future<bool> updateService({
    required String id,
    required String spaId,
    required String name,
    String? description,
    required int price,
    required int duration,
    bool? isActive,
  }) async {
    final ok = await _service.updateService(
      id: id,
      name: name,
      description: description,
      price: price,
      duration: duration,
      isActive: isActive,
    );

    if (ok) {
      await loadServices(spaId);
    }

    return ok;
  }

  /// Xóa dịch vụ
  Future<bool> deleteService(String id, String spaId) async {
    final ok = await _service.deleteService(id);

    if (ok) {
      await loadServices(spaId);
    }

    return ok;
  }
}

