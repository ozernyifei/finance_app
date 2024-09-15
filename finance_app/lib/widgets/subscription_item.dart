// lib/widgets/subscription_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/subscription.dart';

class SubscriptionItem extends StatelessWidget {

  const SubscriptionItem({required this.subscription});
  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final formattedNextPayment = DateFormat.yMMMd().format(subscription.nextPayment);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.subscriptions, size: 40, color: Theme.of(context).primaryColor),
        title: Text(
          subscription.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('Amount: ${subscription.amount.toStringAsFixed(2)} ₽\nNext Payment: $formattedNextPayment'),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Implement delete functionality
            // You might want to pass a callback to handle deletion
          },
        ),
      ),
    );
  }
}
