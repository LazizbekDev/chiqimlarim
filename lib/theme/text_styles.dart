import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

final TextStyle displayLarge = GoogleFonts.montserrat(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: accentColor, // Coral pink for header text
);

final TextStyle bodyLarge = GoogleFonts.roboto(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: darkGray, // Dark gray for item names
);

final TextStyle bodyMedium = GoogleFonts.roboto(
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  color: lightGray, // Lighter gray for prices
);
