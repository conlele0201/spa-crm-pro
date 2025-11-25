import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/appointments_service.dart';

class AppointmentsController with ChangeNotifier {
  final AppointmentsService _service = AppointmentsService();

  List<AppointmentModel> appointments = [];
  bool loading = false;

  Future<void> loadAppointments(String spaId) async {
    loading = true;
    notifyListeners();

    appointments = await _service.getAppointments(spaId);

    loading = false;
    notifyListeners();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await _service.addAppointment(appointment);
    await loadAppointments(appointment.spaId);
  }

  Future<void> updateAppointment(String id, AppointmentModel appointment) async {
    await _service.updateAppointment(id, appointment);
    await loadAppointments(appointment.spaId);
  }

  Future<void> deleteAppointment(String id, String spaId) async {
    await _service.deleteAppointment(id);
    await loadAppointments(spaId);
  }
}

