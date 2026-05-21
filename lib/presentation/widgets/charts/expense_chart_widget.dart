import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/base/custom_card.dart';

class ExpenseChartWidget extends StatelessWidget {
  final Map<String, double> categoryExpenses;
  final double total;

  const ExpenseChartWidget({
    Key? key,
    required this.categoryExpenses,
    required this.total,
  }) : super(key: key);

  Color _getCategoryColor(String category) {
    const colors = {
      'Food': Color(0xFFFF6B6B),
      'Transport': Color(0xFF4ECDC4),
      'Shopping': Color(0xFFFFA07A),
      'Entertainment': Color(0xFF95E1D3),
      'Health': Color(0xFFC7CEEA),
      'Education': Color(0xFFB19CD9),
      'Utilities': Color(0xFFFFD93D),
      'Other': Color(0xFFA8DADC),
    };
    return colors[category] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final sections = categoryExpenses.entries.map((entry) {
      final value = (entry.value / total) * 100;
      return PieChartSectionData(
        color: _getCategoryColor(entry.key),
        value: value,
        title: '${value.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expense Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categoryExpenses.entries.map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(entry.key),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
