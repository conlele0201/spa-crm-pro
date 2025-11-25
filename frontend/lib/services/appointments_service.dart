import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment_model.dart';

class AppointmentsService {
  final supabase = Supabase.instance.client;

  Future<List<AppointmentModel>> getAppointments(String spaId) async {
    final response = await supabase
        .from('appointments')
        .select()
        .eq('spa_id', spaId)
        .order('appointment_time', ascending: true);

    return response
        .map((row) => AppointmentModel.fromMap(row))
        .toList();
  }

  Future<void> addAppointment(AppointmentModel appointment) async {
    await supabase.from('appointments').insert(appointment.toMap());
  }

  Future<void> updateAppointment(String id, AppointmentModel data) async {
    await supabase
        .from('appointments')
        .update(data.toMap())
        .eq('id', id);
  }

  Future<void> deleteAppointment(String id) async {
    await supabase.from('appointments').delete().eq('id', id);
  }
}

