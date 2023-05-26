import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class MyThemes {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: const Color(0x00FF7722),
    // bottomSheetTheme: const BottomSheetThemeData(
    //     backgroundColor: Color.fromARGB(255, 20, 27, 30), elevation: 0),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: const Color(0x00FF7722),
    // bottomSheetTheme:
    //     const BottomSheetThemeData(backgroundColor: Colors.white, elevation: 0),
  );
}
