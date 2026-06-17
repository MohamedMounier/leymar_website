import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class FactoryStatsSection extends StatefulWidget {
  const FactoryStatsSection({super.key});

  @override
  State<FactoryStatsSection> createState() => _FactoryStatsSectionState();
}

class _FactoryStatsSectionState extends State<FactoryStatsSection> {
  bool _visible = false;

  static const _stats = [
    _StatItem(
      target: 150,
      suffix: '+',
      labelKey: 'factory.stats.machines',
      icon: Icons.precision_manufacturing_outlined,
    ),
    _StatItem(
      target: 25,
      suffix: 'M+',
      labelKey: 'factory.stats.meters',
      icon: Icons.straighten_outlined,
    ),
    _StatItem(
      target: 50,
      suffix: '+',
      labelKey: 'factory.stats.countries',
      icon: Icons.public_outlined,
    ),
    _StatItem(
      target: 30,
      suffix: '+',
      labelKey: 'factory.stats.years',
      icon: Icons.workspace_premium_outlined,
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
      key: const Key('factory-stats-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3ECDF), Color(0xFFFBF8F2), Color(0xFFF3ECDF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative element
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
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
                      label: 'factory.label'.tr(),
                      title: 'factory.title'.tr(),
                    )
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: 0.3, end: 0, duration: 700.ms),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Stats grid
                  isDesktop || isTablet
                      ? _StatsRow(
                          stats: _stats,
                          visible: _visible,
                          isDesktop: isDesktop,
                        )
                      : _StatsMobileGrid(
                          stats: _stats,
                          visible: _visible,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ─────────────────────────────────────────────────────────────

class _StatItem {
  final int target;
  final String suffix;
  final String labelKey;
  final IconData icon;

  const _StatItem({
    required this.target,
    required this.suffix,
    required this.labelKey,
    required this.icon,
  });
}

// ─── Desktop/Tablet: single row ─────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final List<_StatItem> stats;
  final bool visible;
  final bool isDesktop;

  const _StatsRow({
    required this.stats,
    required this.visible,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        final isLast = index == stats.length - 1;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: _AnimatedStatCard(
                  stat: stat,
                  visible: visible,
                  delay: Duration(milliseconds: 150 * index),
                ),
              ),
              if (!isLast)
                Container(
                  width: 1,
                  height: 80,
                  color: AppColors.accent.withOpacity(0.2),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Mobile: 2x2 grid ───────────────────────────────────────────────────────

class _StatsMobileGrid extends StatelessWidget {
  final List<_StatItem> stats;
  final bool visible;

  const _StatsMobileGrid({required this.stats, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AnimatedStatCard(
                stat: stats[0],
                visible: visible,
                delay: const Duration(milliseconds: 0),
              ),
            ),
            Container(width: 1, height: 80, color: AppColors.accent.withOpacity(0.2)),
            Expanded(
              child: _AnimatedStatCard(
                stat: stats[1],
                visible: visible,
                delay: const Duration(milliseconds: 150),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Divider(color: AppColors.accent.withOpacity(0.15), height: 1),
        ),
        Row(
          children: [
            Expanded(
              child: _AnimatedStatCard(
                stat: stats[2],
                visible: visible,
                delay: const Duration(milliseconds: 300),
              ),
            ),
            Container(width: 1, height: 80, color: AppColors.accent.withOpacity(0.2)),
            Expanded(
              child: _AnimatedStatCard(
                stat: stats[3],
                visible: visible,
                delay: const Duration(milliseconds: 450),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Animated counter card ──────────────────────────────────────────────────

class _AnimatedStatCard extends StatefulWidget {
  final _StatItem stat;
  final bool visible;
  final Duration delay;

  const _AnimatedStatCard({
    required this.stat,
    required this.visible,
    required this.delay,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _countAnimation;
  bool _started = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _countAnimation = Tween<double>(
      begin: 0,
      end: widget.stat.target.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant _AnimatedStatCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !_started) {
      _started = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxl,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: _hovered
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accent.withOpacity(0.08),
                    Colors.transparent,
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              widget.stat.icon,
              color: AppColors.accent.withOpacity(_hovered ? 1.0 : 0.6),
              size: 28,
            ),
            const SizedBox(height: AppSpacing.md),

            // Animated number
            AnimatedBuilder(
              animation: _countAnimation,
              builder: (context, _) {
                final value = _countAnimation.value.round();
                return Text(
                  '$value${widget.stat.suffix}',
                  style: AppTextStyles.statNumber.copyWith(
                    fontSize: 64,
                    color: AppColors.accent,
                    height: 1,
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.sm),

            // Label
            Text(
              widget.stat.labelKey.tr().toUpperCase(),
              style: AppTextStyles.statLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          .animate(target: widget.visible ? 1 : 0)
          .fadeIn(duration: 700.ms, delay: widget.delay)
          .slideY(begin: 0.3, end: 0, duration: 700.ms, delay: widget.delay),
    );
  }
}
