import 'package:flutter/material.dart';
import '../controllers/service_controller.dart';
import '../models/service_model.dart';
import 'service_form.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceController controller = ServiceController();
  final String testSpaId = "spa-demo-123";

  @override
  void initState() {
    super.initState();
    controller.loadServices(testSpaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dịch vụ")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => ServiceForm(
              spaId: testSpaId,
              controller: controller,
            ),
          );
        },
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

          if (controller.services.isEmpty) {
            return const Center(child: Text("Chưa có dịch vụ"));
          }

          return ListView.builder(
            itemCount: controller.services.length,
            itemBuilder: (_, index) {
              final ServiceModel s = controller.services[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(s.name),
                  subtitle: Text(
                    "Giá: ${s.price}đ\nThời gian: ${s.duration} phút\n"
                    "Trạng thái: ${s.isActive ? 'Đang hoạt động' : 'Ngưng'}",
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: "edit", child: Text("Sửa")),
                      PopupMenuItem(value: "delete", child: Text("Xóa")),
                    ],
                    onSelected: (value) {
                      if (value == "edit") {
                        showDialog(
                          context: context,
                          builder: (_) => ServiceForm(
                            spaId: testSpaId,
                            controller: controller,
                            service: s,
                          ),
                        );
                      } else if (value == "delete") {
                        controller.deleteService(s.id, testSpaId);
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

