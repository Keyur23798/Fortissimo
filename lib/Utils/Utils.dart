import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static Color get appRed => const Color(0xffec4d37);
  static Color get appBlack => const Color(0xff000000);
  static Color get appBg => const Color(0xfff1f2e9);
  static Color get appWhite => const Color(0xffffffff);
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class Utils {
  progressDialogue(BuildContext context) {
    //set up the AlertDialog
    AlertDialog alert=AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    showDialog(
      //prevent outside touch
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.7),
      context:context,
      builder: (BuildContext context) {
        //prevent Back button press
        return WillPopScope(
            onWillPop: null,
            child: alert);
      },
    );
  }
}