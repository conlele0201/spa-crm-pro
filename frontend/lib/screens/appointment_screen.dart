import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/appointments_controller.dart';
import '../models/appointment_model.dart';
import '../widgets/loading_widget.dart';

class AppointmentScreen extends StatelessWidget {
  final String spaId;

  const AppointmentScreen({super.key, required this.spaId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppointmentsController()..loadAppointments(spaId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Appointments"),
        ),
        body: Consumer<AppointmentsController>(
          builder: (context, controller, child) {
            if (controller.loading) {
              return const LoadingWidget();
            }

            return ListView.builder(
              itemCount: controller.appointments.length,
              itemBuilder: (context, index) {
                final appt = controller.appointments[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text("Customer: ${appt.customerId}"),
                    subtitle: Text(
                      "Service: ${appt.serviceId}\n"
                      "Time: ${appt.datetime}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        controller.deleteAppointment(appt.id, spaId);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

