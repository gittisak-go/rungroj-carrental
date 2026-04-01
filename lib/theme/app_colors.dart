import 'package:flutter/material.dart';

const kPrimary    = Color(0xFFFF2D78);
const kSecondary  = Color(0xFF2979FF);
const kBackground = Color(0xFF0A0A12);
const kSurface    = Color(0xFF16161E);
const kSurface2   = Color(0xFF1E1E28);
const kAccent     = Color(0xFFFFE500);
const kSuccess    = Color(0xFF00FFC2);
const kError      = Color(0xFFFF453A);
const kDivider    = Color(0xFF2C2C2E);
const kTextHigh   = Color(0xFFFFFFFF);
const kTextMed    = Color(0xFFAAAAAA);
const kTextLow    = Color(0xFF555560);

const kGradientPrimary = LinearGradient(
  colors: [Color(0xFFFF2D78), Color(0xFFFF6B6B)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const kGradientBlue = LinearGradient(
  colors: [Color(0xFF2979FF), Color(0xFF00C2FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

TextStyle kHead(double size, {Color color = kTextHigh, FontWeight w = FontWeight.w700}) =>
    TextStyle(
      fontFamily: 'Urbanist',
      fontFamilyFallback: const ['NotoSansThai', 'Poppins'],
      fontSize: size,
      fontWeight: w,
      color: color,
    );

TextStyle kBody(double size, {Color color = kTextMed, FontWeight w = FontWeight.w400}) =>
    TextStyle(
      fontFamily: 'Poppins',
      fontFamilyFallback: const ['NotoSansThai'],
      fontSize: size,
      fontWeight: w,
      color: color,
    );
