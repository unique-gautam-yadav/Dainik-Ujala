import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static ThemeData darkTheme = ThemeData(
    appBarTheme:
        AppBarTheme(backgroundColor: Colors.grey.shade300.withOpacity(0.6)),
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: Colors.deepOrangeAccent.shade700,
    primarySwatch: Colors.deepOrange,
    shadowColor: const Color.fromARGB(255, 86, 24, 5),
    fontFamily: GoogleFonts.lato().toString(),
    scaffoldBackgroundColor: const Color.fromARGB(255, 20, 27, 30),
    cardColor: const Color.fromARGB(255, 0, 12, 6),
    colorScheme: ColorScheme.dark(secondary: Colors.grey.shade500),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromARGB(255, 20, 27, 30), elevation: 0),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: Colors.deepOrangeAccent,
    primarySwatch: Colors.deepOrange,
    shadowColor: Colors.deepOrange.shade200,
    fontFamily: GoogleFonts.lato().toString(),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.deepOrange.shade50.withOpacity(.6),
    colorScheme: ColorScheme.light(secondary: Colors.deepOrange.shade200),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Colors.white, elevation: 0),
  );
}
