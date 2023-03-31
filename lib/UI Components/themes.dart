import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static ThemeData darkTheme = ThemeData(
    // appBarTheme: AppBarTheme(
    //   backgroundColor: Colors.grey.shade300.withOpacity(0.6),
    //   foregroundColor: Colors.black,
    // ),
    // tabBarTheme: TabBarTheme(
    //   indicatorColor: Colors.deepOrange,
    //   labelColor: Colors.deepOrange.shade800,
    //   dividerColor: Colors.transparent,
    //   indicatorSize: TabBarIndicatorSize.label,
    //   unselectedLabelColor: Colors.black,
    // ),
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: const Color(0x00FF7722),
    fontFamily: GoogleFonts.lato().toString(),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromARGB(255, 20, 27, 30), elevation: 0),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: const Color(0x00FF7722),
    fontFamily: GoogleFonts.lato().toString(),
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: Colors.white, elevation: 0),
  );
}
