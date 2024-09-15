import 'package:finance_app/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'add_expense_screen.dart';
import 'statistics_screen.dart';
import 'subscriptions_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    ExpensesList(),
    StatisticsScreen(),
    SubscriptionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddExpenseScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// Inside ExpensesList in home_screen.dart

class ExpensesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, expenseProvider, child) {
        final expenses = expenseProvider.expenses;
        if (expenses.isEmpty) {
          return const Center(child: Text('No expenses recorded.'));
        }
        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ExpenseItem(
              expense: expense,
              onDelete: () {
                expenseProvider.deleteExpense(expense.id!);
              },
            );
          },
        );
      },
    );
  }
}

