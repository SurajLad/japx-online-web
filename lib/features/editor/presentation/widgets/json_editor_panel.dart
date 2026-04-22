import 'package:flutter/material.dart';

import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/github.dart';

import 'package:japx_online/core/theme/app_colors.dart';
import 'package:japx_online/core/theme/app_typography.dart';
import 'package:japx_online/features/editor/domain/models/json_diagnostic.dart';

class JsonEditorPanel extends StatefulWidget {
  final String title;
  final int panelNumber;
  final CodeController controller;
  final bool readOnly;
  final bool isDarkMode;
  final List<JsonDiagnostic> diagnostics;
  final String? fileSize;
  final VoidCallback? onCopy;
  final VoidCallback? onExpand;

  const JsonEditorPanel({
    super.key,
    required this.title,
    required this.panelNumber,
    required this.controller,
    this.readOnly = false,
    required this.isDarkMode,
    this.diagnostics = const [],
    this.fileSize,
    this.onCopy,
    this.onExpand,
  });

  @override
  State<JsonEditorPanel> createState() => _JsonEditorPanelState();
}

class _JsonEditorPanelState extends State<JsonEditorPanel> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;
    final borderColor =
        isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDarkMode ? AppColors.darkEditor : AppColors.lightEditor;
    final headerBg =
        isDarkMode ? AppColors.darkSurface : AppColors.lightSurfaceVariant;
    final textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final theme = isDarkMode ? monokaiSublimeTheme : githubTheme;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────
          _EditorHeader(
            title: widget.title,
            panelNumber: widget.panelNumber,
            fileSize: widget.fileSize,
            bgColor: headerBg,
            textColor: textColor,
            mutedColor: mutedColor,
            borderColor: borderColor,
            onCopy: widget.onCopy,
            onExpand: widget.onExpand,
          ),

          // ── Editor ──────────────────────────────────
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!widget.readOnly) {
                  _focusNode.requestFocus();
                }
              },
              child: CodeTheme(
                data: CodeThemeData(styles: theme),
                child: CodeField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  wrap: true,
                  expands: true,
                  readOnly: widget.readOnly,
                  textStyle: AppTypography.codeStyle.copyWith(
                    color: textColor,
                  ),
                  gutterStyle: GutterStyle(
                    width: 48,
                    textStyle: AppTypography.codeStyleSmall.copyWith(
                      color: mutedColor,
                    ),
                    background: isDarkMode
                        ? AppColors.darkEditorGutter
                        : AppColors.lightEditorGutter,
                  ),
                  background: bgColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorHeader extends StatelessWidget {
  final String title;
  final int panelNumber;
  final String? fileSize;
  final Color bgColor;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;
  final VoidCallback? onCopy;
  final VoidCallback? onExpand;

  const _EditorHeader({
    required this.title,
    required this.panelNumber,
    this.fileSize,
    required this.bgColor,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
    this.onCopy,
    this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
      ),
      child: Row(
        children: [
          // Panel number badge
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$panelNumber',
                style: AppTypography.badge.copyWith(color: AppColors.accent),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Title
          Text(
            title,
            style: AppTypography.heading3.copyWith(color: textColor),
          ),

          if (fileSize != null) ...[
            const SizedBox(width: 8),
            Text(
              '($fileSize)',
              style: AppTypography.caption.copyWith(color: mutedColor),
            ),
          ],

          const Spacer(),

          // Copy button
          if (onCopy != null)
            _EditorHeaderIcon(
              icon: Icons.copy,
              tooltip: 'Copy',
              color: mutedColor,
              onTap: onCopy!,
            ),

          // Expand button
          if (onExpand != null) ...[
            const SizedBox(width: 4),
            _EditorHeaderIcon(
              icon: Icons.open_in_full,
              tooltip: 'Expand',
              color: mutedColor,
              onTap: onExpand!,
            ),
          ],
        ],
      ),
    );
  }
}

class _EditorHeaderIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _EditorHeaderIcon({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
