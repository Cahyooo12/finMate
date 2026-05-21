import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/layout/app_scaffold.dart';
import '../../core/widgets/navigation/custom_appbar.dart';
import '../../core/widgets/states/empty_state.dart';
import '../../core/widgets/loaders/shimmer_loader.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transactions/transaction_tile.dart';
import 'add_transaction_page.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'Transactions',
        centerTitle: true,
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return EmptyState(
              title: 'No Transactions',
              message: 'Start by adding your first transaction',
              icon: Icons.credit_card_off,
              buttonLabel: 'Add Transaction',
              onRetry: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTransactionPage()),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionTile(
                transaction: transaction,
                onEdit: () {
                  // TODO: Navigate to edit page
                },
                onDelete: () {
                  // TODO: Delete transaction
                },
              );
            },
          );
        },
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ShimmerLoader(
                height: 80,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
