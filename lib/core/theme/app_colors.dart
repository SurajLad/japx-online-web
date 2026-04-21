import 'package:flutter/material.dart';

/// Centralized color constants for the JPAX Parser app.
/// Dark palette derived from the reference screenshot.
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentLight = Color(0xFF9F67FF);
  static const Color accentSurface = Color(0xFF2D1B69);

  // ── Dark Theme ─────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF1A1F2B);
  static const Color darkEditor = Color(0xFF0D1117);
  static const Color darkEditorGutter = Color(0xFF161B22);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkTextPrimary = Color(0xFFE6EDF3);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextMuted = Color(0xFF484F58);
  static const Color darkSidebar = Color(0xFF0D1117);
  static const Color darkSidebarActive = Color(0xFF1A1F2B);
  static const Color darkTopBar = Color(0xFF161B22);

  // ── Light Theme ────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF6F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F2F5);
  static const Color lightEditor = Color(0xFFFFFFFF);
  static const Color lightEditorGutter = Color(0xFFF6F8FA);
  static const Color lightBorder = Color(0xFFD0D7DE);
  static const Color lightTextPrimary = Color(0xFF1F2328);
  static const Color lightTextSecondary = Color(0xFF656D76);
  static const Color lightTextMuted = Color(0xFF8C959F);
  static const Color lightSidebar = Color(0xFFFFFFFF);
  static const Color lightSidebarActive = Color(0xFFF0F2F5);
  static const Color lightTopBar = Color(0xFFFFFFFF);

  // ── Semantic ───────────────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFF3D1414);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFF3D2E0A);
  static const Color success = Color(0xFF22C55E);
  static const Color info = Color(0xFF3B82F6);

  // ── Editor syntax (dark) ───────────────────────────────
  static const Color syntaxKey = Color(0xFF79C0FF);
  static const Color syntaxString = Color(0xFFA5D6FF);
  static const Color syntaxNumber = Color(0xFF56D4DD);
  static const Color syntaxBoolean = Color(0xFFFF7B72);
  static const Color syntaxNull = Color(0xFFFFA657);
}
