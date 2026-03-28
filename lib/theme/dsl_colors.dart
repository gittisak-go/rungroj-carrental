import 'package:flutter/material.dart';

/// DSL Color tokens สำหรับ RENTAL-R design system
/// dark theme จาก selected-frames-agent-prompt.md
class DslColors {
  DslColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF0066FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFFF2D87);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFFFFE500);

  // Dark background
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF16161E);
  static const Color onSurface = Color(0xFFF5F5F7);

  // Text
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFA1A1A6);
  static const Color hint = Color(0xFF636366);

  // Status
  static const Color success = Color(0xFF00FFC2);
  static const Color error = Color(0xFFFF453A);
  static const Color divider = Color(0xFF2C2C2E);

  static const Color transparent = Colors.transparent;

  /// Resolve color token name -> Color
  static Color resolve(String token) {
    switch (token) {
      case 'primary':
        return primary;
      case 'on_primary':
        return onPrimary;
      case 'secondary':
        return secondary;
      case 'on_secondary':
        return onSecondary;
      case 'accent':
        return accent;
      case 'background':
        return background;
      case 'surface':
        return surface;
      case 'on_surface':
        return onSurface;
      case 'primary_text':
        return primaryText;
      case 'secondary_text':
        return secondaryText;
      case 'hint':
        return hint;
      case 'success':
        return success;
      case 'error':
        return error;
      case 'divider':
        return divider;
      case 'transparent':
        return transparent;
      default:
        // Try parse as hex
        if (token.startsWith('#')) {
          return _hexToColor(token);
        }
        return primaryText;
    }
  }

  static Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff');
    if (hex.length == 9) buffer.write(hex.substring(7));
    buffer.write(hex.substring(1, 7));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // Radii tokens
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 28.0;
  static const double radiusFull = 9999.0;

  // Spacing tokens
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  static double resolveSpacing(String token) {
    switch (token) {
      case 'xs':
        return spacingXs;
      case 'sm':
        return spacingSm;
      case 'md':
        return spacingMd;
      case 'lg':
        return spacingLg;
      case 'xl':
        return spacingXl;
      default:
        return spacingMd;
    }
  }
}
