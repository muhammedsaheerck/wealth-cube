import 'package:hive/hive.dart';
import 'package:money_management/models/category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String purpos;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final CategoryModel category;

  @HiveField(5)
  final CategoryType type;

  TransactionModel(
      {required this.purpos,
      required this.amount,
      required this.category,
      required this.date,
      required this.type}) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
