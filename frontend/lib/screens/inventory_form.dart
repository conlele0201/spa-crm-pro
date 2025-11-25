import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../models/inventory_model.dart';

class InventoryForm extends StatefulWidget {
  final String spaId;
  final InventoryController controller;
  final InventoryModel? item;

  const InventoryForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.item,
  });

  @override
  State<InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<InventoryForm> {
  final TextEditingController productIdCtrl = TextEditingController();
  final TextEditingController quantityCtrl = TextEditingController();
  final TextEditingController minQuantityCtrl = TextEditingController();
  final TextEditingController expiryDateCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      isEdit = true;
      final x = widget.item!;
      productIdCtrl.text = x.productId;
      quantityCtrl.text = x.quantity.toString();
      minQuantityCtrl.text = x.minQuantity.toString();
      expiryDateCtrl.text =
          x.expiryDate != null ? x.expiryDate!.toIso8601String().split("T")[0] : "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa tồn kho" : "Thêm tồn kho"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Product ID", productIdCtrl),
              _input("Số lượng", quantityCtrl, keyboard: TextInputType.number),
              _input("Tồn tối thiểu", minQuantityCtrl,
                  keyboard: TextInputType.number),
              _input("Hạn sử dụng (yyyy-MM-dd)", expiryDateCtrl),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Hủy"),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEdit ? "Cập nhật" : "Thêm"),
        ),
      ],
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (productIdCtrl.text.trim().isEmpty ||
        quantityCtrl.text.trim().isEmpty ||
        minQuantityCtrl.text.trim().isEmpty) {
      return;
    }

    final qty = int.tryParse(quantityCtrl.text.trim()) ?? 0;
    final minQty = int.tryParse(minQuantityCtrl.text.trim()) ?? 0;

    DateTime? expiry;
    if (expiryDateCtrl.text.trim().isNotEmpty) {
      expiry = DateTime.tryParse(expiryDateCtrl.text.trim());
    }

    final item = InventoryModel(
      id: widget.item?.id ?? "",
      spaId: widget.spaId,
      productId: productIdCtrl.text.trim(),
      quantity: qty,
      minQuantity: minQty,
      expiryDate: expiry,
      createdAt: widget.item?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await widget.controller.updateInventory(item.id, item);
    } else {
      await widget.controller.addInventory(item);
    }

    if (mounted) Navigator.pop(context);
  }
}

