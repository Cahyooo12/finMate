import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/base/custom_card.dart';

class IncomeExpenseChartWidget extends StatelessWidget {
  final List<double> weeklyIncome;
  final List<double> weeklyExpense;

  const IncomeExpenseChartWidget({
    Key? key,
    required this.weeklyIncome,
    required this.weeklyExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxY = [...weeklyIncome, ...weeklyExpense]
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Comparison',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barGroups: List.generate(
                  weeklyIncome.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: weeklyIncome[index],
                        color: Colors.green,
                        width: 12,
                      ),
                      BarChartRodData(
                        toY: weeklyExpense[index],
                        color: Colors.red,
                        width: 12,
                      ),
                    ],
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000000).toStringAsFixed(0)}M',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  const Text('Income'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  const Text('Expense'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
