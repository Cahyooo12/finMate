import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class LocalTransactionDatasource {
  static const String boxName = 'transactions';

  Future<Box<TransactionModel>> get _box async {
    return Hive.box<TransactionModel>(boxName);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final box = await _box;
    await box.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final box = await _box;
    await box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final box = await _box;
    return box.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    final box = await _box;
    return box.values
        .where((tx) => tx.category == category)
        .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    final box = await _box;
    return box.values
        .where((tx) => tx.type == type)
        .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<List<TransactionModel>> getTransactionsByMonth(int month, int year) async {
    final box = await _box;
    return box.values
        .where((tx) => tx.dateTime.month == month && tx.dateTime.year == year)
        .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  Future<void> clearAllTransactions() async {
    final box = await _box;
    await box.clear();
  }
}
