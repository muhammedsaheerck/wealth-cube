import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:money_management/db_functions/transactions/transaction_db.dart';
import 'package:money_management/models/transaction/transaction_model.dart';
import 'package:money_management/screens/transaction/view_transactions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//Screen Incom Pie Chart
class ScreenExpanseChart extends StatefulWidget {
  const ScreenExpanseChart({super.key});

  @override
  State<ScreenExpanseChart> createState() => _ScreenExpanseChartState();
}

class _ScreenExpanseChartState extends State<ScreenExpanseChart> {
  String dropdownsortpie = transactionSortList.first;
  List<TransactionModel> expenseChartData = [];
  @override
  void initState() {
    expenseChartData = TransactionDb.instence.expenseTransactionList.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
//DropDown Button - Sort Statistics
              DropdownButtonHideUnderline(
                  child: DropdownButton2(
                value: dropdownsortpie,
                items: transactionSortList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      onTap: () {
                        if (value == transactionSortList[0]) {
                          expenseChartData = TransactionDb
                              .instence.expenseTransactionList.value;
                        } else if (value == transactionSortList[1]) {
                          expenseChartData = TransactionDb
                              .instence.todayExpenseTtransactionList.value;
                        } else {
                          expenseChartData = TransactionDb
                              .instence.monthExpenseTtransactionList.value;
                        }
                      },
                      value: value,
                      child: Text(value));
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownsortpie = value!;
                  });
                },
                buttonPadding: const EdgeInsets.only(left: 10),
                style: Theme.of(context).textTheme.headline6,
                buttonWidth: 150,
                buttonHeight: 30,
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).primaryColor,
                ),
                dropdownMaxHeight: 200,
                dropdownWidth: 150,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).primaryColor,
                ),
                dropdownElevation: 1,
                scrollbarRadius: const Radius.circular(40),
                scrollbarAlwaysShow: true,
                scrollbarThickness: 5,
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: ValueListenableBuilder(
              valueListenable: TransactionDb.instence.expenseTransactionList,
              builder: (BuildContext context, List<TransactionModel> newModal,
                  Widget? _) {
//Transaction is Empty Seen this Content
                return newModal.isEmpty
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
//Show Income statistics
                    : SfCircularChart(
                        legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries>[
                            PieSeries<TransactionModel, String>(
                                dataSource: expenseChartData,
                                xValueMapper: (TransactionModel data, _) =>
                                    data.category.name,
                                yValueMapper: (TransactionModel data, _) =>
                                    data.amount.toInt(),
                                name: 'Expense',
                                // Enable data label
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true))
                          ]);
              }),
        )
      ],
    );
  }
}
