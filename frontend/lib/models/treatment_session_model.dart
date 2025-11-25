class TreatmentSessionModel {
  final String id;
  final String spaId;
  final String customerId;
  final String treatmentId;
  final int sessionNumber;
  final String status; // pending / completed / skipped
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TreatmentSessionModel({
    required this.id,
    required this.spaId,
    required this.customerId,
    required this.treatmentId,
    required this.sessionNumber,
    required this.status,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  factory TreatmentSessionModel.fromJson(Map<String, dynamic> json) {
    return TreatmentSessionModel(
      id: json['id'],
      spaId: json['spa_id'],
      customerId: json['customer_id'],
      treatmentId: json['treatment_id'],
      sessionNumber: json['session_number'],
      status: json['status'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'customer_id': customerId,
      'treatment_id': treatmentId,
      'session_number': sessionNumber,
      'status': status,
      'note': note,
    };
  }
}

