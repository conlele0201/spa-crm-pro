import 'package:flutter/material.dart';
import '../controllers/customer_controller.dart';
import '../models/customer_model.dart';
import 'customer_form.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final CustomerController controller = CustomerController();
  final String testSpaId = "spa-demo-123"; // tạm thời test, sau này thay bằng spa thật

  @override
  void initState() {
    super.initState();
    controller.loadCustomers(testSpaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Khách hàng"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CustomerForm(
              spaId: testSpaId,
              controller: controller,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }

          if (controller.customers.isEmpty) {
            return const Center(child: Text("Chưa có khách hàng"));
          }

          return ListView.builder(
            itemCount: controller.customers.length,
            itemBuilder: (_, index) {
              final CustomerModel c = controller.customers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(c.fullName),
                  subtitle: Text(c.phone),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: "edit", child: Text("Sửa")),
                      const PopupMenuItem(value: "delete", child: Text("Xoá")),
                    ],
                    onSelected: (value) {
                      if (value == "edit") {
                        showDialog(
                          context: context,
                          builder: (_) => CustomerForm(
                            spaId: testSpaId,
                            controller: controller,
                            customer: c,
                          ),
                        );
                      } else if (value == "delete") {
                        controller.deleteCustomer(c.id, testSpaId);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

