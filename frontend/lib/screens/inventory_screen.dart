import 'package:flutter/material.dart';
import '../controllers/inventory_controller.dart';
import '../models/inventory_model.dart';
import 'inventory_form.dart';

class InventoryScreen extends StatefulWidget {
  final String spaId;

  const InventoryScreen({
    super.key,
    required this.spaId,
  });

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final InventoryController controller = InventoryController();

  @override
  void initState() {
    super.initState();
    controller.loadInventory(widget.spaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý kho")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => InventoryForm(
              spaId: widget.spaId,
              controller: controller,
            ),
          );
        },
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.inventoryList.isEmpty) {
            return const Center(child: Text("Chưa có dữ liệu kho"));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: controller.inventoryList.map((item) {
              return Card(
                child: ListTile(
                  title: Text("Product ID: ${item.productId}"),
                  subtitle: Text(
                    "Số lượng: ${item.quantity}\n"
                    "Tồn tối thiểu: ${item.minQuantity}\n"
                    "HSD: ${item.expiryDate ?? "--"}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteInventory(item.id, widget.spaId);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => InventoryForm(
                        spaId: widget.spaId,
                        controller: controller,
                        item: item,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

