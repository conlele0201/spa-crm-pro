import 'package:flutter/material.dart';
import '../controllers/subscription_controller.dart';
import '../models/subscription_model.dart';
import 'subscription_form.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final SubscriptionController controller = SubscriptionController();

  @override
  void initState() {
    super.initState();
    controller.load("spa_1"); // Tạm thời hardcode spa_id
  }

  void openForm({SubscriptionModel? data}) {
    showDialog(
      context: context,
      builder: (_) => SubscriptionForm(
        existing: data,
        onSaved: () {
          Navigator.pop(context);
          controller.load("spa_1");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => openForm(),
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: controller.subscriptions.isEmpty
                ? const Center(child: Text("No subscriptions found"))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Plan")),
                        DataColumn(label: Text("Price")),
                        DataColumn(label: Text("Start Date")),
                        DataColumn(label: Text("End Date")),
                        DataColumn(label: Text("Active")),
                        DataColumn(label: Text("Actions")),
                      ],
                      rows: controller.subscriptions.map((sub) {
                        return DataRow(cells: [
                          DataCell(Text(sub.planName)),
                          DataCell(Text("${sub.price} VND")),
                          DataCell(Text(sub.startDate.toString().split(" ")[0])),
                          DataCell(Text(sub.endDate.toString().split(" ")[0])),
                          DataCell(
                            Text(
                              sub.active ? "Active" : "Expired",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: sub.active ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => openForm(data: sub),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    controller.deleteSubscription(
                                      sub.id,
                                      sub.spaId,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

