import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:money_management/screens/transaction/view_transactions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../db_functions/transactions/transaction_db.dart';
import '../../models/transaction/transaction_model.dart';

class ScreenIncomeChart extends StatefulWidget {
  const ScreenIncomeChart({super.key});

  @override
  State<ScreenIncomeChart> createState() => _ScreenIncomeChartState();
}

class _ScreenIncomeChartState extends State<ScreenIncomeChart> {
  String dropdownsortpie = transactionSortList.first;
  List<TransactionModel> incomechartData = [];
  @override
  void initState() {
    incomechartData = TransactionDb.instence.incomeTransactionList.value;
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
              DropdownButtonHideUnderline(
                  child: DropdownButton2(
                value: dropdownsortpie,
                items: transactionSortList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      onTap: () {
                        if (value == transactionSortList[0]) {
                          incomechartData = TransactionDb
                              .instence.incomeTransactionList.value;
                        } else if (value == transactionSortList[1]) {
                          incomechartData = TransactionDb
                              .instence.todayIncomeTtransactionList.value;
                        } else {
                          incomechartData = TransactionDb
                              .instence.monthIncomeTtransactionList.value;
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
                style: Theme.of(context).textTheme.headline6,
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
              valueListenable: TransactionDb.instence.incomeTransactionList,
              builder: (BuildContext context, List<TransactionModel> newModel,
                  Widget? _) {
//Transaction is Empty Seen this Content
                return newModel.isEmpty
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
//Show Expense statistics
                    : SfCircularChart(
                        legend: Legend(isVisible: true),
                        //enable Tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries>[
                            PieSeries<TransactionModel, String>(
                                dataSource: incomechartData,
                                xValueMapper: (TransactionModel data, _) =>
                                    data.category.name,
                                yValueMapper: (TransactionModel data, _) =>
                                    data.amount.toInt(),
                                name: 'income',
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
