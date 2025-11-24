class ServiceModel {
  final String id;
  final String spaId;
  final String name;
  final String? description;
  final int price;
  final int duration; // phút
  final bool isActive;
  final String createdAt;
  final String? updatedAt;

  ServiceModel({
    required this.id,
    required this.spaId,
    required this.name,
    this.description,
    required this.price,
    required this.duration,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      spaId: json['spa_id'] as String,
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] ?? 0,
      duration: json['duration'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

