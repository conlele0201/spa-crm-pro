class AppointmentModel {
  final String id;
  final String spaId;
  final String customerId;
  final String staffId;
  final String serviceId;
  final DateTime scheduledAt;
  final String status; // pending, confirmed, completed, canceled
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AppointmentModel({
    required this.id,
    required this.spaId,
    required this.customerId,
    required this.staffId,
    required this.serviceId,
    required this.scheduledAt,
    required this.status,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      spaId: map['spa_id'] as String,
      customerId: map['customer_id'] as String,
      staffId: map['staff_id'] as String,
      serviceId: map['service_id'] as String,
      scheduledAt: DateTime.parse(map['scheduled_at'].toString()),
      status: map['status'] as String,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'].toString()),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'customer_id': customerId,
      'staff_id': staffId,
      'service_id': serviceId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
      'note': note,
    };
  }
}
