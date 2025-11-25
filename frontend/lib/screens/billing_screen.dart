import 'package:flutter/material.dart';
import '../controllers/billing_controller.dart';
import '../models/billing_model.dart';
import 'billing_form.dart';

class BillingScreen extends StatefulWidget {
  final String spaId;

  const BillingScreen({
    super.key,
    required this.spaId,
  });

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final BillingController controller = BillingController();

  @override
  void initState() {
    super.initState();
    controller.loadBilling(widget.spaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hóa đơn & Doanh thu")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => BillingForm(
              spaId: widget.spaId,
              controller: controller,
            ),
          );
        },
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.billingList.isEmpty) {
            return const Center(child: Text("Chưa có hóa đơn"));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: controller.billingList.map((bill) {
              return Card(
                child: ListTile(
                  title: Text("Appointment ID: ${bill.appointmentId}"),
                  subtitle: Text(
                    "Số tiền: ${bill.amount}đ\n"
                    "Phương thức: ${bill.method}\n"
                    "Ghi chú: ${bill.note ?? '--'}\n"
                    "Ngày: ${bill.createdAt}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteBilling(bill.id, widget.spaId);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => BillingForm(
                        spaId: widget.spaId,
                        controller: controller,
                        bill: bill,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

