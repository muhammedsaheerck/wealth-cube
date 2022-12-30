import 'package:flutter/cupertino.dart';
import 'package:money_management/infrastructure/transactions/transaction_db.dart';
import 'package:money_management/presentation/all_transaction/view_transactions.dart';

import '../../../models/transaction/transaction_model.dart';

class ViewTransactionAllProvider extends ChangeNotifier {
  List<TransactionModel> valueFound =
      TransactionDb.instence.transactionListNotifier.value;
  List<TransactionModel> expenseChartData =
      TransactionDb.instence.expenseTransactionList.value;
  List<TransactionModel> incomechartData =
      TransactionDb.instence.incomeTransactionList.value;

  String dropdownValue = transactionFilterList.first;
  String dropdownSortValue = transactionSortList.first;

  void onChanged(String value, bool val, bool viewTransaction) {
    if (viewTransaction == true) {
      if (val == true) {
        dropdownValue = value;
      } else {
        dropdownSortValue = value;
      }
    } else {
      dropdownSortValue = value;
    }

    notifyListeners();
  }

  void dateRange(List<TransactionModel> newValue) {
    valueFound = newValue;
    notifyListeners();
  }

  void piChartDataList(
      List<TransactionModel> chartList, bool income, bool expense) {
    if (expense == true) {
      expenseChartData = chartList;
    
    } else {
      incomechartData = chartList;
    }
  notifyListeners();
  }
}
