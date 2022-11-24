import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/extentions.dart';
import 'package:money_management/screens/Home/bottom_navigation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  bool isFinished = false;
  @override
  Widget build(BuildContext context) {
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
                      SwipeableButtonView(
                        onFinish: (() async {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: const BottomNavigation(),
                                  type: PageTransitionType.fade));

                          setState(() {
                            isFinished = false;
                          });
                        }),
                        onWaitingProcess: (() async {
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            isFinished = true;
                          });
                        }),
                        activeColor: '#e4e5e6'.toColor(),
                        isFinished: isFinished,
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
