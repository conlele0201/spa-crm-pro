import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  final CustomerService _service = CustomerService();

  List<CustomerModel> customers = [];
  bool isLoading = false;
  String? error;

  /// Load danh sách khách hàng
  Future<void> loadCustomers(String spaId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      customers = await _service.getCustomers(spaId);

    } catch (e) {
      error = "Không thể tải danh sách khách hàng.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Thêm khách hàng
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
    final ok = await _service.addCustomer(
      spaId: spaId,
      fullName: fullName,
      phone: phone,
      gender: gender,
      dateOfBirth: dateOfBirth,
      customerType: customerType,
      source: source,
      note: note,
    );

    if (ok) {
      await loadCustomers(spaId);
    }

    return ok;
  }

  /// Cập nhật khách hàng
  Future<bool> updateCustomer({
    required String id,
    required String spaId,
    required String fullName,
    required String phone,
    String? gender,
    String? dateOfBirth,
    String? customerType,
    String? source,
    String? note,
  }) async {
    final ok = await _service.updateCustomer(
      id: id,
      fullName: fullName,
      phone: phone,
      gender: gender,
      dateOfBirth: dateOfBirth,
      customerType: customerType,
      source: source,
      note: note,
    );

    if (ok) {
      await loadCustomers(spaId);
    }

    return ok;
  }

  /// Xóa khách hàng
  Future<bool> deleteCustomer(String id, String spaId) async {
    final ok = await _service.deleteCustomer(id);

    if (ok) {
      await loadCustomers(spaId);
    }

    return ok;
  }
}

