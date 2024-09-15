// ignore_for_file: omit_local_variable_types

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../providers/subscription_provider.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final loc = AppLocalizations.of(context)!;

    final Map<String, double> categoryTotals = {};
    for (final expense in expenseProvider.expenses) {
      categoryTotals.update(expense.category, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    final double totalExpenses = categoryTotals.values.fold(0, (sum, item) => sum + item);
    final double totalSubscriptions = subscriptionProvider.subscriptions
        .fold(0, (sum, subscription) => sum + subscription.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.statistics),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '${loc.expenses}: ${totalExpenses.toStringAsFixed(2)} ₽',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            if (categoryTotals.isNotEmpty) SizedBox(
              height: 200,
              child: PieChart(
                      PieChartData(
                        sections: categoryTotals.entries.map((entry) {
                          final percentage = (entry.value / totalExpenses) * 100;
                          return PieChartSectionData(
                            color: _getColor(entry.key),
                            value: entry.value,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
            ) else Center(child: Text(loc.no_expenses)),
            const SizedBox(height: 20),
            Text(
              '${loc.subscriptions}: ${totalSubscriptions.toStringAsFixed(2)} ₽',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            if (subscriptionProvider.subscriptions.isNotEmpty) SizedBox(
              height: 200,
              child: PieChart(
                      PieChartData(
                        sections: subscriptionProvider.subscriptions.map((subscription) {
                          final percentage = (subscription.amount / totalSubscriptions) * 100;
                          return PieChartSectionData(
                            color: _getColor(subscription.name),
                            value: subscription.amount,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
            ) else const Center(child: Text('No subscriptions to display.')),
          ],
        ),
      ),
    );
  }

  // Helper method to assign colors based on category or subscription name
  Color _getColor(String key) {
    // You can customize colors based on the key
    switch (key) {
      case 'Food':
        return Colors.blue;
      case 'Transport':
        return Colors.green;
      case 'Entertainment':
        return Colors.orange;
      case 'Utilities':
        return Colors.red;
      case 'Others':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
