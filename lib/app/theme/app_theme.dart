import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appThemeData = ThemeData(
    primaryColor: Colors.blueAccent,
    textTheme: GoogleFonts.arimoTextTheme(),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.blueAccent)));
