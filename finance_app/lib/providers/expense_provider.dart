// lib/providers/expense_provider.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/db_helper.dart';

class ExpenseProvider with ChangeNotifier {

  ExpenseProvider() {
    Future.microtask(fetchExpenses);
  }
  List<Expense> _expenses = [];
  final DBHelper _dbHelper = DBHelper();

  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    _expenses = await _dbHelper.getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    final id = await _dbHelper.insertExpense(expense);
    _expenses.insert(0, Expense(
      id: id,
      title: expense.title,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
    ));
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await _dbHelper.deleteExpense(id);
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }

  // // Optional: Implement updateExpense if needed
  // Future<void> updateExpense(Expense expense) async {
  //   await _dbHelper.updateExpense(expense);
  //   final index = _expenses.indexWhere((e) => e.id == expense.id);
  //   if (index != -1) {
  //     _expenses[index] = expense;
  //     notifyListeners();
  //   }
  // }
}
