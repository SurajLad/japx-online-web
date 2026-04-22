import 'package:flutter/material.dart';
import 'package:japx_online/core/constants/app_constants.dart';
import 'package:japx_online/core/theme/app_colors.dart';
import 'package:japx_online/core/theme/app_typography.dart';
import 'package:web/web.dart' as web;

class AboutPopup extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onTrySample;

  const AboutPopup({
    super.key,
    required this.onClose,
    required this.onTrySample,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final surfaceColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      width: 450,
      height: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _AboutPopupHeader(
            textColor: textColor,
            mutedColor: mutedColor,
            onClose: onClose,
          ),
          Divider(height: 1, color: borderColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutPopupHero(
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                  const SizedBox(height: 32),
                  _AboutPopupWhatItDoes(
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                  const SizedBox(height: 32),
                  _AboutPopupKeyFeatures(
                    textColor: textColor,
                    mutedColor: mutedColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 32),
                  _AboutPopupBuiltWith(
                    textColor: textColor,
                    mutedColor: mutedColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 24),
                  _AboutPopupActions(
                    textColor: textColor,
                    borderColor: borderColor,
                  ),
                  const SizedBox(height: 24),
                  _AboutPopupTrySample(
                    textColor: textColor,
                    mutedColor: mutedColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    onTrySample: onTrySample,
                  ),
                  const SizedBox(height: 40),
                  _AboutPopupFooter(mutedColor: mutedColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPopupHeader extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;
  final VoidCallback onClose;

  const _AboutPopupHeader({
    required this.textColor,
    required this.mutedColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'About JAPX',
                style: AppTypography.heading2.copyWith(color: textColor),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppConstants.appVersion,
                  style: AppTypography.badge.copyWith(color: AppColors.accent),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, size: 20),
            color: mutedColor,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

class _AboutPopupHero extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;

  const _AboutPopupHero({
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          right: -20,
          top: 0,
          child: Opacity(
            opacity: 0.1,
            child: Icon(Icons.auto_awesome, size: 100, color: AppColors.accent),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '{/}',
                  style: TextStyle(
                    fontFamily: AppTypography.codeFontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'JAPX',
              style: AppTypography.heading1.copyWith(
                fontSize: 32,
                color: textColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Transform messy JSON into clean, usable data',
              style: AppTypography.heading2.copyWith(
                color: AppColors.accentLight,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Built for developers who hate dealing with nested API chaos.',
              style: AppTypography.bodyMedium.copyWith(color: mutedColor),
            ),
          ],
        ),
      ],
    );
  }
}

class _AboutPopupWhatItDoes extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;

  const _AboutPopupWhatItDoes({
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    const features = [
      'Flatten complex relational JSON',
      'Generate ready-to-use models',
      'Highlight errors instantly',
      'Format & clean JSON',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What JAPX does',
          style: AppTypography.heading2.copyWith(color: textColor),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    feature,
                    style: AppTypography.bodyMedium.copyWith(color: mutedColor),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _AboutPopupKeyFeatures extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;
  final Color surfaceColor;
  final Color borderColor;

  const _AboutPopupKeyFeatures({
    required this.textColor,
    required this.mutedColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: AppTypography.heading2.copyWith(color: textColor),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _FeatureCard(
              icon: Icons.dark_mode_outlined,
              title: 'Dark mode-first',
              description: 'Designed for long coding sessions.',
              textColor: textColor,
              mutedColor: mutedColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
            _FeatureCard(
              icon: Icons.bolt,
              title: 'Real-time',
              description: 'See flattened output as you type.',
              textColor: textColor,
              mutedColor: mutedColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
            _FeatureCard(
              icon: Icons.verified_user_outlined,
              title: 'Smart Error',
              description: 'Inline error highlighting with details.',
              textColor: textColor,
              mutedColor: mutedColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
            _FeatureCard(
              icon: Icons.code,
              title: 'Multi-language',
              description: 'Generate models for Dart and more.',
              textColor: textColor,
              mutedColor: mutedColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color textColor;
  final Color mutedColor;
  final Color surfaceColor;
  final Color borderColor;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.textColor,
    required this.mutedColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTypography.heading3.copyWith(color: textColor),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              description,
              style: AppTypography.caption
                  .copyWith(color: mutedColor, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutPopupBuiltWith extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;
  final Color surfaceColor;
  final Color borderColor;

  const _AboutPopupBuiltWith({
    required this.textColor,
    required this.mutedColor,
    required this.surfaceColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Built with ',
                style: AppTypography.heading3.copyWith(color: textColor),
              ),
              const Icon(Icons.favorite, size: 16, color: Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'JAPX was built to simplify working with deeply nested APIs and speed up development workflows.',
            style: AppTypography.bodySmall.copyWith(color: mutedColor),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Built by a ',
                style: AppTypography.bodySmall.copyWith(color: mutedColor),
              ),
              Text(
                'Flutter',
                style: AppTypography.bodySmall.copyWith(color: Colors.blue),
              ),
              Text(
                ' developer for developers.',
                style: AppTypography.bodySmall.copyWith(color: mutedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutPopupActions extends StatelessWidget {
  final Color textColor;
  final Color borderColor;

  const _AboutPopupActions({
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.star_outline,
            label: 'Star on GitHub',
            subLabel: 'Show your support',
            textColor: textColor,
            borderColor: borderColor,
            onTap: () => web.window.open(AppConstants.githubRepoUrl, '_blank'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.book_outlined,
            label: 'Documentation',
            subLabel: 'Learn how to use',
            textColor: textColor,
            borderColor: borderColor,
            onTap: () => web.window.open(AppConstants.japxPackageUrl, '_blank'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.bug_report_outlined,
            label: 'Report Issue',
            subLabel: 'Help us improve',
            textColor: textColor,
            borderColor: borderColor,
            onTap: () => web.window
                .open('${AppConstants.githubRepoUrl}/issues', '_blank'),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: textColor),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.caption
                  .copyWith(color: textColor, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: AppTypography.badge.copyWith(
                  fontSize: 8, color: textColor.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutPopupTrySample extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;
  final Color surfaceColor;
  final Color borderColor;
  final VoidCallback onTrySample;

  const _AboutPopupTrySample({
    required this.textColor,
    required this.mutedColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.onTrySample,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTrySample,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, style: BorderStyle.solid),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.description_outlined,
                  color: AppColors.accent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Try Sample JSON',
                    style: AppTypography.heading3.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Load example JSON and try JAPX',
                    style: AppTypography.caption.copyWith(color: mutedColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: mutedColor),
          ],
        ),
      ),
    );
  }
}

class _AboutPopupFooter extends StatelessWidget {
  final Color mutedColor;

  const _AboutPopupFooter({required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Version 2.0.0 • Made with ❤️ in India',
        style: AppTypography.caption.copyWith(color: mutedColor),
      ),
    );
  }
}
