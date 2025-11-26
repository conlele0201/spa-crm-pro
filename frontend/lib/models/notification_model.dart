class NotificationModel {
  final String id;
  final String spaId;
  final String title;
  final String message;
  final String type; // appointment, billing, shift, treatment, promotion
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.spaId,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      spaId: map['spa_id'],
      title: map['title'],
      message: map['message'],
      type: map['type'],
      createdAt: DateTime.parse(map['created_at']),
      isRead: map['is_read'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'spa_id': spaId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
    };
  }
}

