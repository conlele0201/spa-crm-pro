class StaffModel {
  final String id;
  final String spaId;
  final String fullName;
  final String? phone;
  final String? email;
  final String? role;
  final bool isActive;
  final String createdAt;
  final String? updatedAt;

  StaffModel({
    required this.id,
    required this.spaId,
    required this.fullName,
    this.phone,
    this.email,
    this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] as String,
      spaId: (json['spa_id'] ?? '') as String,
      fullName: (json['full_name'] ?? '') as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      isActive: (json['is_active'] ?? true) as bool,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
    );
  }
}

