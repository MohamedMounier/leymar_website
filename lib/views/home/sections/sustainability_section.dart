import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class SustainabilitySection extends StatefulWidget {
  const SustainabilitySection({super.key});

  @override
  State<SustainabilitySection> createState() => _SustainabilitySectionState();
}

class _SustainabilitySectionState extends State<SustainabilitySection>
    with TickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _progressController;
  late List<Animation<double>> _progressAnimations;

  static const _pillars = [
    _Pillar(
      titleKey: 'sustainability.water.title',
      valueKey: 'sustainability.water.value',
      descKey: 'sustainability.water.description',
      percent: 0.40,
      icon: Icons.water_drop_outlined,
    ),
    _Pillar(
      titleKey: 'sustainability.recycled.title',
      valueKey: 'sustainability.recycled.value',
      descKey: 'sustainability.recycled.description',
      percent: 0.30,
      icon: Icons.recycling,
    ),
    _Pillar(
      titleKey: 'sustainability.energy.title',
      valueKey: 'sustainability.energy.value',
      descKey: 'sustainability.energy.description',
      percent: 0.25,
      icon: Icons.bolt_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _progressAnimations = _pillars.map((p) {
      return Tween<double>(begin: 0.0, end: p.percent).animate(
        CurvedAnimation(
          parent: _progressController,
          curve: Curves.easeOutCubic,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.15 && !_visible) {
      setState(() => _visible = true);
      _progressController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768;
    final hPad = isDesktop
        ? AppSpacing.sectionHPadding
        : isTablet
            ? AppSpacing.tabletPadding
            : AppSpacing.mobilePadding;

    return VisibilityDetector(
      key: const Key('sustainability-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              const Color(0xFFEAF2EC),
              AppColors.background,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative green tint overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.centerRight,
                    radius: 1.2,
                    colors: [
                      const Color(0xFF2E9B6A).withOpacity(0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.section,
                horizontal: hPad,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_visible)
                    SectionHeader(
                      label: 'sustainability.label'.tr(),
                      title: 'sustainability.title'.tr(),
                      subtitle: 'sustainability.subtitle'.tr(),
                    )
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: 0.3, end: 0, duration: 700.ms),

                  const SizedBox(height: AppSpacing.xxxl),

                  isDesktop
                      ? _buildDesktopLayout()
                      : _buildMobileLayout(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: descriptive text
        Expanded(
          flex: 5,
          child: _buildDescriptiveText(),
        ),
        const SizedBox(width: AppSpacing.xxxl),
        // Right: circular progress indicators
        Expanded(
          flex: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _pillars.asMap().entries.map((e) {
              return _AnimatedPillarCard(
                pillar: e.value,
                animation: _progressAnimations[e.key],
                visible: _visible,
                delay: Duration(milliseconds: 200 * e.key),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildDescriptiveText(),
        const SizedBox(height: AppSpacing.xxxl),
        Wrap(
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.xl,
          alignment: WrapAlignment.center,
          children: _pillars.asMap().entries.map((e) {
            return _AnimatedPillarCard(
              pillar: e.value,
              animation: _progressAnimations[e.key],
              visible: _visible,
              delay: Duration(milliseconds: 200 * e.key),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptiveText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 2,
          color: const Color(0xFF2E9B6A),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'sustainability.body'.tr(),
          style: AppTextStyles.bodyLarge.copyWith(
            height: 1.9,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF2E9B6A),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'sustainability.cert'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF2E9B6A),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'sustainability.goal'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Data model ─────────────────────────────────────────────────────────────

class _Pillar {
  final String titleKey;
  final String valueKey;
  final String descKey;
  final double percent;
  final IconData icon;

  const _Pillar({
    required this.titleKey,
    required this.valueKey,
    required this.descKey,
    required this.percent,
    required this.icon,
  });
}

// ─── Animated Pillar Card ────────────────────────────────────────────────────

class _AnimatedPillarCard extends StatelessWidget {
  final _Pillar pillar;
  final Animation<double> animation;
  final bool visible;
  final Duration delay;

  const _AnimatedPillarCard({
    required this.pillar,
    required this.animation,
    required this.visible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final Widget card = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: _CircularProgressPainter(
                  progress: animation.value,
                  maxProgress: pillar.percent,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pillar.icon,
                        color: AppColors.accent,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pillar.valueKey.tr(),
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.accent,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          pillar.titleKey.tr(),
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: 160,
          child: Text(
            pillar.descKey.tr(),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    if (!visible) return card;

    return card
        .animate()
        .fadeIn(duration: 700.ms, delay: delay)
        .slideY(begin: 0.3, end: 0, duration: 700.ms, delay: delay);
  }
}

// ─── CircularProgressPainter ─────────────────────────────────────────────────

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double maxProgress;

  _CircularProgressPainter({
    required this.progress,
    required this.maxProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background track
    final trackPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.3)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.accent, AppColors.highlight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Outer ring decoration
    final outerPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius + 12, outerPaint);
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
