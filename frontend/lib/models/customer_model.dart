class CustomerModel {
  final String id;
  final String spaId;
  final String fullName;
  final String phone;
  final String? gender;
  final String? dateOfBirth;
  final String? customerType;
  final String? source;
  final String? note;
  final String createdAt;
  final String? updatedAt;

  CustomerModel({
    required this.id,
    required this.spaId,
    required this.fullName,
    required this.phone,
    this.gender,
    this.dateOfBirth,
    this.customerType,
    this.source,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as String,
      spaId: (json['spa_id'] ?? '') as String,
      fullName: (json['full_name'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      gender: json['gender'] as String?,
      dateOfBirth: json['date_of_birth']?.toString(),
      customerType: json['customer_type'] as String?,
      source: json['source'] as String?,
      note: json['note'] as String?,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
