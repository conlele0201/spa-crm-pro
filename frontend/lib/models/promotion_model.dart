class PromotionModel {
  final String id;
  final String spaId;
  final String title;
  final String description;
  final String discountType; // percent / amount
  final double discountValue;
  final DateTime startDate;
  final DateTime endDate;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromotionModel({
    required this.id,
    required this.spaId,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromotionModel.fromMap(Map<String, dynamic> map) {
    return PromotionModel(
      id: map['id'],
      spaId: map['spa_id'],
      title: map['title'],
      description: map['description'] ?? "",
      discountType: map['discount_type'],
      discountValue: (map['discount_value'] as num).toDouble(),
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      active: map['active'] == true,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "spa_id": spaId,
      "title": title,
      "description": description,
      "discount_type": discountType,
      "discount_value": discountValue,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "active": active,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}

