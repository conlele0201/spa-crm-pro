class BillingModel {
  final String id;
  final String spaId;
  final String appointmentId;
  final int amount;
  final String method; // cash, card, qr, bank
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BillingModel({
    required this.id,
    required this.spaId,
    required this.appointmentId,
    required this.amount,
    required this.method,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  factory BillingModel.fromJson(Map<String, dynamic> json) {
    return BillingModel(
      id: json['id'],
      spaId: json['spa_id'],
      appointmentId: json['appointment_id'],
      amount: json['amount'] ?? 0,
      method: json['method'] ?? 'cash',
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
      'appointment_id': appointmentId,
      'amount': amount,
      'method': method,
      'note': note,
    };
  }
}

