import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:money_management/infrastructure/transactions/transaction_db.dart';
import 'package:money_management/models/category/category_model.dart';
import 'package:money_management/presentation/all_transaction/widgets/update_transaction.dart';
import 'package:provider/provider.dart';
import '../../models/transaction/transaction_model.dart';
import '../../application/all_transaction/pie/view_transaction_all.dart';

const List<String> transactionFilterList = <String>['All', 'Income', 'Expense'];
const List<String> transactionSortList = <String>['All', 'Today', ' Month'];
ValueNotifier<List<TransactionModel>> dateRangeNotifier = ValueNotifier([]);

//Screen View All Transaction
class ScreenTransactions extends StatelessWidget {
  ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDb.instence.refresh();
    print('viewall');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
//AppBar
            AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                'Transactions',
                style: Theme.of(context).textTheme.headline6,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
//IconButton-Calender- Date Range Picker
                Consumer<ViewTransactionAllProvider>(
                  builder: (context, value, child) => IconButton(
                    onPressed: () async {
                      await pickDateRange(context);
                      // setState(() {
                      if (dateRangeNotifier.value.isEmpty) {
                        return value.dateRange([]);
                      } else {
                        value.dateRange(dateRangeNotifier.value);
                      }
                      // });
                    },
                    icon: const Icon(Icons.calendar_month),
                    color: Theme.of(context).iconTheme.color,
                  ),
                )
              ],
            ),
//Filtration (dropDown Button) Added Container
            Container(
              height: 50,
              color: Theme.of(context).primaryColor,
              child: ListTile(
//dropdown-Sort Transactions - All,today,month
                leading: DropdownButtonHideUnderline(
                    child: Consumer<ViewTransactionAllProvider>(
                  builder: (context, valuesprovider, child) => DropdownButton2(
                    value: valuesprovider.dropdownSortValue,
                    items: transactionSortList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          onTap: () {
                            if (value == transactionSortList[1]) {
                              if (valuesprovider.dropdownValue ==
                                  transactionFilterList[0]) {
                                valuesprovider.valueFound = TransactionDb
                                    .instence.todayAllTtransactionList.value;
                              } else if (valuesprovider.dropdownValue ==
                                  transactionFilterList[1]) {
                                valuesprovider.valueFound = TransactionDb
                                    .instence.todayIncomeTtransactionList.value;
                              } else if (valuesprovider.dropdownValue ==
                                  transactionFilterList[2]) {
                                valuesprovider.valueFound = TransactionDb
                                    .instence
                                    .todayExpenseTtransactionList
                                    .value;
                              }
                            } else if (value == transactionSortList[2]) {
                              if (valuesprovider.dropdownValue ==
                                  transactionFilterList[0]) {
                                valuesprovider.valueFound = TransactionDb
                                    .instence.monthAllTtransactionList.value;
                              } else if (valuesprovider.dropdownValue ==
                                  transactionFilterList[1]) {
                                valuesprovider.valueFound = TransactionDb
                                    .instence.monthIncomeTtransactionList.value;
                              } else if (valuesprovider.dropdownValue ==
                                  transactionFilterList[2]) {
                                valuesprovider.valueFound = TransactionDb
                                    .instence
                                    .monthExpenseTtransactionList
                                    .value;
                              }
                            }
                          },
                          value: value,
                          child: Text(value));
                    }).toList(),
                    onChanged: (value) {
                      valuesprovider.onChanged(value!, false, true);
                    },
                    dropdownMaxHeight: 200,
                    dropdownWidth: 150,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor,
                    ),
                    dropdownElevation: 2,
                    style: Theme.of(context).textTheme.headline6,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarAlwaysShow: true,
                    scrollbarThickness: 5,
                  ),
                )),
//DropDown Filter Transaction- Income,Expense,All
                trailing: DropdownButtonHideUnderline(
                    child: Consumer<ViewTransactionAllProvider>(
                  builder: (context, valueprovider, child) => DropdownButton2(
                    value: valueprovider.dropdownValue,
                    items: transactionFilterList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          onTap: () {
                            if (value == transactionFilterList[0]) {
                              valueprovider.valueFound = TransactionDb
                                  .instence.transactionListNotifier.value;
                              valueprovider.dropdownSortValue =
                                  transactionSortList.first;
                            } else if (value == transactionFilterList[1]) {
                              valueprovider.valueFound = TransactionDb
                                  .instence.incomeTransactionList.value;
                              valueprovider.dropdownSortValue =
                                  transactionSortList.first;
                            } else {
                              valueprovider.valueFound = TransactionDb
                                  .instence.expenseTransactionList.value;
                              valueprovider.dropdownSortValue =
                                  transactionSortList.first;
                            }
                          },
                          value: value,
                          child: Text(value));
                    }).toList(),
                    onChanged: (value) {
                      valueprovider.onChanged(value!, true, true);
                    },
                    dropdownMaxHeight: 200,
                    dropdownWidth: 140,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Theme.of(context).primaryColor,
                    ),
                    dropdownElevation: 2,
                    style: Theme.of(context).textTheme.headline6,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarAlwaysShow: true,
                    scrollbarThickness: 5,
                  ),
                )),
              ),
            ),
