import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyStyle {
  Color darkColor = Color(0xff3b3d00);
  Color primaryColors = Color(0xff686716);

  Widget showProgress() {
    return Center(child: CircularProgressIndicator());
  }

  TextStyle whiteText() => TextStyle(color: Colors.white);

  TextStyle darkText() => TextStyle(color: darkColor);

  TextStyle pinkText() => TextStyle(color: Colors.pink);

  TextStyle titleH1() => GoogleFonts.dancingScript(
        textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: darkColor,
        ),
      );

  MyStyle();
}
