import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class ManufacturingSection extends StatefulWidget {
  const ManufacturingSection({super.key});

  @override
  State<ManufacturingSection> createState() => _ManufacturingSectionState();
}

class _ManufacturingSectionState extends State<ManufacturingSection> {
  bool _visible = false;

  static const _steps = [
    _ManufacturingStep(
      icon: Icons.grain,
      titleKey: 'manufacturing.steps.yarn.title',
      descKey: 'manufacturing.steps.yarn.description',
      imageUrl: 'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=400&h=220&fit=crop&auto=format',
    ),
    _ManufacturingStep(
      icon: Icons.palette,
      titleKey: 'manufacturing.steps.dyeing.title',
      descKey: 'manufacturing.steps.dyeing.description',
      imageUrl: 'https://images.unsplash.com/photo-1561346745-5db68f45f406?w=400&h=220&fit=crop&auto=format',
    ),
    _ManufacturingStep(
      icon: Icons.grid_on,
      titleKey: 'manufacturing.steps.weaving.title',
      descKey: 'manufacturing.steps.weaving.description',
      imageUrl: 'https://media.giphy.com/media/3oEduSbSGpHMVHOPRK/giphy.gif',
      fallbackUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=220&fit=crop&auto=format',
    ),
    _ManufacturingStep(
      icon: Icons.search,
      titleKey: 'manufacturing.steps.inspection.title',
      descKey: 'manufacturing.steps.inspection.description',
      imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=400&h=220&fit=crop&auto=format',
    ),
    _ManufacturingStep(
      icon: Icons.inventory_2,
      titleKey: 'manufacturing.steps.packaging.title',
      descKey: 'manufacturing.steps.packaging.description',
      imageUrl: 'https://images.unsplash.com/photo-1591696331111-ef9586a5b17a?w=400&h=220&fit=crop&auto=format',
    ),
    _ManufacturingStep(
      icon: Icons.public,
      titleKey: 'manufacturing.steps.export.title',
      descKey: 'manufacturing.steps.export.description',
      imageUrl: 'https://images.unsplash.com/photo-1494412574643-ff11b0a5c1c3?w=400&h=220&fit=crop&auto=format',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 767;
    final hPad = isDesktop
        ? AppSpacing.sectionHPadding
        : isTablet
            ? AppSpacing.tabletPadding
            : AppSpacing.mobilePadding;

    return VisibilityDetector(
      key: const Key('manufacturing-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF7F1E6),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.section,
          horizontal: hPad,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section Header
            if (_visible)
              SectionHeader(
                label: 'manufacturing.label'.tr(),
                title: 'manufacturing.title'.tr(),
              )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0, duration: 700.ms),

            const SizedBox(height: AppSpacing.xxxl),

            // Timeline
            isDesktop
                ? _HorizontalTimeline(steps: _steps, visible: _visible)
                : _VerticalTimeline(steps: _steps, visible: _visible),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ─────────────────────────────────────────────────────────────

class _ManufacturingStep {
  final IconData icon;
  final String titleKey;
  final String descKey;
  final String imageUrl;
  final String? fallbackUrl;

  const _ManufacturingStep({
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.imageUrl,
    this.fallbackUrl,
  });
}

// ─── Horizontal Timeline (Desktop) ─────────────────────────────────────────

class _HorizontalTimeline extends StatelessWidget {
  final List<_ManufacturingStep> steps;
  final bool visible;

  const _HorizontalTimeline({required this.steps, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Connecting line row
        Stack(
          alignment: Alignment.center,
          children: [
            // Gold connecting line
            Positioned(
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0),
                      AppColors.accent.withOpacity(0.6),
                      AppColors.accent.withOpacity(0.6),
                      AppColors.accent.withOpacity(0),
                    ],
                    stops: const [0.0, 0.1, 0.9, 1.0],
                  ),
                ),
              ),
            ),
            // Step icons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: steps.asMap().entries.map((entry) {
                final index = entry.key;
                final step = entry.value;
                return Expanded(
                  child: _HorizontalStepItem(
                    step: step,
                    number: index + 1,
                    visible: visible,
                    delay: Duration(milliseconds: 150 * index),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

class _HorizontalStepItem extends StatefulWidget {
  final _ManufacturingStep step;
  final int number;
  final bool visible;
  final Duration delay;

  const _HorizontalStepItem({
    required this.step,
    required this.number,
    required this.visible,
    required this.delay,
  });

  @override
  State<_HorizontalStepItem> createState() => _HorizontalStepItemState();
}

class _HorizontalStepItemState extends State<_HorizontalStepItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step image
          SizedBox(
            width: double.infinity,
            height: 160,
            child: Image.network(
              widget.step.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                if (widget.step.fallbackUrl != null) {
                  return Image.network(
                    widget.step.fallbackUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF0D2D66),
                      child: Icon(widget.step.icon, color: const Color(0xFFC79A3B), size: 40),
                    ),
                  );
                }
                return Container(
                  color: const Color(0xFF0D2D66),
                  child: Icon(widget.step.icon, color: const Color(0xFFC79A3B), size: 40),
                );
              },
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFF0D2D66),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFFC79A3B),
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Number badge + icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? AppColors.accent.withOpacity(0.2)
                  : AppColors.cardColor,
              border: Border.all(
                color: _hovered ? AppColors.accent : AppColors.accent.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  widget.step.icon,
                  color: _hovered ? AppColors.highlight : AppColors.accent,
                  size: 28,
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.number}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF020B18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Title (large Cormorant number + text)
          Text(
            '0${widget.number}',
            style: AppTextStyles.statNumber.copyWith(
              fontSize: 40,
              color: AppColors.accent.withOpacity(0.3),
              height: 1,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            widget.step.titleKey.tr(),
            style: AppTextStyles.titleMedium.copyWith(
              color: _hovered ? AppColors.textPrimary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.sm),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              widget.step.descKey.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    )
        .animate(target: widget.visible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: widget.delay)
        .slideY(begin: 0.4, end: 0, duration: 600.ms, delay: widget.delay);
  }
}

// ─── Vertical Timeline (Mobile / Tablet) ───────────────────────────────────

class _VerticalTimeline extends StatelessWidget {
  final List<_ManufacturingStep> steps;
  final bool visible;

  const _VerticalTimeline({required this.steps, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;
        return _VerticalStepItem(
          step: step,
          number: index + 1,
          isLast: isLast,
          visible: visible,
          delay: Duration(milliseconds: 150 * index),
        );
      }).toList(),
    );
  }
}

