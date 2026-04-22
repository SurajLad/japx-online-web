import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/json.dart' as highlight_json;
import 'package:japx/japx.dart';
import 'package:japx_online/core/constants/app_constants.dart';

import 'package:japx_online/core/theme/app_colors.dart';
import 'package:japx_online/features/editor/data/services/json_validator.dart';
import 'package:japx_online/features/editor/domain/models/json_diagnostic.dart';
import 'package:japx_online/features/editor/presentation/widgets/about_popup.dart';
import 'package:japx_online/features/editor/presentation/widgets/error_panel.dart';
import 'package:japx_online/features/editor/presentation/widgets/json_editor_panel.dart';
import 'package:japx_online/features/editor/presentation/widgets/sidebar.dart';
import 'package:japx_online/features/editor/presentation/widgets/status_bar.dart';
import 'package:japx_online/features/editor/presentation/widgets/top_bar.dart';
import 'package:japx_online/features/model_generator/data/services/dart_model_generator.dart';
import 'package:japx_online/features/model_generator/domain/models/generated_model.dart';
import 'package:japx_online/features/model_generator/presentation/widgets/model_generator_panel.dart';

class EditorPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const EditorPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late final CodeController _inputController;
  late final CodeController _outputController;

  final JsonValidator _validator = JsonValidator();
  final DartModelGenerator _dartGenerator = DartModelGenerator();

  List<JsonDiagnostic> _diagnostics = [];
  GeneratedModel? _generatedModel;
  Map<String, dynamic>? _lastParsedOutput;
  Timer? _debounceTimer;

  int _inputLine = 1;
  int _inputColumn = 1;

  @override
  void initState() {
    super.initState();
    _inputController = CodeController(
      text: '',
      language: highlight_json.json,
    );
    _outputController = CodeController(
      text: '',
      language: highlight_json.json,
    );

    _inputController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _validateInput();
      _updateCursorPosition();
    });
  }

  void _validateInput() {
    final text = _inputController.text;
    final diagnostics = _validator.validate(text);
    if (mounted) {
      setState(() => _diagnostics = diagnostics);
    }
  }

  void _updateCursorPosition() {
    final text = _inputController.text;
    final selection = _inputController.selection;
    if (selection.baseOffset < 0) return;

    final offset = selection.baseOffset.clamp(0, text.length);
    int line = 1;
    int column = 1;
    for (int i = 0; i < offset; i++) {
      if (text[i] == '\n') {
        line++;
        column = 1;
      } else {
        column++;
      }
    }

    if (mounted) {
      setState(() {
        _inputLine = line;
        _inputColumn = column;
      });
    }
  }

  void _onTransform() {
    final text = _inputController.text.trim();
    if (text.isEmpty) {
      _showSnackBar('Please enter JSON to transform.');
      return;
    }

    try {
      final decoded = jsonDecode(text);
      final parsed = Japx.decode(decoded);
      final prettyJson = _prettyPrint(parsed);
      _outputController.text = prettyJson;
      setState(() {
        _lastParsedOutput = parsed;
      });
    } catch (error) {
      _showSnackBar('Unable to parse the entered JSON. Check for errors.');
    }
  }

  void _onAutoFormat() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    try {
      final decoded = jsonDecode(text);
      _inputController.text = _prettyPrint(decoded);
    } catch (_) {
      _showSnackBar('Cannot auto-format: JSON has syntax errors.');
    }
  }

  void _onClear() {
    _inputController.text = '';
    _outputController.text = '';
    setState(() {
      _diagnostics = [];
      _generatedModel = null;
      _lastParsedOutput = null;
    });
  }

  void _onGenerateModel() {
    if (_lastParsedOutput == null) {
      _showSnackBar('Transform JSON first before generating a model.');
      return;
    }

    try {
      final model = _dartGenerator.generate(_lastParsedOutput!);
      setState(() => _generatedModel = model);
    } catch (e) {
      _showSnackBar('Error generating model: ${e.toString()}');
    }
  }

  void _onCopyOutput() async {
    final text = _outputController.text;
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Copied to clipboard!');
  }

  void _onCopyInput() async {
    final text = _inputController.text;
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Copied to clipboard!');
  }

  String _prettyPrint(dynamic jsonObject) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(jsonObject);
  }

  String _getFileSize(String text) {
    final bytes = utf8.encode(text).length;
    if (bytes < 1024) return '$bytes B';
    final kb = (bytes / 1024).toStringAsFixed(1);
    return '$kb KB';
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _loadSampleJson() {
    _inputController.text = AppConstants.sampleJson;
    _onInputChanged();
    _showSnackBar('Sample JSON loaded!');
  }

  void _showAboutPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'About',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            type: MaterialType.transparency,
            child: AboutPopup(
              onClose: () => Navigator.of(context).pop(),
              onTrySample: () {
                Navigator.of(context).pop();
                _loadSampleJson();
              },
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Scaffold(
      backgroundColor: bgColor,
      body: Row(
        children: [
          // ── Sidebar ─────────────────────────────────
          Sidebar(onAboutTap: _showAboutPopup),

          // ── Main Content ────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top Bar
                TopBar(
                  isDarkMode: isDark,
                  onToggleTheme: widget.onToggleTheme,
                  onAutoFormat: _onAutoFormat,
                  onClear: _onClear,
                  onTransform: _onTransform,
                ),

                // Editor panels
                Expanded(
                  child: Row(
                    children: [
                      // ── Input Panel ──────────────────
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 6, 0),
                          child: Column(
                            children: [
                              Expanded(
                                child: JsonEditorPanel(
                                  title: 'Input JSON',
                                  panelNumber: 1,
                                  controller: _inputController,
                                  isDarkMode: isDark,
                                  readOnly: false,
                                  diagnostics: _diagnostics,
                                  fileSize: _getFileSize(_inputController.text),
                                  onCopy: _onCopyInput,
                                ),
                              ),
                              // Error panel
                              if (_diagnostics.isNotEmpty)
                                ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 180),
                                  child: ErrorPanel(
                                    diagnostics: _diagnostics,
                                    isDarkMode: isDark,
                                  ),
                                ),
                              // Status bar
                              StatusBar(
                                isDarkMode: isDark,
                                line: _inputLine,
                                column: _inputColumn,
                                spaces: 2,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),

                      // ── Output Panel ─────────────────
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 12, 12, 0),
                          child: Column(
                            children: [
                              Expanded(
                                child: JsonEditorPanel(
                                  title: 'Output (Flattened JSON)',
                                  panelNumber: 2,
                                  controller: _outputController,
                                  isDarkMode: isDark,
                                  readOnly: true,
                                  fileSize:
                                      _getFileSize(_outputController.text),
                                  onCopy: _onCopyOutput,
                                ),
                              ),
                              StatusBar(
                                isDarkMode: isDark,
                                line: 1,
                                column: 1,
                                spaces: 2,
                                onCopy: _onCopyOutput,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Model Generator Panel ───────────────────
          ModelGeneratorPanel(
            isDarkMode: isDark,
            generatedModel: _generatedModel,
            onGenerate: _onGenerateModel,
          ),
        ],
      ),
    );
  }
}
