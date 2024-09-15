// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/subscription.dart';
import '../providers/subscription_provider.dart';

class AddSubscriptionScreen extends StatefulWidget {
  @override
  _AddSubscriptionScreenState createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _amount = 0;
  int _frequency = 30; // default to monthly
  DateTime _nextPayment = DateTime.now();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final subscription = Subscription(
        name: _name,
        amount: _amount,
        frequency: _frequency,
        nextPayment: _nextPayment,
      );
      await Provider.of<SubscriptionProvider>(context, listen: false)
          .addSubscription(subscription);
      if (mounted) {
        Navigator.pop(context);
      }

    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextPayment,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _nextPayment) {
      setState(() {
        _nextPayment = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.add_expense), // You might want to add a separate localization key
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: loc.date),
                onSaved: (val) => _name = val!.trim(),
                validator: (val) => val!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: loc.amount),
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
              DropdownButtonFormField<int>(
                value: _frequency,
                items: const [
                  DropdownMenuItem(
                    value: 30,
                    child: Text('Monthly'),
                  ),
                  DropdownMenuItem(
                    value: 90,
                    child: Text('Quarterly'),
                  ),
                  DropdownMenuItem(
                    value: 180,
                    child: Text('Biannually'),
                  ),
                  DropdownMenuItem(
                    value: 365,
                    child: Text('Annually'),
                  ),
                ],
                onChanged: (newVal) {
                  setState(() {
                    _frequency = newVal!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              Row(
                children: [
                  Text('Next Payment: ${_nextPayment.toLocal()}'.split(' ')[0]),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(loc.select_date),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(loc.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
