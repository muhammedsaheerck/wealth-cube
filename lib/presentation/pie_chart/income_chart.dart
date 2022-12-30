import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:money_management/presentation/all_transaction/view_transactions.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../infrastructure/transactions/transaction_db.dart';
import '../../models/transaction/transaction_model.dart';
import '../../application/all_transaction/pie/view_transaction_all.dart';

class ScreenIncomeChart extends StatelessWidget {
  const ScreenIncomeChart({super.key});

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

//dropdown sort pie chart
              DropdownButtonHideUnderline(
                  child: Consumer<ViewTransactionAllProvider>(
                builder: (context, valueprovider, child) => DropdownButton2(
                  value: valueprovider.dropdownSortValue,
                  items: transactionSortList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        onTap: () {
                          if (value == transactionSortList[0]) {
                            valueprovider.piChartDataList(
                                TransactionDb
                                    .instence.incomeTransactionList.value,
                                true,
                                false);
                          } else if (value == transactionSortList[1]) {
                            valueprovider.piChartDataList(
                                TransactionDb
                                    .instence.todayIncomeTtransactionList.value,
                                true,
                                false);
                          } else {
                            valueprovider.piChartDataList(
                                TransactionDb
                                    .instence.monthIncomeTtransactionList.value,
                                true,
                                false);
                          }
                        },
                        value: value,
                        child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    valueprovider.onChanged(value!, true, false);
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
                ),
              )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Consumer<ViewTransactionAllProvider>(
            builder: (context, valueprovider, child) => ValueListenableBuilder(
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
                                  dataSource: valueprovider.incomechartData,
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
          ),
        )
      ],
    );
  }
}