class _VerticalStepItem extends StatelessWidget {
  final _ManufacturingStep step;
  final int number;
  final bool isLast;
  final bool visible;
  final Duration delay;

  const _VerticalStepItem({
    required this.step,
    required this.number,
    required this.isLast,
    required this.visible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: number badge + vertical line
        Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cardColor,
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(step.icon, color: AppColors.accent, size: 22),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF020B18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Container(
                width: 1,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accent.withOpacity(0.5),
                      AppColors.accent.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: AppSpacing.lg),

        // Right: content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xxxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step image
                SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: Image.network(
                    step.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      if (step.fallbackUrl != null) {
                        return Image.network(
                          step.fallbackUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF0D2D66),
                            child: Icon(step.icon, color: const Color(0xFFC79A3B), size: 40),
                          ),
                        );
                      }
                      return Container(
                        color: const Color(0xFF0D2D66),
                        child: Icon(step.icon, color: const Color(0xFFC79A3B), size: 40),
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: const Color(0xFF0D2D66),
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFFC79A3B),
                              strokeWidth: 1.5,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),
                Text(
                  '0$number',
                  style: AppTextStyles.statNumber.copyWith(
                    fontSize: 32,
                    color: AppColors.accent.withOpacity(0.3),
                    height: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  step.titleKey.tr(),
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  step.descKey.tr(),
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate(target: visible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: delay)
        .slideX(begin: -0.3, end: 0, duration: 600.ms, delay: delay);
  }
}
