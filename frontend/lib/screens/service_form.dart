import 'package:flutter/material.dart';
import '../controllers/service_controller.dart';
import '../models/service_model.dart';

class ServiceForm extends StatefulWidget {
  final String spaId;
  final ServiceController controller;
  final ServiceModel? service;

  const ServiceForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.service,
  });

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();

  bool isEdit = false;
  bool isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.service != null) {
      isEdit = true;

      nameCtrl.text = widget.service!.name;
      descCtrl.text = widget.service!.description ?? "";
      priceCtrl.text = widget.service!.price.toString();
      durationCtrl.text = widget.service!.duration.toString();
      isActive = widget.service!.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa dịch vụ" : "Thêm dịch vụ"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Tên dịch vụ", nameCtrl),
              _input("Mô tả", descCtrl, maxLines: 3),
              _input("Giá (VNĐ)", priceCtrl, keyboard: TextInputType.number),
              _input("Thời gian (phút)", durationCtrl,
                  keyboard: TextInputType.number),
              if (isEdit)
                SwitchListTile(
                  title: const Text("Trạng thái"),
                  subtitle:
                      Text(isActive ? "Đang hoạt động" : "Ngưng hoạt động"),
                  value: isActive,
                  onChanged: (v) => setState(() => isActive = v),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Hủy"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text(isEdit ? "Cập nhật" : "Thêm"),
          onPressed: _save,
        ),
      ],
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (nameCtrl.text.trim().isEmpty) return;

    final int price = int.tryParse(priceCtrl.text.trim()) ?? 0;
    final int duration = int.tryParse(durationCtrl.text.trim()) ?? 0;

    if (isEdit) {
      await widget.controller.updateService(
        id: widget.service!.id,
        spaId: widget.spaId,
        name: nameCtrl.text.trim(),
        description: descCtrl.text.trim(),
        price: price,
        duration: duration,
        isActive: isActive,
      );
    } else {
      await widget.controller.addService(
        spaId: widget.spaId,
        name: nameCtrl.text.trim(),
        description: descCtrl.text.trim(),
        price: price,
        duration: duration,
      );
    }

    if (mounted) Navigator.pop(context);
  }
}

