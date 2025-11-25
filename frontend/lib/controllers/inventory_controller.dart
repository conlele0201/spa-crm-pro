import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import '../services/inventory_service.dart';

class InventoryController extends ChangeNotifier {
  final InventoryService _service = InventoryService();

  List<InventoryModel> inventoryList = [];
  bool loading = false;

  Future<void> loadInventory(String spaId) async {
    loading = true;
    notifyListeners();

    inventoryList = await _service.getInventory(spaId);

    loading = false;
    notifyListeners();
  }

  Future<void> addInventory(InventoryModel item) async {
    await _service.addInventory(item);
    await loadInventory(item.spaId);
  }

  Future<void> updateInventory(String id, InventoryModel item) async {
    await _service.updateInventory(id, item);
    await loadInventory(item.spaId);
  }

  Future<void> deleteInventory(String id, String spaId) async {
    await _service.deleteInventory(id);
    await loadInventory(spaId);
  }
}

