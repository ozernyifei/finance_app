// lib/widgets/subscription_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/subscription.dart';

class SubscriptionItem extends StatelessWidget {

  const SubscriptionItem({required this.subscription, required this.onDelete});
  final Subscription subscription;
  final VoidCallback onDelete;

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
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Subscription'),
                content: const Text('Are you sure you want to delete this subscription?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      onDelete();
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
