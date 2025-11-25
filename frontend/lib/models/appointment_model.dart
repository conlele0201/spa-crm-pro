class AppointmentModel {
  final String id;
  final String spaId;
  final String customerId;
  final String staffId;
  final DateTime appointmentTime;
  final String status; // pending, confirmed, completed, canceled
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.spaId,
    required this.customerId,
    required this.staffId,
    required this.appointmentTime,
    required this.status,
    required this.createdAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      spaId: map['spa_id'],
      customerId: map['customer_id'],
      staffId: map['staff_id'],
      appointmentTime: DateTime.parse(map['appointment_time']),
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'customer_id': customerId,
      'staff_id': staffId,
      'appointment_time': appointmentTime.toIso8601String(),
      'status': status,
    };
  }
}

