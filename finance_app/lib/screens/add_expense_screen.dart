import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  String _category = 'Food';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = ['Food', 'Transport', 'Entertainment', 'Utilities', 'Others'];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final expense = Expense(
        title: _title,
        amount: _amount,
        category: _category,
        date: _selectedDate,
      );
      await Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);
      if (mounted) {
        Navigator.pop(context);
      }

    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount (₽)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (val) => _amount = double.parse(val!),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter an amount';
                  }
                  if (double.tryParse(val) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _category,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (newVal) {
                  setState(() {
                    _category = newVal!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
