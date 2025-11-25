import 'package:flutter/material.dart';
import '../controllers/staff_shift_controller.dart';
import '../models/staff_shift_model.dart';

class StaffShiftForm extends StatefulWidget {
  final String spaId;
  final StaffShiftController controller;
  final StaffShiftModel? shift;

  const StaffShiftForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.shift,
  });

  @override
  State<StaffShiftForm> createState() => _StaffShiftFormState();
}

class _StaffShiftFormState extends State<StaffShiftForm> {
  final TextEditingController staffIdCtrl = TextEditingController();
  final TextEditingController shiftTypeCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.shift != null) {
      isEdit = true;
      final s = widget.shift!;
      staffIdCtrl.text = s.staffId;
      shiftTypeCtrl.text = s.shiftType;
      dateCtrl.text = s.shiftDate.toIso8601String().split("T")[0];
    } else {
      shiftTypeCtrl.text = "morning"; // default
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa ca làm" : "Thêm ca làm"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Staff ID", staffIdCtrl),
              _input("Loại ca (morning / afternoon / evening / full)", shiftTypeCtrl),
              _input("Ngày làm (yyyy-MM-dd)", dateCtrl),
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
    if (staffIdCtrl.text.trim().isEmpty ||
        shiftTypeCtrl.text.trim().isEmpty ||
        dateCtrl.text.trim().isEmpty) {
      return;
    }

    final DateTime? shiftDate =
        DateTime.tryParse(dateCtrl.text.trim());

    if (shiftDate == null) return;

    final shift = StaffShiftModel(
      id: widget.shift?.id ?? "",
      spaId: widget.spaId,
      staffId: staffIdCtrl.text.trim(),
      shiftType: shiftTypeCtrl.text.trim(),
      shiftDate: shiftDate,
      createdAt: widget.shift?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await widget.controller.updateShift(shift.id, shift);
    } else {
      await widget.controller.addShift(shift);
    }

    if (mounted) Navigator.pop(context);
  }
}

