class InventoryModel {
  final String id;
  final String spaId;
  final String productId;
  final int quantity;
  final int minQuantity;
  final DateTime? expiryDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  InventoryModel({
    required this.id,
    required this.spaId,
    required this.productId,
    required this.quantity,
    required this.minQuantity,
    this.expiryDate,
    required this.createdAt,
    this.updatedAt,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      spaId: json['spa_id'],
      productId: json['product_id'],
      quantity: json['quantity'] ?? 0,
      minQuantity: json['min_quantity'] ?? 0,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'product_id': productId,
      'quantity': quantity,
      'min_quantity': minQuantity,
      'expiry_date': expiryDate?.toIso8601String(),
    };
  }
}

