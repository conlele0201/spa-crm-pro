import 'package:flutter/material.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_model.dart';

class CustomerForm extends StatefulWidget {
  final String spaId;
  final CustomerController controller;
  final CustomerModel? customer;

  const CustomerForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.customer,
  });

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController genderCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController customerTypeCtrl = TextEditingController();
  final TextEditingController sourceCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.customer != null) {
      isEdit = true;
      nameCtrl.text = widget.customer!.fullName;
      phoneCtrl.text = widget.customer!.phone;
      genderCtrl.text = widget.customer!.gender ?? "";
      dobCtrl.text = widget.customer!.dateOfBirth ?? "";
      customerTypeCtrl.text = widget.customer!.customerType ?? "";
      sourceCtrl.text = widget.customer!.source ?? "";
      noteCtrl.text = widget.customer!.note ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa khách hàng" : "Thêm khách hàng"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Họ tên", nameCtrl),
              _input("Số điện thoại", phoneCtrl, keyboard: TextInputType.phone),
              _input("Giới tính", genderCtrl),
              _input("Ngày sinh (yyyy-mm-dd)", dobCtrl),
              _input("Loại khách", customerTypeCtrl),
              _input("Nguồn khách", sourceCtrl),
              _input("Ghi chú", noteCtrl, maxLines: 3),
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

  Widget _input(String label, TextEditingController c,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
      return;
    }

    if (isEdit) {
      await widget.controller.updateCustomer(
        id: widget.customer!.id,
        spaId: widget.spaId,
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        gender: genderCtrl.text.trim(),
        dateOfBirth: dobCtrl.text.trim(),
        customerType: customerTypeCtrl.text.trim(),
        source: sourceCtrl.text.trim(),
        note: noteCtrl.text.trim(),
      );
    } else {
      await widget.controller.addCustomer(
        spaId: widget.spaId,
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        gender: genderCtrl.text.trim(),
        dateOfBirth: dobCtrl.text.trim(),
        customerType: customerTypeCtrl.text.trim(),
        source: sourceCtrl.text.trim(),
        note: noteCtrl.text.trim(),
      );
    }

    if (mounted) Navigator.pop(context);
  }
}

