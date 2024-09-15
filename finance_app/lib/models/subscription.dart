// lib/models/subscription.dart

class Subscription {

  Subscription({
    this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextPayment,
  });

  // Create Subscription from Map
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      frequency: map['frequency'],
      nextPayment: DateTime.parse(map['next_payment']),
    );
  }
  final int? id;
  final String name;
  final double amount;
  final int frequency; // in days
  final DateTime nextPayment;

  // Convert Subscription to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'frequency': frequency,
      'next_payment': nextPayment.toIso8601String(),
    };
  }
}
