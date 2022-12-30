import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/presentation/home/widgets/bottom_navigation.dart';
import 'package:money_management/presentation/settings/privacy_policy.dart';
import 'package:money_management/presentation/settings/terms_conditions.dart';
import 'package:provider/provider.dart';
import '../../infrastructure/transactions/transaction_db.dart';
import '../../application/theme/theme_change.dart';

//Screen Settings
class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//Top Container-heading
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60)),
          ),
          child: Center(
            child: Text('Wealth Cube',
                style: GoogleFonts.ptSerif(
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6?.color,
                    letterSpacing: 1,
                  ),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
//Switch Theme
              Text(
                'Switch Theme',
                style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              Switch(
                activeColor: Theme.of(context).primaryColor,
                value: themeProvider.isDarkMode,
                onChanged: ((value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                }),
              ),
            ],
          ),
        ),
//Reset All Datas
        ListTile(
          title: Text(
            'Reset All',
            style: GoogleFonts.nunito(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          trailing: IconButton(
              onPressed: () {
//Reset Pop Up
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        content: Text(
                          'Do you Delete All Datas?',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18),
                        ),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              onPressed: (() {
                                return Navigator.pop(context);
                              }),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.nunito(
                                    textStyle:
                                        Theme.of(context).textTheme.headline6),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              onPressed: (() {
                                TransactionDb.instence.resetAllDatas();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            BottomNavigation())),
                                    (route) => true);
                              }),
                              child: Text(
                                'Delete All',
                                style: GoogleFonts.nunito(
                                    textStyle:
                                        Theme.of(context).textTheme.headline6),
                              ))
                        ],
                      );
                    }));
              },
              icon: Icon(
                Icons.refresh_sharp,
                size: 30,
                color: Colors.blue.shade500,
              )),
        ),
//About Us
        ListTile(
          title: Text(
            'About us',
            style: GoogleFonts.nunito(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          onTap: () {
            showModalBottomSheet(
                backgroundColor:
                    Theme.of(context).bottomSheetTheme.backgroundColor,
                context: context,
                builder: (BuildContext ctx) {
                  return SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                color: Theme.of(context).primaryColor,
                                elevation: 3,
                                shadowColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  'asset/save-money.png',
                                  height: 60,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text('Wealth Cube',
                                  style: GoogleFonts.ptSerif(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text('Developed By Muhammed Saheer CK',
                              style: GoogleFonts.nunito(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: (() {
                              Navigator.pop(ctx);
                            }),
                            child: Text('Cancel',
                                style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )))
                      ],
                    ),
                  );
                });
          },
        ),
//Privacy Policy
        ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const PrivacyPolicy())));
            },
            title: Text(
              'Privacy Policy',
              style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
            )),
        ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const ScreenTermsAndConditions())));
            },
            title: Text(
              'Terms & Conditions',
              style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800)),
            )),
      ]),
    );
  }
}
