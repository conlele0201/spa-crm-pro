import 'package:flutter/material.dart';
import '../controllers/membership_controller.dart';
import '../models/membership_model.dart';

class MembershipForm extends StatefulWidget {
  final String spaId;
  final MembershipController controller;
  final MembershipModel? membership;

  const MembershipForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.membership,
  });

  @override
  State<MembershipForm> createState() => _MembershipFormState();
}

class _MembershipFormState extends State<MembershipForm> {
  final TextEditingController customerIdCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController balanceCtrl = TextEditingController();
  final TextEditingController discountCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.membership != null) {
      isEdit = true;
      final m = widget.membership!;
      customerIdCtrl.text = m.customerId;
      nameCtrl.text = m.membershipName;
      priceCtrl.text = m.price.toString();
      balanceCtrl.text = m.remainingBalance.toString();
      discountCtrl.text = m.discountRate.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa gói hội viên" : "Thêm gói hội viên"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Customer ID", customerIdCtrl),
              _input("Tên gói", nameCtrl),
              _input("Giá gói", priceCtrl, keyboard: TextInputType.number),
              _input("Số dư còn lại", balanceCtrl, keyboard: TextInputType.number),
              _input("Chiết khấu (%)", discountCtrl, keyboard: TextInputType.number),
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
    if (customerIdCtrl.text.trim().isEmpty ||
        nameCtrl.text.trim().isEmpty ||
        priceCtrl.text.trim().isEmpty ||
        balanceCtrl.text.trim().isEmpty ||
        discountCtrl.text.trim().isEmpty) {
      return;
    }

    final price = double.tryParse(priceCtrl.text.trim()) ?? 0;
    final balance = double.tryParse(balanceCtrl.text.trim()) ?? 0;
    final discount = double.tryParse(discountCtrl.text.trim()) ?? 0;

    final m = MembershipModel(
      id: widget.membership?.id ?? "",
      spaId: widget.spaId,
      customerId: customerIdCtrl.text.trim(),
      membershipName: nameCtrl.text.trim(),
      price: price,
      remainingBalance: balance,
      discountRate: discount,
      createdAt: widget.membership?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await widget.controller.updateMembership(m.id, m);
    } else {
      await widget.controller.addMembership(m);
    }

    if (mounted) Navigator.pop(context);
  }
}

