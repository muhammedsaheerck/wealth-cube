import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/screens/transaction/view_transactions.dart';
import '../../db_functions/transactions/transaction_db.dart';
import '../../models/transaction/transaction_model.dart';

//Screen All Pie Chart
class ScreenAllPieChart extends StatefulWidget {
  const ScreenAllPieChart({super.key});

  @override
  State<ScreenAllPieChart> createState() => _ScreenAllPieChartState();
}

class _ScreenAllPieChartState extends State<ScreenAllPieChart> {
  String dropdownsortpie = transactionSortList.first;
  List<TransactionModel> chartData = [];
  @override
  void initState() {
    chartData = TransactionDb.instence.transactionListNotifier.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: ValueListenableBuilder(
              valueListenable: TransactionDb.instence.transactionListNotifier,
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
//All Pie chart - Income and Expense
                    : Column(
                        children: [
                          Text(
                            'All Transaction Statistics',
                            style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 250,
                                  child: PieChart(PieChartData(
                                      centerSpaceRadius: 0,
                                      sectionsSpace: 2,
                                      sections: [
                                        PieChartSectionData(
                                          title: TransactionDb.instence
                                              .addTotalTransaction()[1]
                                              .toString(),
                                          value: TransactionDb.instence
                                              .addTotalTransaction()[1],
                                          color: Colors.green.shade800,
                                          radius: 120,
                                        ),
                                        PieChartSectionData(
                                          title: TransactionDb.instence
                                              .addTotalTransaction()[2]
                                              .toString(),
                                          value: TransactionDb.instence
                                              .addTotalTransaction()[2],
                                          color: Colors.red.shade800,
                                          radius: 120,
                                        )
                                      ])),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Income'),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: const [
                                          CircleAvatar(
                                            radius: 8,
                                            backgroundColor: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Income'),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
              }),
        ),
      ],
    );
  }
}
