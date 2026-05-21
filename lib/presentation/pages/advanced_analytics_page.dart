import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/layout/app_scaffold.dart';
import '../../core/widgets/navigation/custom_appbar.dart';
import '../../core/widgets/base/custom_card.dart';
import '../providers/analytics_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/charts/expense_chart_widget.dart';
import '../widgets/charts/income_expense_chart_widget.dart';
import '../widgets/ai/ai_insight_card.dart';

class AdvancedAnalyticsPage extends ConsumerWidget {
  const AdvancedAnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final transactionsAsync = ref.watch(transactionsProvider);
    final insightsAsync = ref.watch(
      aiInsightsProvider((month: now.month, year: now.year)),
    );

    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'Advanced Analytics',
        centerTitle: true,
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          // Calculate statistics
          double totalIncome = 0;
          double totalExpense = 0;
          final categoryExpenses = <String, double>{};

          for (var tx in transactions) {
            if (tx.type == 'income') {
              totalIncome += tx.amount;
            } else {
              totalExpense += tx.amount;
              categoryExpenses[tx.category] =
                  (categoryExpenses[tx.category] ?? 0) + tx.amount;
            }
          }

          final balance = totalIncome - totalExpense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: CustomCard(
                        backgroundColor: Colors.green[50],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Income',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.green[700],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${totalIncome.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},-',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomCard(
                        backgroundColor: Colors.red[50],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Expense',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.red[700],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${totalExpense.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},-',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Balance Card
                CustomCard(
                  backgroundColor: Colors.blue[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Net Balance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},-',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // AI Insights
                Text(
                  'AI Insights',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                insightsAsync.when(
                  data: (insights) => Column(
                    children: insights
                        .map((insight) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AIInsightCard(
                                title: insight.split(' ')[0],
                                insight: insight,
                                icon: Icons.lightbulb_outline,
                              ),
                            ))
                        .toList(),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Text('Error: $error'),
                ),
                const SizedBox(height: 24),

                // Pie Chart
                if (categoryExpenses.isNotEmpty)
                  ExpenseChartWidget(
                    categoryExpenses: categoryExpenses,
                    total: totalExpense,
                  ),
                const SizedBox(height: 24),

                // Category Breakdown
                Text(
                  'Spending by Category',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: categoryExpenses.entries.map((entry) {
                    final percentage = totalExpense > 0
                        ? (entry.value / totalExpense * 100)
                        : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
