import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/extentions.dart';
import 'package:money_management/application/splash/splash_provider.dart';
import 'package:money_management/presentation/home/widgets/bottom_navigation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  // bool isFinished = false;
  @override
  Widget build(BuildContext context) {
    print("2");
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              'asset/save-money.png',
              width: 130,
            )),
            const SizedBox(
              height: 10,
            ),
            Text('Wealth Cube',
                style: GoogleFonts.ptSerif(
                  textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 250,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('TRACK MONEY\nSAVE MONEY',
                              style: GoogleFonts.nunito(
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  letterSpacing: 1,
                                  wordSpacing: 1)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<SplashProvider>(
                        builder: (context, value, child) => SwipeableButtonView(
                          onFinish: (() async {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: BottomNavigation(),
                                    type: PageTransitionType.fade));

                            value.splashChange(false);
                          }),
                          onWaitingProcess: (() async {
                            await Future.delayed(const Duration(seconds: 1));

                            value.splashChange(true);
                          }),
                          activeColor: '#e4e5e6'.toColor(),
                          isFinished:
                              Provider.of<SplashProvider>(context).isFinished,
                          buttonWidget: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.black,
                          ),
                          buttonText: 'Get Started',
                          buttontextstyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
