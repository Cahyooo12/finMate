import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/transaction_model.dart';
import '../providers/transaction_provider.dart';

// Budget limits per category (in IDR)
final budgetLimitsProvider = StateProvider<Map<String, double>>((ref) {
  return {
    'Food': 5000000,
    'Transport': 2000000,
    'Shopping': 3000000,
    'Entertainment': 2000000,
    'Health': 1000000,
    'Education': 2000000,
    'Utilities': 1500000,
    'Other': 1000000,
  };
});

// Get spending by category for current month
final monthlySpendingProvider =
    FutureProvider.family<Map<String, double>, ({int month, int year}))>(
  (ref, params) async {
    final transactions = await ref.watch(
      transactionsByMonthProvider(params),
    );

    final spending = <String, double>{};
    for (var tx in transactions) {
      if (tx.type == 'expense') {
        spending[tx.category] = (spending[tx.category] ?? 0) + tx.amount;
      }
    }
    return spending;
  },
);

// Get budget status
final budgetStatusProvider =
    FutureProvider.family<Map<String, (double, double)>, ({int month, int year}))>(
  (ref, params) async {
    final budgets = ref.watch(budgetLimitsProvider);
    final spending = await ref.watch(
      monthlySpendingProvider(params),
    );

    final status = <String, (double, double)>{};
    budgets.forEach((category, limit) {
      final spent = spending[category] ?? 0;
      status[category] = (spent, limit);
    });
    return status;
  },
);

// AI Insights
final aiInsightsProvider =
    FutureProvider.family<List<String>, ({int month, int year}))>(
  (ref, params) async {
    final transactions = await ref.watch(
      transactionsByMonthProvider(params),
    );
    final budgets = ref.watch(budgetLimitsProvider);
    final spending = await ref.watch(
      monthlySpendingProvider(params),
    );

    final insights = <String>[];

    // Calculate total expenses
    double totalExpense = 0;
    for (var tx in transactions) {
      if (tx.type == 'expense') {
        totalExpense += tx.amount;
      }
    }

    // Insight 1: Budget exceeded
    for (var entry in spending.entries) {
      if (entry.value > budgets[entry.key]!) {
        final exceeded = entry.value - budgets[entry.key]!;
        insights.add(
          '⚠️ ${entry.key} budget exceeded by Rp ${exceeded.toStringAsFixed(0)}',
        );
      }
    }

    // Insight 2: Highest spending category
    if (spending.isNotEmpty) {
      final highest =
          spending.entries.reduce((a, b) => a.value > b.value ? a : b);
      final percentage = (highest.value / totalExpense * 100);
      insights.add(
        '💰 ${highest.key} is your top spending (${percentage.toStringAsFixed(1)}%)',
      );
    }

    // Insight 3: Savings opportunity
    double totalBudget = budgets.values.reduce((a, b) => a + b);
    if (totalExpense < totalBudget) {
      final saved = totalBudget - totalExpense;
      insights.add(
        '🎉 You\'re saving Rp ${saved.toStringAsFixed(0)} from your budget!',
      );
    }

    // Insight 4: Average daily spending
    final avgDaily = totalExpense / params.month;
    insights.add(
      '📊 Your average daily spending is Rp ${avgDaily.toStringAsFixed(0)}',
    );

    return insights.take(3).toList();
  },
);

// Recommendations
final spendingRecommendationsProvider =
    FutureProvider.family<String, String>((ref, category) async {
  const recommendations = {
    'Food':
        'Try meal planning and cooking at home to reduce food expenses. Consider weekly meal prep.',
    'Transport':
        'Carpool or use public transportation more often to save on transport costs.',
    'Shopping':
        'Make a shopping list before going out and avoid impulse purchases.',
    'Entertainment':
        'Look for free or low-cost entertainment options and set a monthly entertainment budget.',
    'Health':
        'Preventive care and regular exercise can reduce healthcare expenses.',
    'Education':
        'Take advantage of free online courses and educational resources.',
    'Utilities':
        'Use energy-efficient appliances and monitor your usage to reduce utility bills.',
    'Other':
        'Review miscellaneous expenses monthly and categorize them properly.',
  };
  return recommendations[category] ?? 'Track this category and set a budget.';
});
