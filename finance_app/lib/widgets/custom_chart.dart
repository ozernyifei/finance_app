// lib/widgets/custom_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatelessWidget {

  const CustomChart({required this.dataMap, required this.title});
  final Map<String, double> dataMap;
  final String title;

  @override
  Widget build(BuildContext context) {
    // ignore: omit_local_variable_types
    final double total = dataMap.values.fold(0, (sum, item) => sum + item);

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        PieChart(
          PieChartData(
            sections: dataMap.entries.map((entry) {
              final percentage = (entry.value / total) * 100;
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
      ],
    );
  }

  // Helper method to assign colors based on key
  Color _getColor(String key) {
    // Customize colors based on the key
    switch (key) {
      case 'Food':
        return Colors.blue;
      case 'Transport':
        return Colors.green;
      case 'Entertainment':
        return Colors.orange;
      case 'Utilities':
        return Colors.red;
      case 'Subscriptions':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
