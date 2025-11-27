class SubscriptionModel {
  final String id;
  final String spaId;
  final String planName;      // Basic, Pro, Enterprise...
  final double price;         // giá mỗi năm
  final DateTime startDate;
  final DateTime endDate;
  final bool active;

  SubscriptionModel({
    required this.id,
    required this.spaId,
    required this.planName,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.active,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'],
      spaId: map['spa_id'],
      planName: map['plan_name'],
      price: double.tryParse(map['price'].toString()) ?? 0,
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      active: map['active'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'plan_name': planName,
      'price': price,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'active': active,
    };
  }
}

