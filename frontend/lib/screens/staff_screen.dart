import 'package:flutter/material.dart';
import '../controllers/staff_controller.dart';
import '../models/staff_model.dart';
import 'staff_form.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final StaffController controller = StaffController();
  final String testSpaId = "spa-demo-123"; // test tạm, sau thay bằng spa thật

  @override
  void initState() {
    super.initState();
    controller.loadStaff(testSpaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nhân viên")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => StaffForm(
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

          if (controller.staffList.isEmpty) {
            return const Center(child: Text("Chưa có nhân viên"));
          }

          return ListView.builder(
            itemCount: controller.staffList.length,
            itemBuilder: (_, index) {
              final StaffModel s = controller.staffList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(s.fullName),
                  subtitle: Text(
                    "Chức vụ: ${s.role ?? 'Chưa rõ'}\n"
                    "Trạng thái: ${s.isActive ? 'Đang làm' : 'Nghỉ việc'}",
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
                          builder: (_) => StaffForm(
                            spaId: testSpaId,
                            controller: controller,
                            staff: s,
                          ),
                        );
                      } else if (value == "delete") {
                        controller.deleteStaff(s.id, testSpaId);
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

