import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


TextStyle customStyle(Color color, double fontSize, FontWeight fontWeight){
    return GoogleFonts.roboto(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            );
}

TextStyle customStyleLetterSpace(Color color, double fontSize, FontWeight fontWeight, double letterSpace){
    return GoogleFonts.roboto(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpace
          );
}