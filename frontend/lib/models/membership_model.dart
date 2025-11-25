
class MembershipModel {
  final String id;
  final String spaId;
  final String customerId;
  final String membershipName;
  final double price;
  final double remainingBalance;
  final double discountRate;
  final DateTime createdAt;
  final DateTime updatedAt;

  MembershipModel({
    required this.id,
    required this.spaId,
    required this.customerId,
    required this.membershipName,
    required this.price,
    required this.remainingBalance,
    required this.discountRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MembershipModel.fromMap(Map<String, dynamic> map) {
    return MembershipModel(
      id: map['id'],
      spaId: map['spa_id'],
      customerId: map['customer_id'],
      membershipName: map['membership_name'],
      price: (map['price'] as num).toDouble(),
      remainingBalance: (map['remaining_balance'] as num).toDouble(),
      discountRate: (map['discount_rate'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "spa_id": spaId,
      "customer_id": customerId,
      "membership_name": membershipName,
      "price": price,
      "remaining_balance": remainingBalance,
      "discount_rate": discountRate,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
