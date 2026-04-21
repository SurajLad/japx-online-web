import 'package:flutter/material.dart';
import 'package:japx_online/core/constants/app_constants.dart';
import 'package:japx_online/core/theme/app_colors.dart';
import 'package:japx_online/core/theme/app_typography.dart';
import 'package:web/web.dart' as web;

/// Left navigation sidebar matching the reference screenshot.
class Sidebar extends StatelessWidget {
  final VoidCallback? onAboutTap;

  const Sidebar({super.key, this.onAboutTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkSidebar : AppColors.lightSidebar;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(right: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        children: [
          // ── Brand Header ──────────────────────────────
          _SidebarHeader(textColor: textColor, mutedColor: mutedColor),
          Divider(color: borderColor, height: 1),

          // ── Scrollable Nav ────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SidebarSection(title: 'WORKSPACE', color: mutedColor),
                  const SizedBox(height: 16),
                  _SidebarNavItem(
                    icon: Icons.description_outlined,
                    label: 'About',
                    textColor: mutedColor,
                    isDark: isDark,
                    onTap: onAboutTap,
                  ),
                  // _SidebarNavItem(
                  //   icon: Icons.code,
                  //   label: 'Examples',
                  //   textColor: mutedColor,
                  //   isDark: isDark,
                  //   isPlaceholder: true,
                  // ),
                  _SidebarNavItem(
                    icon: Icons.support_agent,
                    label: 'Support',
                    textColor: mutedColor,
                    isDark: isDark,
                    onTap: () =>
                        web.window.open(AppConstants.githubRepoUrl, '_blank'),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom CTA ────────────────────────────────
          _SidebarBottomCta(
            textColor: textColor,
            mutedColor: mutedColor,
            borderColor: borderColor,
          ),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;

  const _SidebarHeader({required this.textColor, required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          // Logo icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                '{/}',
                style: TextStyle(
                  fontFamily: AppTypography.codeFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JSON API Parser',
                  style: AppTypography.heading3.copyWith(color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Text(
                      'JPAX',
                      style: AppTypography.caption.copyWith(color: mutedColor),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        AppConstants.appVersion,
                        style: AppTypography.badge
                            .copyWith(color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final Color color;

  const _SidebarSection({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: AppTypography.sidebarSection.copyWith(color: color),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final bool isDark;
  final VoidCallback? onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Icon(icon, size: 18, color: textColor),
        title: Text(
          label,
          style: AppTypography.sidebarItem.copyWith(color: textColor),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _SidebarBottomCta extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  const _SidebarBottomCta({
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        children: [
          Text(
            'Love JAPX?',
            style: AppTypography.bodySmall.copyWith(color: mutedColor),
          ),
          Text(
            'Give us a ⭐ on GitHub',
            style: AppTypography.bodySmall.copyWith(color: mutedColor),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => web.window.open(
                AppConstants.githubRepoUrl,
                '_blank',
              ),
              icon: SizedBox(
                width: 14,
                height: 14,
                child: Image.asset('assets/github.png', color: textColor),
              ),
              label: Text(
                'Star on GitHub',
                style: AppTypography.bodySmall.copyWith(color: textColor),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor),
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
