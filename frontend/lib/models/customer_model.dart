
class CustomerModel {
  final String id;
  final String spaId;
  final String name;
  final String phone;
  final String? email;
  final String? notes;
  final String createdAt;

  CustomerModel({
    required this.id,
    required this.spaId,
    required this.name,
    required this.phone,
    this.email,
    this.notes,
    required this.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      spaId: json['spa_id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      notes: json['notes'],
      createdAt: json['created_at'],
    );
  }
}
