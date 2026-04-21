import 'package:flutter/material.dart';
import 'package:japx_online/core/theme/app_colors.dart';
import 'package:japx_online/core/theme/app_typography.dart';
import 'package:japx_online/features/editor/domain/models/json_diagnostic.dart';

/// Collapsible error/warning panel displayed below the input editor.
class ErrorPanel extends StatefulWidget {
  final List<JsonDiagnostic> diagnostics;
  final bool isDarkMode;
  final ValueChanged<JsonDiagnostic>? onDiagnosticTap;

  const ErrorPanel({
    super.key,
    required this.diagnostics,
    required this.isDarkMode,
    this.onDiagnosticTap,
  });

  @override
  State<ErrorPanel> createState() => _ErrorPanelState();
}

class _ErrorPanelState extends State<ErrorPanel> {
  bool _showAll = false;

  int get _errorCount => widget.diagnostics
      .where((d) => d.severity == DiagnosticSeverity.error)
      .length;

  int get _warningCount => widget.diagnostics
      .where((d) => d.severity == DiagnosticSeverity.warning)
      .length;

  @override
  Widget build(BuildContext context) {
    if (widget.diagnostics.isEmpty) return const SizedBox.shrink();

    final borderColor =
        widget.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = widget.isDarkMode
        ? AppColors.darkSurface
        : AppColors.lightSurfaceVariant;

    final visibleDiags =
        _showAll ? widget.diagnostics : widget.diagnostics.take(3).toList();

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Summary bar ──────────────────────────────
          _ErrorSummaryBar(
            borderColor: borderColor,
            errorCount: _errorCount,
            warningCount: _warningCount,
            totalDiagnostics: widget.diagnostics.length,
            showAll: _showAll,
            onToggleShowAll: () => setState(() => _showAll = !_showAll),
          ),

          // ── Diagnostic items ─────────────────────────
          ...visibleDiags.map((d) => _DiagnosticItem(
                diagnostic: d,
                isDarkMode: widget.isDarkMode,
                onTap: widget.onDiagnosticTap,
              )),
        ],
      ),
    );
  }
}

class _ErrorSummaryBar extends StatelessWidget {
  final Color borderColor;
  final int errorCount;
  final int warningCount;
  final int totalDiagnostics;
  final bool showAll;
  final VoidCallback onToggleShowAll;

  const _ErrorSummaryBar({
    required this.borderColor,
    required this.errorCount,
    required this.warningCount,
    required this.totalDiagnostics,
    required this.showAll,
    required this.onToggleShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          if (errorCount > 0) ...[
            _SeverityBadge(
                count: errorCount, color: AppColors.error, label: 'Error'),
            const SizedBox(width: 8),
          ],
          if (warningCount > 0)
            _SeverityBadge(
                count: warningCount,
                color: AppColors.warning,
                label: 'Warning'),
          const Spacer(),
          if (totalDiagnostics > 3)
            TextButton(
              onPressed: onToggleShowAll,
              child: Text(
                showAll ? 'Show less' : 'View all',
                style:
                    AppTypography.bodySmall.copyWith(color: AppColors.accent),
              ),
            ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final int count;
  final Color color;
  final String label;

  const _SeverityBadge({
    required this.count,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          color == AppColors.error ? Icons.error : Icons.warning_amber,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '$count $label${count > 1 ? 's' : ''}',
          style: AppTypography.caption.copyWith(color: color),
        ),
      ],
    );
  }
}

class _DiagnosticItem extends StatelessWidget {
  final JsonDiagnostic diagnostic;
  final bool isDarkMode;
  final ValueChanged<JsonDiagnostic>? onTap;

  const _DiagnosticItem({
    required this.diagnostic,
    required this.isDarkMode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isError = diagnostic.severity == DiagnosticSeverity.error;
    final color = isError ? AppColors.error : AppColors.warning;
    final surfaceColor = isError
        ? (isDarkMode ? AppColors.errorSurface : const Color(0xFFFEE2E2))
        : (isDarkMode ? AppColors.warningSurface : const Color(0xFFFEF3C7));
    final textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return InkWell(
      onTap: () => onTap?.call(diagnostic),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isError ? Icons.error : Icons.warning_amber,
                  size: 14,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  '${diagnostic.severityLabel} (${diagnostic.locationLabel})',
                  style: AppTypography.caption.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              diagnostic.message,
              style: AppTypography.bodySmall.copyWith(color: textColor),
            ),
            if (diagnostic.path != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'Path: ${diagnostic.path}',
                    style: AppTypography.caption.copyWith(color: mutedColor),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      // Copy the path handled locally or via callback mapping
                    },
                    child: Icon(Icons.copy, size: 12, color: mutedColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
