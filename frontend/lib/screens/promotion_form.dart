import 'package:flutter/material.dart';
import '../models/promotion_model.dart';
import '../services/promotion_service.dart';

class PromotionForm extends StatefulWidget {
  final PromotionModel? existing;
  final VoidCallback onSaved;

  const PromotionForm({
    super.key,
    this.existing,
    required this.onSaved,
  });

  @override
  State<PromotionForm> createState() => _PromotionFormState();
}

class _PromotionFormState extends State<PromotionForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController valueCtrl;

  String type = "percent";
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.existing?.name ?? "");
    valueCtrl = TextEditingController(
        text: widget.existing?.value.toString() ?? "");

    type = widget.existing?.type ?? "percent";
    startDate = widget.existing?.startDate;
    endDate = widget.existing?.endDate;
  }

  Future<void> pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;
    if (startDate == null || endDate == null) return;

    final model = PromotionModel(
      id: widget.existing?.id ?? "",
      spaId: widget.existing?.spaId ?? "spa_1",
      name: nameCtrl.text.trim(),
      type: type,
      value: double.tryParse(valueCtrl.text.trim()) ?? 0,
      startDate: startDate!,
      endDate: endDate!,
    );

    final service = PromotionService();

    if (widget.existing == null) {
      await service.addPromotion(model);
    } else {
      await service.updatePromotion(model.id, model);
    }

    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null
          ? "Add Promotion"
          : "Edit Promotion"),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Promotion Name"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: type,
                decoration: const InputDecoration(labelText: "Type"),
                items: const [
                  DropdownMenuItem(
                    value: "percent",
                    child: Text("Percent (%)"),
                  ),
                  DropdownMenuItem(
                    value: "fixed",
                    child: Text("Fixed Amount"),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    type = v.toString();
                  });
                },
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: valueCtrl,
                decoration: const InputDecoration(labelText: "Value"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(startDate == null
                      ? "Start date: Pick"
                      : "Start date: ${startDate!.toString().split(' ')[0]}"),
                  ElevatedButton(
                    onPressed: () => pickDate(true),
                    child: const Text("Choose"),
                  )
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(endDate == null
                      ? "End date: Pick"
                      : "End date: ${endDate!.toString().split(' ')[0]}"),
                  ElevatedButton(
                    onPressed: () => pickDate(false),
                    child: const Text("Choose"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
