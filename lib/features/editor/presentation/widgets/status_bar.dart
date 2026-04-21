import 'package:flutter/material.dart';
import 'package:japx_online/core/theme/app_colors.dart';
import 'package:japx_online/core/theme/app_typography.dart';

/// Bottom status bar showing format, line/column, and size info.
class StatusBar extends StatelessWidget {
  final String format;
  final int line;
  final int column;
  final int spaces;
  final bool isDarkMode;
  final VoidCallback? onCopy;

  const StatusBar({
    super.key,
    this.format = 'JSON',
    this.line = 1,
    this.column = 1,
    this.spaces = 2,
    required this.isDarkMode,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor =
        isDarkMode ? AppColors.darkSurface : AppColors.lightSurfaceVariant;
    final textColor =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _StatusChip(text: 'Format: $format', color: textColor),
          const SizedBox(width: 16),
          _StatusChip(text: 'Ln $line, Col $column', color: textColor),
          const SizedBox(width: 16),
          _StatusChip(text: 'Spaces: $spaces', color: textColor),
          const Spacer(),
          if (onCopy != null)
            InkWell(
              onTap: onCopy,
              child: Icon(Icons.copy, size: 14, color: textColor),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(color: color),
    );
  }
}
