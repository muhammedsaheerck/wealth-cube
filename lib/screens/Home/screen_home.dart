import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/screens/transaction/view_transactions.dart';
import '../../db_functions/transactions/transaction_db.dart';
import '../../models/category/category_model.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDb.instence.refresh;

    return Scaffold(
//Stack
      body: Stack(
        children: [
// container 1-
          Padding(
            padding: const EdgeInsets.only(top: 310, bottom: 50),
            child: Column(
              children: [
                ListTile(
                    leading: Text(
                      'Recent Transactions ',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).secondaryHeaderColor,
                            wordSpacing: 1),
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    const ScreenTransactions())));
                      },
                      child: Text('View All',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                    )),
//container-1 -Expanded -show latest Transactions
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable:
                          TransactionDb.instence.transactionListNotifier,
                      builder: (BuildContext ctx,
                          List<TransactionModel> newList, Widget? _) {
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
//No Transaction Found- display This content
                          child: newList.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add_to_photos,
                                      size: 50,
                                      color: Colors.black26,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'No Transaction Found!',
                                      style: GoogleFonts.nunito(
                                        textStyle: const TextStyle(
                                          color: Colors.black26,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
//Transaction Found - Display last 7  Transactions
                              : ListView.builder(
                                  itemCount:
                                      (newList.length < 4 ? newList.length : 4),
                                  itemBuilder: (context, index) {
                                    final value = newList[index];
                                    return Slidable(
                                      key: Key(value.id!),
                                      startActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                              onPressed: ((context) {
//Delete Current Transaction list
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
                                                              fontSize: 18),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
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
                                                                        .headline6),
                                                              )),
                                                          ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Theme.of(
                                                                              context)
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
                                                                        .headline6),
                                                              ))
                                                        ],
                                                      );
                                                    }));
                                              }),
                                              icon: Icons.delete,
                                              foregroundColor: Colors.red,
                                              label: 'Delete',
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
                                            child: Text(parseDate(value.date)),
                                          ),
                                          trailing:
                                              value.type == CategoryType.income
                                                  ? Text(
                                                      '₹ ${value.amount.toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      '₹ ${value.amount.toString()}',
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
                                ),
                        );
                      }),
                )
              ],
            ),
          ),
//container 2-bottom Roundable
          Container(
            height: 290,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(70),
                  bottomRight: Radius.circular(70)),
            ),
          ),
//container 3- Total transactions
          ValueListenableBuilder(
              valueListenable: TransactionDb.instence.transactionListNotifier,
              builder: (BuildContext context, List<TransactionModel> newList,
                  Widget? _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20)),
                        width: 330,
                        height: 140,
                        child: BlurryContainer(
                          elevation: 10,
                          blur: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Total Income
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Income',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ' ${TransactionDb.instence.addTotalTransaction()[1].toString()}',
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.green),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              //Total balance
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Balance',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      TransactionDb.instence
                                          .addTotalTransaction()[0]
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 25, color: Colors.white))
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //Total Expense
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Expenses',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      TransactionDb.instence
                                          .addTotalTransaction()[2]
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.red))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
/*Stack End*/
    );
  }

//parseDate -year/month/day
  String parseDate(DateTime dates) {
    final date = DateFormat.yMMMd().format(dates);
    final splitadate = date.split(' ');
    return '${splitadate[1]} ${splitadate.first} ${splitadate.last}';
  }
}
