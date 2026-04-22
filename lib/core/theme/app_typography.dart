import 'package:flutter/material.dart';

/// Typography styles using locally bundled fonts.
/// JetBrains Mono for code, Inter for UI elements.
class AppTypography {
  AppTypography._();

  // ── Font Families ──────────────────────────────────────
  static const String codeFontFamily = 'JetBrainsMono';
  static const String uiFontFamily = 'FiraCode';

  // ── Code Styles ────────────────────────────────────────
  static const TextStyle codeStyle = TextStyle(
    fontFamily: codeFontFamily,
    fontSize: 13,
    height: 1.6,
    letterSpacing: 0.3,
  );

  static const TextStyle codeStyleSmall = TextStyle(
    fontFamily: codeFontFamily,
    fontSize: 11,
    height: 1.5,
    letterSpacing: 0.2,
  );

  // ── UI Styles ──────────────────────────────────────────
  static const TextStyle heading1 = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle sidebarItem = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle sidebarSection = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: uiFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}
