import 'package:flutter/material.dart';
import '../controllers/billing_controller.dart';
import '../models/billing_model.dart';

class BillingForm extends StatefulWidget {
  final String spaId;
  final BillingController controller;
  final BillingModel? bill;

  const BillingForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.bill,
  });

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  final TextEditingController appointmentIdCtrl = TextEditingController();
  final TextEditingController amountCtrl = TextEditingController();
  final TextEditingController methodCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.bill != null) {
      isEdit = true;
      final b = widget.bill!;
      appointmentIdCtrl.text = b.appointmentId;
      amountCtrl.text = b.amount.toString();
      methodCtrl.text = b.method;
      noteCtrl.text = b.note ?? "";
    } else {
      methodCtrl.text = "cash";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa hóa đơn" : "Thêm hóa đơn"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Appointment ID", appointmentIdCtrl),
              _input("Số tiền (VNĐ)", amountCtrl,
                  keyboard: TextInputType.number),
              _input("Phương thức (cash/card/qr/bank)", methodCtrl),
              _input("Ghi chú", noteCtrl, maxLines: 3),
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
    if (appointmentIdCtrl.text.trim().isEmpty ||
        amountCtrl.text.trim().isEmpty ||
        methodCtrl.text.trim().isEmpty) {
      return;
    }

    final int amount = int.tryParse(amountCtrl.text.trim()) ?? 0;

    final bill = BillingModel(
      id: widget.bill?.id ?? "",
      spaId: widget.spaId,
      appointmentId: appointmentIdCtrl.text.trim(),
      amount: amount,
      method: methodCtrl.text.trim(),
      note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
      createdAt: widget.bill?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await widget.controller.updateBilling(bill.id, bill);
    } else {
      await widget.controller.addBilling(bill);
    }

    if (mounted) Navigator.pop(context);
  }
}

