import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/promotion_controller.dart';
import '../models/promotion_model.dart';

class PromotionForm extends StatefulWidget {
  final String spaId;
  final PromotionModel? promotion;

  const PromotionForm({
    super.key,
    required this.spaId,
    this.promotion,
  });

  @override
  State<PromotionForm> createState() => _PromotionFormState();
}

class _PromotionFormState extends State<PromotionForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController discountController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.promotion?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.promotion?.description ?? '');
    discountController =
        TextEditingController(text: widget.promotion?.discountPercent.toString() ?? '');
    startDateController =
        TextEditingController(text: widget.promotion?.startDate ?? '');
    endDateController =
        TextEditingController(text: widget.promotion?.endDate ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    discountController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PromotionController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.promotion == null ? "Add Promotion" : "Edit Promotion",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: discountController,
                decoration: const InputDecoration(labelText: "Discount (%)"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: startDateController,
                decoration: const InputDecoration(labelText: "Start Date (YYYY-MM-DD)"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: endDateController,
                decoration: const InputDecoration(labelText: "End Date (YYYY-MM-DD)"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final model = PromotionModel(
                    id: widget.promotion?.id,
                    spaId: widget.spaId,
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    discountPercent: int.parse(discountController.text),
                    startDate: startDateController.text.trim(),
                    endDate: endDateController.text.trim(),
                  );

                  final bool ok = widget.promotion == null
                      ? await controller.addPromotion(model)
                      : await controller.updatePromotion(model);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? "Saved successfully" : "Failed to save"),
                    ),
                  );

                  if (ok) Navigator.pop(context);
                },
                child: Text(
                  widget.promotion == null ? "Create" : "Update",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

