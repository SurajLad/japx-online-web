import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/material.dart';
import 'package:japx_online/core/theme/app_theme.dart';
import 'package:japx_online/features/editor/presentation/pages/editor_page.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const JapxApp());

  // Signal the loader to hide once the app is initialized
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _hideSplashLoader();
  });
}

void _hideSplashLoader() {
  try {
    // Call the global hideLoader function defined in index.html
    (web.window as JSObject).callMethod('hideLoader'.toJS);
  } catch (e) {
    // Fallback if the JS function is not available or interop fails
  }
}

class JapxApp extends StatefulWidget {
  const JapxApp({super.key});

  @override
  State<JapxApp> createState() => _JapxAppState();
}

class _JapxAppState extends State<JapxApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(
      () {
        _themeMode =
            _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JSON API Parser JAPX',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: EditorPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
