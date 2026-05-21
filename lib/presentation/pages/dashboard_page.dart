import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/navigation/custom_appbar.dart';
import '../../core/widgets/layout/app_scaffold.dart';
import '../widgets/dashboard/greeting_header.dart';
import '../widgets/dashboard/balance_section.dart';
import '../widgets/dashboard/expense_summary.dart';
import '../widgets/dashboard/recent_transactions.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'finMate',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: 24),
              const BalanceSection(),
              const SizedBox(height: 24),
              const ExpenseSummary(),
              const SizedBox(height: 24),
              const RecentTransactions(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add transaction
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
