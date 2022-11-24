import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_management/db_functions/category/category_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/models/transaction/transaction_model.dart';

//db name
const transactionDbName = 'transactionDbName';

//db functions(abstract)
abstract class TransactionDbFuncions {
  Future<List<TransactionModel>> getAllTransaction();
  Future<void> insertTransaction(TransactionModel value);
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(index, TransactionModel value);
}

//inherit abstract class
class TransactionDb with ChangeNotifier implements TransactionDbFuncions {
//singlton method-named constractor
  TransactionDb._internal();
  static TransactionDb instence = TransactionDb._internal();

  factory TransactionDb() {
    return instence;
  }

//db list
  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> incomeTransactionList =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseTransactionList =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> todayAllTtransactionList =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> todayIncomeTtransactionList =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> todayExpenseTtransactionList =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> monthAllTtransactionList =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthIncomeTtransactionList =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> monthExpenseTtransactionList =
      ValueNotifier([]);

//Insert Transaction
  @override
  Future<void> insertTransaction(TransactionModel object) async {
    final transactiondb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactiondb.put(object.id, object);
  }

//get transaction
  @override
  Future<List<TransactionModel>> getAllTransaction() async {
    final transactiondb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactiondb.values.toList();
  }

//refresh ui
  Future<void> refresh() async {
    final list = await getAllTransaction();
    list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(list);
    transactionListNotifier.notifyListeners();

//filter trnsaction  function- income,expense
    incomeTransactionList.value.clear();
    expenseTransactionList.value.clear();
    await Future.forEach(list, (TransactionModel transactionobj) {
      if (transactionobj.type == CategoryType.income) {
        incomeTransactionList.value.add(transactionobj);
      } else {
        expenseTransactionList.value.add(transactionobj);
      }
      incomeTransactionList.notifyListeners();
      expenseTransactionList.notifyListeners();
    });
//sort function today
    todayAllTtransactionList.value.clear();
    todayIncomeTtransactionList.value.clear();
    todayExpenseTtransactionList.value.clear();
    await Future.forEach(list, (TransactionModel transactionobj) {
      if (transactionobj.type == CategoryType.income) {
        if (transactionobj.date ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)) {
          todayIncomeTtransactionList.value.add(transactionobj);
          todayAllTtransactionList.value.add(transactionobj);
        }
      } else {
        if (transactionobj.date ==
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)) {
          todayExpenseTtransactionList.value.add(transactionobj);
          todayAllTtransactionList.value.add(transactionobj);
        }
      }
      todayAllTtransactionList.notifyListeners();
      todayIncomeTtransactionList.notifyListeners();
      todayExpenseTtransactionList.notifyListeners();
    });

//sort Month
    monthAllTtransactionList.value.clear();
    monthIncomeTtransactionList.value.clear();
    monthExpenseTtransactionList.value.clear();
    await Future.forEach(list, (TransactionModel transactionobj) {
      if (transactionobj.type == CategoryType.income) {
        if (transactionobj.date.month == DateTime.now().month) {
          monthIncomeTtransactionList.value.add(transactionobj);
          monthAllTtransactionList.value.add(transactionobj);
        }
      } else {
        if (transactionobj.date.month == DateTime.now().month) {
          monthExpenseTtransactionList.value.add(transactionobj);
          monthAllTtransactionList.value.add(transactionobj);
        }
      }
      monthAllTtransactionList.notifyListeners();
      monthIncomeTtransactionList.notifyListeners();
      monthExpenseTtransactionList.notifyListeners();
    });
  }

//delete transaction
  @override
  Future<void> deleteTransaction(String id) async {
    final transactiondb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactiondb.delete(id);
    refresh();
  }

//Add total transaction
  addTotalTransaction() {
    double? newIncome = 0;
    double? newExpense = 0;
    double? total = 0;

    for (var i = 0; i < monthAllTtransactionList.value.length; i++) {
      final values = monthAllTtransactionList.value[i];
      if (values.type == CategoryType.income) {
        newIncome = newIncome! + values.amount;
      } else {
        newExpense = newExpense! + values.amount;
      }
      total = newIncome! - newExpense!;
    }
    return [total!, newIncome!, newExpense!];
  }

//reset all datas
  resetAllDatas() async {
    final transactiondb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactiondb.clear();
    await CategoryDb.instance.resetAllCategory();
  }
//update Ttransaction
  @override
  Future<void> updateTransaction(index, TransactionModel value) async {
    final transactiondb =
        await Hive.openBox<TransactionModel>(transactionDbName);
    transactiondb.putAt(index, value);
  }

  
}
