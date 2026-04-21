import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:jpax_online/core/theme/app_colors.dart';
import 'package:jpax_online/core/theme/app_typography.dart';
import 'package:jpax_online/core/utils/file_downloader.dart';
import 'package:jpax_online/features/model_generator/domain/models/generated_model.dart';

/// Right-side panel for generating Dart model code from parsed JSON.
class ModelGeneratorPanel extends StatefulWidget {
  final bool isDarkMode;
  final GeneratedModel? generatedModel;
  final VoidCallback onGenerate;

  const ModelGeneratorPanel({
    super.key,
    required this.isDarkMode,
    required this.generatedModel,
    required this.onGenerate,
  });

  @override
  State<ModelGeneratorPanel> createState() => _ModelGeneratorPanelState();
}

class _ModelGeneratorPanelState extends State<ModelGeneratorPanel> {
  String _selectedLanguage = 'Dart (Flutter)';
  bool _copied = false;

  static const _languages = [
    ('Dart (Flutter)', Icons.flutter_dash, true),
    ('Kotlin', Icons.android, false),
    ('Swift', Icons.apple, false),
    ('TypeScript', Icons.javascript, false),
    ('Java', Icons.coffee, false),
    ('Python (Pydantic)', Icons.data_object, false),
  ];

  @override
  Widget build(BuildContext context) {
    final borderColor =
        widget.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor =
        widget.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = widget.isDarkMode
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final mutedColor = widget.isDarkMode
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(left: BorderSide(color: borderColor, width: 1)),
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────
          _PanelHeader(
            textColor: textColor,
            mutedColor: mutedColor,
            borderColor: borderColor,
          ),

          // ── Language Selector ───────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Language',
                    style: AppTypography.heading3.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 8),

                  // Language list
                  ..._languages.map((lang) => _LanguageItem(
                        label: lang.$1,
                        icon: lang.$2,
                        enabled: lang.$3,
                        isSelected: _selectedLanguage == lang.$1,
                        textColor: textColor,
                        mutedColor: mutedColor,
                        borderColor: borderColor,
                        onTap: lang.$3
                            ? () => setState(() => _selectedLanguage = lang.$1)
                            : null,
                      )),

                  const SizedBox(height: 16),

                  // Generate button
                  _GenerateButton(onGenerate: widget.onGenerate),

                  const SizedBox(height: 16),

                  // Preview section
                  if (widget.generatedModel != null) ...[
                    _PreviewSection(
                      model: widget.generatedModel!,
                      isDarkMode: widget.isDarkMode,
                      textColor: textColor,
                      mutedColor: mutedColor,
                      borderColor: borderColor,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Bottom Actions ──────────────────────────
          if (widget.generatedModel != null)
            _BottomActions(
              model: widget.generatedModel!,
              borderColor: borderColor,
              copied: _copied,
              onCopy: () async {
                await Clipboard.setData(
                  ClipboardData(text: widget.generatedModel!.sourceCode),
                );
                setState(() => _copied = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _copied = false);
                });
              },
            ),
        ],
      ),
    );
  }

}

class _PanelHeader extends StatelessWidget {
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  const _PanelHeader({
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            'Generate Models',
            style: AppTypography.heading2.copyWith(color: textColor),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Beta',
              style: AppTypography.badge.copyWith(color: AppColors.accent),
            ),
          ),
          const Spacer(),
          const Icon(Icons.auto_awesome, size: 18, color: AppColors.accent),
        ],
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool enabled;
  final bool isSelected;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;
  final VoidCallback? onTap;

  const _LanguageItem({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.isSelected,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.45,
      child: Tooltip(
        message: enabled ? '' : 'Coming Soon',
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.4)
                    : borderColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 18,
                    color: isSelected ? AppColors.accent : mutedColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.accent : textColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, size: 16, color: AppColors.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  final VoidCallback onGenerate;

  const _GenerateButton({required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.accent, AppColors.accentLight],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton.icon(
          onPressed: onGenerate,
          icon: const Icon(Icons.code, size: 18, color: Colors.white),
          label: Text(
            'Generate Model',
            style: AppTypography.button.copyWith(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  final GeneratedModel model;
  final bool isDarkMode;
  final Color textColor;
  final Color mutedColor;
  final Color borderColor;

  const _PreviewSection({
    required this.model,
    required this.isDarkMode,
    required this.textColor,
    required this.mutedColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isDarkMode ? monokaiSublimeTheme : githubTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: AppTypography.heading3.copyWith(color: textColor),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.insert_drive_file_outlined,
              size: 14,
              color: AppColors.accent,
            ),
            const SizedBox(width: 4),
            Text(
              model.fileName,
              style: AppTypography.bodySmall.copyWith(color: AppColors.accent),
            ),
            const Spacer(),
            InkWell(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: model.sourceCode));
              },
              child: Icon(Icons.copy, size: 14, color: mutedColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 350),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SingleChildScrollView(
              child: HighlightView(
                model.sourceCode,
                language: 'dart',
                theme: theme,
                padding: const EdgeInsets.all(12),
                textStyle: AppTypography.codeStyleSmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final GeneratedModel model;
  final Color borderColor;
  final bool copied;
  final VoidCallback onCopy;

  const _BottomActions({
    required this.model,
    required this.borderColor,
    required this.copied,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onCopy,
              icon: Icon(
                copied ? Icons.check : Icons.copy,
                size: 16,
                color: copied ? AppColors.success : null,
              ),
              label: Text(copied ? 'Copied!' : 'Copy Code'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.accentLight],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  FileDownloader.download(
                    content: model.sourceCode,
                    fileName: model.fileName,
                  );
                },
                icon: const Icon(Icons.download, size: 16, color: Colors.white),
                label: Text(
                  'Download',
                  style: AppTypography.button.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
