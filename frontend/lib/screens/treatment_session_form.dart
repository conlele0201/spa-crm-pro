import 'package:flutter/material.dart';
import '../controllers/treatment_session_controller.dart';
import '../models/treatment_session_model.dart';

class TreatmentSessionForm extends StatefulWidget {
  final String spaId;
  final TreatmentSessionController controller;
  final TreatmentSessionModel? session;

  const TreatmentSessionForm({
    super.key,
    required this.spaId,
    required this.controller,
    this.session,
  });

  @override
  State<TreatmentSessionForm> createState() => _TreatmentSessionFormState();
}

class _TreatmentSessionFormState extends State<TreatmentSessionForm> {
  final TextEditingController customerIdCtrl = TextEditingController();
  final TextEditingController treatmentIdCtrl = TextEditingController();
  final TextEditingController sessionNumberCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();

    if (widget.session != null) {
      isEdit = true;
      final s = widget.session!;
      customerIdCtrl.text = s.customerId;
      treatmentIdCtrl.text = s.treatmentId;
      sessionNumberCtrl.text = s.sessionNumber.toString();
      statusCtrl.text = s.status;
      noteCtrl.text = s.note ?? "";
    } else {
      statusCtrl.text = "pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? "Sửa buổi liệu trình" : "Thêm buổi liệu trình"),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Customer ID", customerIdCtrl),
              _input("Treatment ID", treatmentIdCtrl),
              _input("Buổi số", sessionNumberCtrl,
                  keyboard: TextInputType.number),
              _input("Trạng thái (pending/completed/skipped)", statusCtrl),
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
        treatmentIdCtrl.text.trim().isEmpty ||
        sessionNumberCtrl.text.trim().isEmpty ||
        statusCtrl.text.trim().isEmpty) {
      return;
    }

    final int sessionNumber =
        int.tryParse(sessionNumberCtrl.text.trim()) ?? 1;

    final session = TreatmentSessionModel(
      id: widget.session?.id ?? "",
      spaId: widget.spaId,
      customerId: customerIdCtrl.text.trim(),
      treatmentId: treatmentIdCtrl.text.trim(),
      sessionNumber: sessionNumber,
      status: statusCtrl.text.trim(),
      note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
      createdAt: widget.session?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isEdit) {
      await widget.controller.updateSession(session.id, session);
    } else {
      await widget.controller.addSession(session);
    }

    if (mounted) Navigator.pop(context);
  }
}

