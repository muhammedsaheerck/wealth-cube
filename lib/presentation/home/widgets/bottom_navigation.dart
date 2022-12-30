import 'package:flutter/material.dart';
import 'package:money_management/presentation/home/screen_home.dart';
import 'package:money_management/presentation/add_transaction/screen_add_note.dart';
import 'package:money_management/presentation/category/screen_category.dart';
import 'package:money_management/presentation/pie_chart/screen_pychart.dart';
import 'package:money_management/presentation/settings/screen_settings.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';
import '../../../infrastructure/category/category_db.dart';
import '../../../infrastructure/transactions/transaction_db.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

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
        children: [
          const ScreenHome(),
          const ScreenCategory(),
          ScreenAddNote(),
          const ScreenPychart(),
          const ScreenSettings(),
        ],
      ),
    );
  }
}