//Expanded Filtration container
            Expanded(
              child: Consumer<ViewTransactionAllProvider>(
                builder: (context, valueprovider, child) =>
                    ValueListenableBuilder(
                        valueListenable:
                            TransactionDb.instence.transactionListNotifier,
                        builder: (BuildContext ctx,
                            List<TransactionModel> newList, Widget? _) {
                          //No Transaction Found- display This content
                          return valueprovider.valueFound.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_to_photos,
                                      size: 50,
                                      color: Colors.black26,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('No Transaction Found!',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontSize: 20,
                                        )),
                                  ],
                                )
                              //Transaction Found - Display All Transaction List
                              : ListView.builder(
                                  itemCount: valueprovider.valueFound.length,
                                  itemBuilder: (context, index) {
                                    final value =
                                        valueprovider.valueFound[index];
                                    return Slidable(
                                      key: Key(value.id!),
                                      startActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            //Delete Current Transaction list
                                            SlidableAction(
                                              onPressed: ((context) {
                                                //delete Pop up
                                                showDialog(
                                                    context: context,
                                                    builder: ((context) {
                                                      return AlertDialog(
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        content: Text(
                                                            'Do you Delete This Transaction?',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 18)),
                                                        actions: [
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(context)
                                                                          .primaryColor),
                                                              onPressed: (() {
                                                                return Navigator
                                                                    .pop(
                                                                        context);
                                                              }),
                                                              child: Text(
                                                                  'Cancel',
                                                                  style: GoogleFonts.nunito(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6))),
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(context)
                                                                          .primaryColor),
                                                              onPressed: (() {
                                                                TransactionDb
                                                                    .instence
                                                                    .deleteTransaction(
                                                                        value
                                                                            .id!);

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }),
                                                              child: Text(
                                                                  'Delete',
                                                                  style: GoogleFonts.nunito(
                                                                      textStyle: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6)))
                                                        ],
                                                      );
                                                    }));
                                              }),
                                              icon: Icons.delete,
                                              foregroundColor: Colors.red,
                                              label: 'Delete',
                                            ),
                                            //Edit Current Transaction list
                                            SlidableAction(
                                              onPressed: ((context) {
                                                //move to Update Screen
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScreenUpdateTransaction(
                                                    index: index,
                                                    transactionModelobj: value,
                                                  ),
                                                ));
                                              }),
                                              icon: Icons.edit,
                                              foregroundColor: Colors.black,
                                              label: 'Edit',
                                            ),
                                          ]),
                                      //Transaction List Details
                                      child: Card(
                                        elevation: 1,
                                        color: Theme.of(context).cardColor,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: value.type ==
                                                      CategoryType.income
                                                  ? const Icon(
                                                      Icons.call_received,
                                                      color: Colors.green,
                                                    )
                                                  : const Icon(
                                                      Icons.call_made,
                                                      color: Colors.red,
                                                    )),
                                          title: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Text(
                                              value.category.name,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Text(
                                              parseDate(value.date),
                                            ),
                                          ),
                                          trailing:
                                              value.type == CategoryType.income
                                                  ? Text(
                                                      '??? ${value.amount.toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      '??? ${value.amount.toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String parseDate(DateTime dates) {
    final date = DateFormat.yMMMd().format(dates);
    return date;
  }

//DateRange Function
  Future pickDateRange(BuildContext context) async {
    dateRangeNotifier.value.clear();
//Manualy selected Date Range - open time
    DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 6),
    );

    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dateRange,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));
    if (newDateRange == null) {
      return;
    } else {
      final list = await TransactionDb.instence.getAllTransaction();
      await Future.forEach(list, (TransactionModel transactionobj) {
        if (transactionobj.date.isAfter(
                newDateRange.start.subtract(const Duration(days: 1))) &&
            transactionobj.date
                .isBefore(newDateRange.end.add(const Duration(days: 1)))) {
          dateRangeNotifier.value.add(transactionobj);
        }
        dateRangeNotifier.notifyListeners();
      });
    }
  }
}
