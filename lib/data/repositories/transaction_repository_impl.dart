import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local_transaction_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalTransactionDatasource localDatasource;

  TransactionRepositoryImpl({required this.localDatasource});

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    return await localDatasource.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    return await localDatasource.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    return await localDatasource.deleteTransaction(id);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return await localDatasource.getAllTransactions();
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    return await localDatasource.getTransactionsByCategory(category);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    return await localDatasource.getTransactionsByType(type);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByMonth(int month, int year) async {
    return await localDatasource.getTransactionsByMonth(month, year);
  }

  @override
  Future<void> clearAllTransactions() async {
    return await localDatasource.clearAllTransactions();
  }
}
