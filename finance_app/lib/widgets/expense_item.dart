// lib/widgets/expense_item.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {

  const ExpenseItem({required this.expense, required this.onDelete});
  final Expense expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(expense.date);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('${expense.amount.toStringAsFixed(2)} ₽'),
            ),
          ),
        ),
        title: Text(
          expense.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('$formattedDate • ${expense.category}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            // Confirm deletion
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Expense'),
                content: const Text('Are you sure you want to delete this expense?'),
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
