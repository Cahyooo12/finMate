import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsByCategory(String category);
  Future<List<TransactionModel>> getTransactionsByType(String type);
  Future<List<TransactionModel>> getTransactionsByMonth(int month, int year);
  Future<void> clearAllTransactions();
}
