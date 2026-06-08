import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum LuxuryButtonType { primary, outline }

class LuxuryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final LuxuryButtonType type;
  final IconData? icon;
  final double? width;

  const LuxuryButton({
    super.key,
    required this.label,
    this.onTap,
    this.type = LuxuryButtonType.primary,
    this.icon,
    this.width,
  });

  @override
  State<LuxuryButton> createState() => _LuxuryButtonState();
}

class _LuxuryButtonState extends State<LuxuryButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.type == LuxuryButtonType.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: widget.width,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: isPrimary
                ? (_hovered
                    ? const LinearGradient(
                        colors: [Color(0xFFE0BC74), Color(0xFFC79A3B)],
                      )
                    : AppColors.goldGradient)
                : null,
            border: Border.all(
              color: _hovered
                  ? AppColors.highlight
                  : AppColors.accent,
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 18,
                  color: isPrimary ? AppColors.primary : AppColors.accent,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label.toUpperCase(),
                style: AppTextStyles.labelLarge.copyWith(
                  color: isPrimary ? AppColors.primary : (_hovered ? AppColors.highlight : AppColors.accent),
                  fontSize: 13,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
