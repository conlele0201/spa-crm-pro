import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';

class MenuController extends ChangeNotifier {
  final List<MenuItemModel> items = [
    MenuItemModel(title: "Khách hàng", key: "customers", icon: Icons.people),
    MenuItemModel(title: "Lịch hẹn", key: "appointments", icon: Icons.calendar_month),
    MenuItemModel(title: "Dịch vụ", key: "services", icon: Icons.medical_services),
    MenuItemModel(title: "Gói liệu trình", key: "treatments", icon: Icons.local_offer),
    MenuItemModel(title: "Kho hàng", key: "inventory", icon: Icons.inventory),
    MenuItemModel(title: "Nhân viên", key: "staff", icon: Icons.person),
    MenuItemModel(title: "Hóa đơn", key: "billing", icon: Icons.receipt_long),
    MenuItemModel(title: "Cài đặt", key: "settings", icon: Icons.settings),
  ];

  String _activeKey = "customers";

  String get activeKey => _activeKey;

  void setActive(String key) {
    _activeKey = key;
    notifyListeners();
  }
}

