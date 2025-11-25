
import 'package:flutter/material.dart';
import '../controllers/appointments_controller.dart';
import '../models/appointment_model.dart';

class AppointmentForm extends StatefulWidget {
  final String spaId;
  final AppointmentsController controller;
  final AppointmentModel? appointment;

  const AppointmentForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.appointment,
  });

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final TextEditingController customerIdCtrl = TextEditingController();
  final TextEditingController staffIdCtrl = TextEditingController();
  final TextEditingController serviceIdCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.appointment != null) {
      isEdit = true;
      final appt = widget.appointment!;
      customerIdCtrl.text = appt.customerId;
      staffIdCtrl.text = appt.staffId;
      serviceIdCtrl.text = appt.serviceId;
      timeCtrl.text = appt.scheduledAt.toIso8601String();
      statusCtrl.text = appt.status;
      noteCtrl.text = appt.note ?? "";
    } else {
      // mặc định status khi tạo mới
      statusCtrl.text = "pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa lịch hẹn" : "Thêm lịch hẹn"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Customer ID", customerIdCtrl),
              _input("Staff ID", staffIdCtrl),
              _input("Service ID", serviceIdCtrl),
              _input("Thời gian (ISO 8601)", timeCtrl,
                  hint: "VD: 2025-11-25T14:30:00"),
              _input("Trạng thái (pending/confirmed/completed/canceled)",
                  statusCtrl),
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

  Widget _input(String label, TextEditingController ctrl,
      {int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (customerIdCtrl.text.trim().isEmpty ||
        staffIdCtrl.text.trim().isEmpty ||
        serviceIdCtrl.text.trim().isEmpty) {
      return;
    }

    DateTime scheduled;
    try {
      scheduled = DateTime.parse(timeCtrl.text.trim());
    } catch (_) {
      scheduled = DateTime.now();
    }

    final appt = AppointmentModel(
      id: widget.appointment?.id ?? "",
      spaId: widget.spaId,
      customerId: customerIdCtrl.text.trim(),
      staffId: staffIdCtrl.text.trim(),
      serviceId: serviceIdCtrl.text.trim(),
      scheduledAt: scheduled,
      status: statusCtrl.text.trim().isEmpty
          ? "pending"
          : statusCtrl.text.trim(),
      note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
      createdAt: widget.appointment?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await widget.controller.updateAppointment(appt.id, appt);
    } else {
      await widget.controller.addAppointment(appt);
    }

    if (mounted) Navigator.pop(context);
  }
}
