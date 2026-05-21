import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime dateTime;

  @HiveField(5)
  late String description;

  @HiveField(6)
  late String type; // 'income' or 'expense'

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.dateTime,
    required this.description,
    required this.type,
  });
}
