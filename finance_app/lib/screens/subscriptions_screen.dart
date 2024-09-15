// lib/screens/subscriptions_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/subscription_provider.dart';
import '../widgets/subscription_item.dart';
import 'add_subscription_screen.dart';

class SubscriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.subscriptions),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSubscriptionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: subscriptionProvider.subscriptions.isEmpty
      ? const Center(child: Text('No subscriptions added.'))
      : ListView.builder(
          itemCount: subscriptionProvider.subscriptions.length,
          itemBuilder: (context, index) {
            final subscription = subscriptionProvider.subscriptions[index];
            return SubscriptionItem(
              subscription: subscription,
                onDelete: () async {
                await subscriptionProvider.deleteSubscription(subscription.id!); 
              },
            );
          },
      ),
    );
  }
}
