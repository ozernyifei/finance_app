// lib/providers/subscription_provider.dart

import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../services/db_helper.dart';

class SubscriptionProvider with ChangeNotifier {

  SubscriptionProvider() {
    Future.microtask(fetchSubscriptions);
  }
  List<Subscription> _subscriptions = [];
  final DBHelper _dbHelper = DBHelper();

  List<Subscription> get subscriptions => _subscriptions;

  Future<void> fetchSubscriptions() async {
    _subscriptions = await _dbHelper.getSubscriptions();
    notifyListeners();
  }

  Future<void> addSubscription(Subscription subscription) async {
    await _dbHelper.insertSubscription(subscription);
    _subscriptions.add(subscription);
    notifyListeners();
  }

  Future<void> updateSubscription(Subscription subscription) async {
    await _dbHelper.updateSubscription(subscription);
    final index =
        _subscriptions.indexWhere((s) => s.id == subscription.id);
    if (index != -1) {
      _subscriptions[index] = subscription;
      notifyListeners();
    }
  }

  Future<void> deleteSubscription(int id) async {
    await _dbHelper.deleteSubscription(id);
    _subscriptions.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
