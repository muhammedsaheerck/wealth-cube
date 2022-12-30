import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/infrastructure/category/category_db.dart';
import 'package:money_management/presentation/category/expense_category.dart';
import 'package:money_management/presentation/category/income_category.dart';
import 'widgets/add_category_popup.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Theme.of(context).primaryColor,
            controller: _tabController,
            labelPadding: const EdgeInsets.only(top: 10, bottom: 10),
            indicatorWeight: 4,
            // indicatorColor: '#fcda03'.toColor(),
            indicatorColor: Theme.of(context).primaryColor,
            labelStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
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
          child: TabBarView(
              controller: _tabController,
              children: const [IncomCategory(), ExpenseCategory()]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 290),
          child: FloatingActionButton(
            // backgroundColor: Colors.indigo,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => showCategoryAdd(context),
            child: const Icon(Icons.add),
          ),
        )
      ],
    ));
  }
}
