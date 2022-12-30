import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  //Theme Dark
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromRGBO(1, 1, 1, 1),
    primaryColor: const Color.fromRGBO(253, 191, 45, 1),
    cardColor: const Color.fromRGBO(21, 21, 37, 1),
    secondaryHeaderColor: const Color.fromRGBO(253, 253, 253, 1),
    splashColor: const Color.fromRGBO(1, 1, 1, 1),
    textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: GoogleFonts.nunito().fontFamily)),
    backgroundColor: const Color.fromRGBO(41, 83, 150, 1),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(1, 1, 1, 1),
    ),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Color.fromRGBO(253, 191, 45, 1),
      titleTextStyle: TextStyle(
        color: Colors.black,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    dialogTheme: DialogTheme(
        backgroundColor: const Color.fromRGBO(21, 21, 37, 1),
        iconColor: Colors.black,
        contentTextStyle: const TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2),
  );
//Theme Lighht
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromRGBO(248, 248, 255, 1),
    primaryColor: const Color.fromRGBO(0, 65, 106, 1),
    cardColor: const Color.fromRGBO(212, 223, 244, 1),
    splashColor: const Color.fromRGBO(0, 65, 106, 1),
    secondaryHeaderColor: Colors.black,
    textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: GoogleFonts.nunito().fontFamily)),
    backgroundColor: const Color.fromRGBO(0, 65, 106, 1),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color.fromRGBO(248, 248, 255, 1),
    ),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Color.fromRGBO(0, 65, 106, 1),
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        iconColor: Colors.black,
        contentTextStyle: const TextStyle(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2),
  );
}