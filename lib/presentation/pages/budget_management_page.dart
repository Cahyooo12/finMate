import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/layout/app_scaffold.dart';
import '../../core/widgets/navigation/custom_appbar.dart';
import '../../core/widgets/base/custom_card.dart';
import '../providers/analytics_provider.dart';
import '../widgets/budget/budget_card.dart';

class BudgetManagementPage extends ConsumerWidget {
  const BudgetManagementPage({Key? key}) : super(key: key);

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
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final budgetStatusAsync = ref.watch(
      budgetStatusProvider((month: now.month, year: now.year)),
    );
    final budgets = ref.watch(budgetLimitsProvider);

    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'Budget Management',
        centerTitle: true,
      ),
      body: budgetStatusAsync.when(
        data: (budgetStatus) {
          double totalBudget = 0;
          double totalSpent = 0;

          for (var entry in budgetStatus.entries) {
            totalSpent += entry.value.$1;
            totalBudget += entry.value.$2;
          }

          final budgetUsage = totalBudget > 0
              ? (totalSpent / totalBudget * 100)
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Budget Card
                CustomCard(
                  backgroundColor: Colors.blue[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Budget',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${budgetUsage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: budgetUsage > 100
                              ? 1
                              : budgetUsage / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            budgetUsage > 100 ? Colors.red : Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rp ${totalSpent.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},-',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'Total: Rp ${totalBudget.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},-',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category Budgets
                Text(
                  'Category Budgets',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: budgetStatus.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BudgetCard(
                        category: entry.key,
                        spent: entry.value.$1,
                        limit: entry.value.$2,
                        color: _getCategoryColor(entry.key),
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
