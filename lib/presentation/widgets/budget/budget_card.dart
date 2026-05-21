import 'package:flutter/material.dart';
import '../../../core/widgets/base/custom_card.dart';

class BudgetCard extends StatelessWidget {
  final String category;
  final double limit;
  final double spent;
  final Color color;

  const BudgetCard({
    Key? key,
    required this.category,
    required this.limit,
    required this.spent,
    required this.color,
  }) : super(key: key);

  double get percentage => spent / limit;
  bool get isExceeded => spent > limit;

  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},-';
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: isExceeded
          ? Colors.red[50]
          : color.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExceeded ? Colors.red : color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage > 1 ? 1 : percentage,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                isExceeded ? Colors.red : color,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ${formatCurrency(spent)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Limit: ${formatCurrency(limit)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (isExceeded)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '⚠️ Exceeded by ${formatCurrency(spent - limit)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
