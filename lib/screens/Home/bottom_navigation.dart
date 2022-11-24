import 'package:flutter/material.dart';
import 'package:money_management/screens/Home/screen_home.dart';
import 'package:money_management/screens/transaction/screen_add_note.dart';
import 'package:money_management/screens/Category/screen_category.dart';
import 'package:money_management/screens/pie_chart/screen_pychart.dart';
import 'package:money_management/screens/settings/screen_settings.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import '../../db_functions/category/category_db.dart';
import '../../db_functions/transactions/transaction_db.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    CategoryDb.instance.refreshUI();
    TransactionDb.instence.refresh();
    TransactionDb.instence.addTotalTransaction();
    return Scaffold(
      extendBody: true,
//BottomNavigationBar
      bottomNavigationBar: RollingBottomBar(
          color: Theme.of(context).primaryColor,
          controller: _controller,
          items: const [
            RollingBottomBarItem(Icons.home),
            RollingBottomBarItem(Icons.category),
            RollingBottomBarItem(Icons.add_box_rounded),
            RollingBottomBarItem(Icons.bar_chart_rounded),
            RollingBottomBarItem(Icons.settings)
          ],
          activeItemColor: Theme.of(context).scaffoldBackgroundColor,
          enableIconRotation: true,
          onTap: (index) {
            _controller.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut);
          }),
//Screen View
      body: PageView(
        controller: _controller,
        children: const [
          ScreenHome(),
          ScreenCategory(),
          ScreenAddNote(),
          ScreenPychart(),
          ScreenSettings(),
        ],
      ),
    );
  }
}
