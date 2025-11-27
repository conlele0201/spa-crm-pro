import 'package:flutter/material.dart';
import '../models/subscription_model.dart';
import '../services/subscription_service.dart';

class SubscriptionForm extends StatefulWidget {
  final SubscriptionModel? existing;
  final VoidCallback onSaved;

  const SubscriptionForm({
    super.key,
    this.existing,
    required this.onSaved,
  });

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController planCtrl;
  late TextEditingController priceCtrl;

  DateTime? startDate;
  DateTime? endDate;
  bool active = true;

  @override
  void initState() {
    super.initState();

    planCtrl = TextEditingController(text: widget.existing?.planName ?? "");
    priceCtrl =
        TextEditingController(text: widget.existing?.price.toString() ?? "");

    startDate = widget.existing?.startDate;
    endDate = widget.existing?.endDate;
    active = widget.existing?.active ?? true;
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

    final data = SubscriptionModel(
      id: widget.existing?.id ?? "",
      spaId: widget.existing?.spaId ?? "spa_1",
      planName: planCtrl.text.trim(),
      price: double.tryParse(priceCtrl.text.trim()) ?? 0,
      startDate: startDate!,
      endDate: endDate!,
      active: active,
    );

    final service = SubscriptionService();

    if (widget.existing == null) {
      await service.addSubscription(data);
    } else {
      await service.updateSubscription(data.id, data);
    }

    widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null
          ? "Add Subscription"
          : "Edit Subscription"),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: planCtrl,
                decoration: const InputDecoration(labelText: "Plan Name"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: "Price (VND per year)"),
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
                      : "Start: ${startDate!.toString().split(" ")[0]}"),
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
                      : "End: ${endDate!.toString().split(" ")[0]}"),
                  ElevatedButton(
                    onPressed: () => pickDate(false),
                    child: const Text("Choose"),
                  )
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: active,
                    onChanged: (v) {
                      setState(() {
                        active = v ?? false;
                      });
                    },
                  ),
                  const Text("Active"),
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

