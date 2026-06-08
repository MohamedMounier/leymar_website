import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Gold label
        Row(
          mainAxisSize: alignment == CrossAxisAlignment.center
              ? MainAxisSize.min
              : MainAxisSize.max,
          mainAxisAlignment: alignment == CrossAxisAlignment.center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 1,
              color: AppColors.accent,
            ),
            const SizedBox(width: 12),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelMedium,
            ),
            const SizedBox(width: 12),
            Container(
              width: 30,
              height: 1,
              color: AppColors.accent,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Main title
        Text(
          title,
          style: AppTextStyles.headlineLarge,
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            subtitle!,
            style: AppTextStyles.bodyLarge,
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),
        ],
      ],
    );
  }
}
