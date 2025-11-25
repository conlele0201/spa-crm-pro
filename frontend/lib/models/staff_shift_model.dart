class StaffShiftModel {
  final String id;
  final String spaId;
  final String staffId;
  final String shiftType; // morning / afternoon / evening / full
  final DateTime shiftDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StaffShiftModel({
    required this.id,
    required this.spaId,
    required this.staffId,
    required this.shiftType,
    required this.shiftDate,
    required this.createdAt,
    this.updatedAt,
  });

  factory StaffShiftModel.fromJson(Map<String, dynamic> json) {
    return StaffShiftModel(
      id: json['id'],
      spaId: json['spa_id'],
      staffId: json['staff_id'],
      shiftType: json['shift_type'],
      shiftDate: DateTime.parse(json['shift_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'staff_id': staffId,
      'shift_type': shiftType,
      'shift_date': shiftDate.toIso8601String(),
    };
  }
}

