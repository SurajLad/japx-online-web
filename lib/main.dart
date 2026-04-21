import 'package:flutter/material.dart';
import 'package:japx_online/core/theme/app_theme.dart';
import 'package:japx_online/features/editor/presentation/pages/editor_page.dart';

void main() {
  runApp(const JapxApp());
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
