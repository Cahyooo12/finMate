import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/local_transaction_datasource.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';

final transactionDatasourceProvider = Provider<LocalTransactionDatasource>((ref) {
  return LocalTransactionDatasource();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final datasource = ref.watch(transactionDatasourceProvider);
  return TransactionRepositoryImpl(localDatasource: datasource);
});

final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getAllTransactions();
});

final transactionsByCategoryProvider =
    FutureProvider.family<List<TransactionModel>, String>((ref, category) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactionsByCategory(category);
});

final transactionsByTypeProvider =
    FutureProvider.family<List<TransactionModel>, String>((ref, type) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactionsByType(type);
});

final transactionsByMonthProvider = FutureProvider.family<
    List<TransactionModel>,
    ({int month, int year})>((ref, params) async {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getTransactionsByMonth(params.month, params.year);
});
