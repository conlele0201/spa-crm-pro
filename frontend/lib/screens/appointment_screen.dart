import 'package:flutter/material.dart';
import '../controllers/appointments_controller.dart';
import '../models/appointment_model.dart';
import 'appointment_form.dart';

class AppointmentScreen extends StatefulWidget {
  final String spaId;

  const AppointmentScreen({super.key, required this.spaId});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final AppointmentsController controller = AppointmentsController();

  @override
  void initState() {
    super.initState();
    controller.loadAppointments(widget.spaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch hẹn"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AppointmentForm(
              spaId: widget.spaId,
              controller: controller,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.appointments.isEmpty) {
            return const Center(child: Text("Chưa có lịch hẹn"));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: controller.appointments.map((appt) {
              return Card(
                child: ListTile(
                  title: Text("Khách hàng ID: ${appt.customerId}"),
                  subtitle: Text(
                    "Dịch vụ ID: ${appt.serviceId}\n"
                    "Nhân viên ID: ${appt.staffId}\n"
                    "Thời gian: ${appt.scheduledAt}\n"
                    "Ghi chú: ${appt.note ?? '--'}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteAppointment(appt.id, widget.spaId);
                    },
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AppointmentForm(
                        spaId: widget.spaId,
                        controller: controller,
                        appointment: appt,
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
