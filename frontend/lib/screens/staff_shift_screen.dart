import 'package:flutter/material.dart';
import '../controllers/staff_shift_controller.dart';
import '../models/staff_shift_model.dart';
import 'staff_shift_form.dart';

class StaffShiftScreen extends StatefulWidget {
  final String spaId;

  const StaffShiftScreen({
    super.key,
    required this.spaId,
  });

  @override
  State<StaffShiftScreen> createState() => _StaffShiftScreenState();
}

class _StaffShiftScreenState extends State<StaffShiftScreen> {
  final StaffShiftController controller = StaffShiftController();

  @override
  void initState() {
    super.initState();
    controller.loadShifts(widget.spaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý ca làm việc")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => StaffShiftForm(
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

          if (controller.shiftList.isEmpty) {
            return const Center(child: Text("Chưa có ca làm nào"));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: controller.shiftList.map((shift) {
              return Card(
                child: ListTile(
                  title: Text("Nhân viên: ${shift.staffId}"),
                  subtitle: Text(
                    "Ca: ${shift.shiftType}\n"
                    "Ngày: ${shift.shiftDate.toString().split(' ')[0]}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteShift(shift.id, widget.spaId);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => StaffShiftForm(
                        spaId: widget.spaId,
                        controller: controller,
                        shift: shift,
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

