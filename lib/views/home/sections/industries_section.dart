import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/glass_card.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class IndustriesSection extends StatefulWidget {
  const IndustriesSection({super.key});

  @override
  State<IndustriesSection> createState() => _IndustriesSectionState();
}

class _IndustriesSectionState extends State<IndustriesSection> {
  bool _visible = false;

  static const _industries = [
    _IndustryItem(
      icon: Icons.diamond_outlined,
      titleKey: 'industries.fashion.title',
      descKey: 'industries.fashion.description',
    ),
    _IndustryItem(
      icon: Icons.sports,
      titleKey: 'industries.sports.title',
      descKey: 'industries.sports.description',
    ),
    _IndustryItem(
      icon: Icons.medical_services_outlined,
      titleKey: 'industries.medical.title',
      descKey: 'industries.medical.description',
    ),
    _IndustryItem(
      icon: Icons.shield_outlined,
      titleKey: 'industries.military.title',
      descKey: 'industries.military.description',
    ),
    _IndustryItem(
      icon: Icons.chair_outlined,
      titleKey: 'industries.furniture.title',
      descKey: 'industries.furniture.description',
    ),
    _IndustryItem(
      icon: Icons.directions_car_outlined,
      titleKey: 'industries.automotive.title',
      descKey: 'industries.automotive.description',
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
    final crossAxisCount = isDesktop ? 3 : isTablet ? 2 : 1;

    return VisibilityDetector(
      key: const Key('industries-section'),
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
              Color(0xFF020B18),
              Color(0xFF071B3B),
              Color(0xFF020B18),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: CustomPaint(
          painter: _DiagonalTexturePainter(),
          child: Padding(
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
                    label: 'industries.label'.tr(),
                    title: 'industries.title'.tr(),
                  )
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .slideY(begin: 0.3, end: 0, duration: 700.ms),

                const SizedBox(height: AppSpacing.xxxl),

                // Industry cards grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                    childAspectRatio: isDesktop ? 1.1 : isTablet ? 1.0 : 1.3,
                  ),
                  itemCount: _industries.length,
                  itemBuilder: (context, index) {
                    final industry = _industries[index];
                    return _IndustryCard(
                      industry: industry,
                      visible: _visible,
                      delay: Duration(milliseconds: 100 * index),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Data model ─────────────────────────────────────────────────────────────

class _IndustryItem {
  final IconData icon;
  final String titleKey;
  final String descKey;

  const _IndustryItem({
    required this.icon,
    required this.titleKey,
    required this.descKey,
  });
}

// ─── Industry Card ──────────────────────────────────────────────────────────

class _IndustryCard extends StatefulWidget {
  final _IndustryItem industry;
  final bool visible;
  final Duration delay;

  const _IndustryCard({
    required this.industry,
    required this.visible,
    required this.delay,
  });

  @override
  State<_IndustryCard> createState() => _IndustryCardState();
}

class _IndustryCardState extends State<_IndustryCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _iconController;
  late Animation<double> _iconScale;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _iconScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _onHoverChange(bool hovered) {
    setState(() => _hovered = hovered);
    if (hovered) {
      _iconController.forward();
    } else {
      _iconController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChange(true),
      onExit: (_) => _onHoverChange(false),
      child: GlassCard(
        enableHoverGlow: true,
        borderRadius: 0,
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gold icon with scale animation
            AnimatedBuilder(
              animation: _iconScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _iconScale.value,
                  child: child,
                );
              },
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hovered
                      ? AppColors.accent.withOpacity(0.15)
                      : AppColors.accent.withOpacity(0.08),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(_hovered ? 0.6 : 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.industry.icon,
                  color: AppColors.accent,
                  size: 32,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              widget.industry.titleKey.tr(),
              style: AppTextStyles.headlineSmall.copyWith(
                fontSize: 20,
                color: _hovered ? AppColors.textPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // Gold divider
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _hovered ? 48 : 24,
              height: 1,
              color: AppColors.accent.withOpacity(_hovered ? 0.8 : 0.4),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Description
            Text(
              widget.industry.descKey.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    )
        .animate(target: widget.visible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: widget.delay)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: widget.delay);
  }
}

// ─── Diagonal texture background painter ────────────────────────────────────

class _DiagonalTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    // Draw diagonal lines top-left to bottom-right
    for (double d = -size.height; d < size.width + size.height; d += spacing) {
      canvas.drawLine(
        Offset(d, 0),
        Offset(d + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
