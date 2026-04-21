import 'package:flutter/material.dart';
import 'package:jpax_online/core/theme/app_theme.dart';
import 'package:jpax_online/features/editor/presentation/pages/editor_page.dart';

void main() {
  runApp(const JpaxApp());
}

class JpaxApp extends StatefulWidget {
  const JpaxApp({super.key});

  @override
  State<JpaxApp> createState() => _JpaxAppState();
}

class _JpaxAppState extends State<JpaxApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JSON API Parser JPAX',
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
