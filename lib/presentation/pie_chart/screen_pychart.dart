import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/presentation/pie_chart/all_pie_chart.dart';
import 'package:money_management/presentation/pie_chart/expense_chart.dart';
import 'package:money_management/presentation/pie_chart/income_chart.dart';

//Screen Statistics - All,Income,Expense
class ScreenPychart extends StatefulWidget {
  const ScreenPychart({super.key});

  @override
  State<ScreenPychart> createState() => _ScreenPychartState();
}

class _ScreenPychartState extends State<ScreenPychart>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Theme.of(context).primaryColor,
          controller: _tabController,
          labelPadding: const EdgeInsets.only(top: 10, bottom: 10),
          indicatorWeight: 4,
          indicatorColor: Theme.of(context).primaryColor,
          labelStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          tabs: [
            Text(
              'All',
              style: GoogleFonts.nunito(),
            ),
            Text(
              'Income',
              style: GoogleFonts.nunito(),
            ),
            Text(
              'Expense',
              style: GoogleFonts.nunito(),
            ),
          ]),
      Expanded(
          child: TabBarView(controller: _tabController, children: [
        ScreenAllPieChart(),
        ScreenIncomeChart(),
        ScreenExpanseChart()
      ]))
    ]));
  }
}
