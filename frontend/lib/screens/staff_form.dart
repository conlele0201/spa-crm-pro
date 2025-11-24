import 'package:flutter/material.dart';
import '../controllers/staff_controller.dart';
import '../models/staff_model.dart';

class StaffForm extends StatefulWidget {
  final String spaId;
  final StaffController controller;
  final StaffModel? staff;

  const StaffForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.staff,
  });

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController roleCtrl = TextEditingController();

  bool isEdit = false;
  bool isActive = true;

  @override
  void initState() {
    super.initState();

    if (widget.staff != null) {
      isEdit = true;

      nameCtrl.text = widget.staff!.fullName;
      phoneCtrl.text = widget.staff!.phone ?? "";
      emailCtrl.text = widget.staff!.email ?? "";
      roleCtrl.text = widget.staff!.role ?? "";
      isActive = widget.staff!.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa nhân viên" : "Thêm nhân viên"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Họ tên", nameCtrl),
              _input("Số điện thoại", phoneCtrl),
              _input("Email", emailCtrl),
              _input("Chức vụ", roleCtrl),
              if (isEdit)
                SwitchListTile(
                  title: const Text("Trạng thái làm việc"),
                  subtitle: Text(isActive ? "Đang làm" : "Nghỉ việc"),
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

  Widget _input(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (nameCtrl.text.trim().isEmpty) return;

    if (isEdit) {
      await widget.controller.updateStaff(
        id: widget.staff!.id,
        spaId: widget.spaId,
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        role: roleCtrl.text.trim(),
        isActive: isActive,
      );
    } else {
      await widget.controller.addStaff(
        spaId: widget.spaId,
        fullName: nameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        role: roleCtrl.text.trim(),
      );
    }

    if (mounted) Navigator.pop(context);
  }
}

