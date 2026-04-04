import 'package:flutter/material.dart';
import 'app_colors.dart';

final appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kBackground,
  primaryColor: kPrimary,
  colorScheme: const ColorScheme.dark(
    primary: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    error: kError,
  ),
  fontFamily: 'Urbanist',
  appBarTheme: const AppBarTheme(
    backgroundColor: kBackground,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontFamily: 'Urbanist',
      fontFamilyFallback: ['NotoSansThai'],
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: kTextHigh,
    ),
    iconTheme: IconThemeData(color: kTextHigh),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
  cardTheme: CardTheme(
    color: kSurface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kDivider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kDivider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kPrimary, width: 1.5),
    ),
    labelStyle: const TextStyle(color: kTextMed),
    hintStyle: const TextStyle(color: kTextLow),
  ),
  dividerColor: kDivider,
  useMaterial3: true,
);
