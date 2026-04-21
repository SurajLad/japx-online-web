import 'package:flutter/material.dart';
import 'package:jpax_online/core/theme/app_colors.dart';
import 'package:jpax_online/core/theme/app_typography.dart';

/// Top action bar with theme toggle, Auto-format, Clear, and Transform buttons.
class TopBar extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onAutoFormat;
  final VoidCallback onClear;
  final VoidCallback onTransform;

  const TopBar({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onAutoFormat,
    required this.onClear,
    required this.onTransform,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDarkMode ? AppColors.darkTopBar : AppColors.lightTopBar;
    final textColor =
        isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Spacer(),

          // ── Theme toggle ──────────────────────────────
          _IconBtn(
            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
            tooltip:
                isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            color: mutedColor,
            onTap: onToggleTheme,
          ),
          const SizedBox(width: 12),

          // ── Auto-format ───────────────────────────────
          _ActionBtn(
            icon: Icons.auto_fix_high,
            label: 'Auto-format',
            color: textColor,
            bgColor: Colors.transparent,
            borderColor: borderColor,
            onTap: onAutoFormat,
          ),
          const SizedBox(width: 8),

          // ── Clear ─────────────────────────────────────
          _ActionBtn(
            icon: Icons.clear_all,
            label: 'Clear',
            color: textColor,
            bgColor: Colors.transparent,
            borderColor: borderColor,
            onTap: onClear,
          ),
          const SizedBox(width: 8),

          // ── Transform ─────────────────────────────────
          _TransformBtn(onTap: onTransform),
        ],
      ),
    );
  }

}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({
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
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: AppTypography.bodySmall.copyWith(color: color)),
      style: OutlinedButton.styleFrom(
        backgroundColor: bgColor,
        side: BorderSide(color: borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _TransformBtn extends StatelessWidget {
  final VoidCallback onTap;

  const _TransformBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.accentLight],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.transform, size: 18, color: Colors.white),
        label: Text(
          'Transform',
          style: AppTypography.button.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

