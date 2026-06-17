import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/animated_thread_background.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/section_header.dart';
import '../../cubits/home/home_cubit.dart';
import '../shared/navigation/app_navbar.dart';

// ─── Data ────────────────────────────────────────────────────────────────────

class _AreaData {
  final String titleKey;
  final String descKey;
  final String imageUrl;
  final IconData icon;
  const _AreaData(this.titleKey, this.descKey, this.imageUrl, this.icon);
}

const _areas = [
  _AreaData(
    'factoryTour.areas.yarn.title', 'factoryTour.areas.yarn.desc',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=420&fit=crop&auto=format',
    Icons.corporate_fare_outlined,
  ),
  _AreaData(
    'factoryTour.areas.dyeing.title', 'factoryTour.areas.dyeing.desc',
    'https://images.unsplash.com/photo-1505236858219-8359eb29e329?w=600&h=420&fit=crop&auto=format',
    Icons.water_drop_outlined,
  ),
  _AreaData(
    'factoryTour.areas.weaving.title', 'factoryTour.areas.weaving.desc',
    'https://images.unsplash.com/photo-1587302168395-ef37ccf53d43?w=600&h=420&fit=crop&auto=format',
    Icons.blur_linear_outlined,
  ),
  _AreaData(
    'factoryTour.areas.qc.title', 'factoryTour.areas.qc.desc',
    'https://images.unsplash.com/photo-1565008782736-2b1e5fcb5c15?w=600&h=420&fit=crop&auto=format',
    Icons.verified_outlined,
  ),
  _AreaData(
    'factoryTour.areas.finishing.title', 'factoryTour.areas.finishing.desc',
    'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600&h=420&fit=crop&auto=format',
    Icons.inventory_2_outlined,
  ),
  _AreaData(
    'factoryTour.areas.logistics.title', 'factoryTour.areas.logistics.desc',
    'https://images.unsplash.com/photo-1578575437130-527eed3abbec?w=600&h=420&fit=crop&auto=format',
    Icons.local_shipping_outlined,
  ),
];

const _stats = [
  (target: 150, suffix: '+', labelKey: 'factory.stats.machines', icon: Icons.precision_manufacturing_outlined),
  (target: 25, suffix: 'M+', labelKey: 'factory.stats.meters', icon: Icons.straighten_outlined),
  (target: 50, suffix: '+', labelKey: 'factory.stats.countries', icon: Icons.public_outlined),
  (target: 30, suffix: '+', labelKey: 'factory.stats.years', icon: Icons.workspace_premium_outlined),
];

const _certs = [
  (icon: Icons.verified_outlined, title: 'OEKO-TEX® Standard 100', sub: 'certOeko'),
  (icon: Icons.shield_outlined, title: 'ISO 9001:2015', sub: 'certIso'),
  (icon: Icons.eco_outlined, title: 'Global Recycled Standard', sub: 'certGrs'),
  (icon: Icons.star_outline, title: 'Client Compliance', sub: 'certCustom'),
];

// ─── Entry point ─────────────────────────────────────────────────────────────

class FactoryTourView extends StatelessWidget {
  const FactoryTourView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _FactoryTourScaffold(),
    );
  }
}

class _FactoryTourScaffold extends StatefulWidget {
  const _FactoryTourScaffold();

  @override
  State<_FactoryTourScaffold> createState() => _FactoryTourScaffoldState();
}

class _FactoryTourScaffoldState extends State<_FactoryTourScaffold> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      context.read<HomeCubit>().onScroll(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 72),
                const _HeroSection(),
                const _StatsSection(),
                const _AreasSection(),
                const _ProcessSection(),
                const _CertificationsSection(),
                const _VisitCTASection(),
                const SizedBox(height: AppSpacing.xxxl),
              ],
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: AppNavbar()),
        ],
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return SizedBox(
      height: isDesktop ? 680 : 520,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1581091226033-d5c48150dbaa?w=1920&h=1080&fit=crop&auto=format',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
          ),
          // Dark overlay gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(0x55FBF8F2),
                  Color(0xF2FBF8F2),
                ],
              ),
            ),
          ),
          // Thread particles
          AnimatedThreadBackground(
            enableMouseInteraction: true,
            child: const SizedBox.expand(),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Text('nav.home'.tr(),
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.accent.withOpacity(0.8))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('/',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textMuted)),
                    ),
                    Text('nav.factoryTour'.tr(),
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: AppSpacing.lg),

                // Label
                Row(
                  children: [
                    Container(width: 30, height: 1, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Text('factoryTour.hero.label'.tr(),
                        style: AppTextStyles.labelLarge),
                    const SizedBox(width: 12),
                    Container(width: 30, height: 1, color: AppColors.accent),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                const SizedBox(height: AppSpacing.md),

                // Title
                Text(
                  'factoryTour.hero.title'.tr(),
                  style: (isDesktop
                          ? AppTextStyles.displayMedium
                          : AppTextStyles.headlineLarge)
                      .copyWith(fontWeight: FontWeight.w600),
                )
                    .animate()
                    .fadeIn(duration: 700.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0, duration: 700.ms, delay: 200.ms),
                const SizedBox(height: AppSpacing.md),

                // Subtitle
                SizedBox(
                  width: isDesktop ? 540 : double.infinity,
                  child: Text(
                    'factoryTour.hero.subtitle'.tr(),
                    style: AppTextStyles.bodyLarge,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Badges row
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _HeroBadge(
                        icon: Icons.location_on_outlined,
                        label: 'factoryTour.hero.badge1'.tr()),
                    _HeroBadge(
                        icon: Icons.factory_outlined,
                        label: 'factoryTour.hero.badge2'.tr()),
                    _HeroBadge(
                        icon: Icons.calendar_today_outlined,
                        label: 'factoryTour.hero.badge3'.tr()),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
              ],
            ),
          ),

          // Bottom gold line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: const BoxDecoration(gradient: AppColors.goldGradient),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HeroBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        border: Border.all(color: AppColors.gold.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 16),
          const SizedBox(width: 8),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

// ─── Stats ────────────────────────────────────────────────────────────────────

class _StatsSection extends StatefulWidget {
  const _StatsSection();

  @override
  State<_StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<_StatsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return VisibilityDetector(
      key: const Key('factory-tour-stats'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surfaceAlt, AppColors.background],
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: AppSpacing.xxxl, horizontal: hPad),
        child: isTablet
            ? Row(
                children: _stats.asMap().entries.map((e) {
                  final s = e.value;
                  return Expanded(
                    child: _StatCounter(
                      target: s.target,
                      suffix: s.suffix,
                      labelKey: s.labelKey,
                      icon: s.icon,
                      visible: _visible,
                      delay: Duration(milliseconds: 150 * e.key),
                      showDivider: e.key < _stats.length - 1,
                    ),
                  );
                }).toList(),
              )
            : GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                children: _stats.asMap().entries.map((e) {
                  final s = e.value;
                  return _StatCounter(
                    target: s.target,
                    suffix: s.suffix,
                    labelKey: s.labelKey,
                    icon: s.icon,
                    visible: _visible,
                    delay: Duration(milliseconds: 150 * e.key),
                    showDivider: false,
                  );
                }).toList(),
              ),
      ),
    );
  }
}

class _StatCounter extends StatefulWidget {
  final int target;
  final String suffix;
  final String labelKey;
  final IconData icon;
  final bool visible;
  final Duration delay;
  final bool showDivider;

  const _StatCounter({
    required this.target,
    required this.suffix,
    required this.labelKey,
    required this.icon,
    required this.visible,
    required this.delay,
    required this.showDivider,
  });

  @override
  State<_StatCounter> createState() => _StatCounterState();
}

class _StatCounterState extends State<_StatCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _anim = Tween<double>(begin: 0, end: widget.target.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant _StatCounter old) {
    super.didUpdateWidget(old);
    if (widget.visible && !_ctrl.isAnimating && _ctrl.value == 0) {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
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
                  Icon(widget.icon,
                      color: AppColors.accent.withOpacity(_hovered ? 1.0 : 0.6),
                      size: 28),
                  const SizedBox(height: 12),
                  AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) => Text(
                      '${_anim.value.round()}${widget.suffix}',
                      style: AppTextStyles.statNumber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.labelKey.tr(),
                    style: AppTextStyles.statLabel,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (widget.showDivider)
            Container(
              width: 1,
              height: 80,
              color: AppColors.accent.withOpacity(0.2),
            ),
        ],
      ),
    );
  }
}

// ─── Factory Areas ────────────────────────────────────────────────────────────

class _AreasSection extends StatefulWidget {
  const _AreasSection();

  @override
  State<_AreasSection> createState() => _AreasSectionState();
}

class _AreasSectionState extends State<_AreasSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;
    final cols = isDesktop ? 3 : isTablet ? 2 : 1;

    return VisibilityDetector(
      key: const Key('factory-tour-areas'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        color: AppColors.background,
        padding: EdgeInsets.symmetric(
            vertical: AppSpacing.section, horizontal: hPad),
        child: Column(
          children: [
            if (_visible)
              SectionHeader(
                label: 'factoryTour.areas.label'.tr(),
                title: 'factoryTour.areas.title'.tr(),
                subtitle: 'factoryTour.areas.subtitle'.tr(),
              )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0, duration: 700.ms),
            const SizedBox(height: AppSpacing.xxxl),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                childAspectRatio: 0.85,
              ),
              itemCount: _areas.length,
              itemBuilder: (context, i) => _AreaCard(
                data: _areas[i],
                visible: _visible,
                delay: Duration(milliseconds: 80 * i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaCard extends StatefulWidget {
  final _AreaData data;
  final bool visible;
  final Duration delay;

  const _AreaCard({
    required this.data,
    required this.visible,
    required this.delay,
  });

  @override
  State<_AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<_AreaCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.6)
                : AppColors.accent.withOpacity(0.12),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedScale(
                      scale: _hovered ? 1.06 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      child: Image.network(
                        widget.data.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.primary),
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(_hovered ? 0.6 : 0.4),
                            ],
                            stops: const [0.3, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Area number
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.9),
                        ),
                        child: Icon(widget.data.icon,
                            color: AppColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info
            Container(
              color: AppColors.cardColor,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.titleKey.tr(),
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.data.descKey.tr(),
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: widget.delay)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms);
  }
}

// ─── Process Timeline ─────────────────────────────────────────────────────────

class _ProcessSection extends StatefulWidget {
  const _ProcessSection();

  @override
  State<_ProcessSection> createState() => _ProcessSectionState();
}

class _ProcessSectionState extends State<_ProcessSection> {
  bool _visible = false;

  static const _steps = [
    (number: '01', titleKey: 'manufacturing.steps.yarn.title', descKey: 'manufacturing.steps.yarn.description', icon: Icons.grain_outlined),
    (number: '02', titleKey: 'manufacturing.steps.dyeing.title', descKey: 'manufacturing.steps.dyeing.description', icon: Icons.water_drop_outlined),
    (number: '03', titleKey: 'manufacturing.steps.weaving.title', descKey: 'manufacturing.steps.weaving.description', icon: Icons.blur_linear_outlined),
    (number: '04', titleKey: 'manufacturing.steps.inspection.title', descKey: 'manufacturing.steps.inspection.description', icon: Icons.search_outlined),
    (number: '05', titleKey: 'manufacturing.steps.packaging.title', descKey: 'manufacturing.steps.packaging.description', icon: Icons.inventory_outlined),
    (number: '06', titleKey: 'manufacturing.steps.export.title', descKey: 'manufacturing.steps.export.description', icon: Icons.flight_takeoff_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return VisibilityDetector(
      key: const Key('factory-tour-process'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.surfaceAlt, AppColors.background],
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: AppSpacing.section, horizontal: hPad),
        child: Column(
          children: [
            if (_visible)
              SectionHeader(
                label: 'factoryTour.process.label'.tr(),
                title: 'factoryTour.process.title'.tr(),
                subtitle: 'manufacturing.subtitle'.tr(),
              )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0, duration: 700.ms),
            const SizedBox(height: AppSpacing.xxxl),
            if (isTablet)
              // Desktop/Tablet: 3x2 grid of steps
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _steps.take(3).toList().asMap().entries.map((e) {
                      return Expanded(
                        child: _ProcessStep(
                          step: e.value,
                          visible: _visible,
                          delay: Duration(milliseconds: 100 * e.key),
                          isLast: false,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _steps.skip(3).toList().asMap().entries.map((e) {
                      return Expanded(
                        child: _ProcessStep(
                          step: e.value,
                          visible: _visible,
                          delay: Duration(milliseconds: 300 + 100 * e.key),
                          isLast: e.key == 2,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            else
              Column(
                children: _steps.asMap().entries.map((e) {
                  return _ProcessStep(
                    step: e.value,
                    visible: _visible,
                    delay: Duration(milliseconds: 80 * e.key),
                    isLast: e.key == _steps.length - 1,
                    vertical: true,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final ({String number, String titleKey, String descKey, IconData icon}) step;
  final bool visible;
  final Duration delay;
  final bool isLast;
  final bool vertical;

  const _ProcessStep({
    required this.step,
    required this.visible,
    required this.delay,
    required this.isLast,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: vertical ? 0 : AppSpacing.sm,
        bottom: vertical ? AppSpacing.lg : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Number circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldGradient,
                ),
                child: Center(
                  child: Text(
                    step.number,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (!isLast && !vertical) ...[
                Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: AppColors.accent.withOpacity(0.3),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Icon(step.icon, color: AppColors.accent.withOpacity(0.7), size: 22),
          const SizedBox(height: AppSpacing.sm),
          Text(
            step.titleKey.tr(),
            style: AppTextStyles.titleMedium
                .copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            step.descKey.tr(),
            style: AppTextStyles.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms);
  }
}

// ─── Certifications ───────────────────────────────────────────────────────────

class _CertificationsSection extends StatefulWidget {
  const _CertificationsSection();

  @override
  State<_CertificationsSection> createState() => _CertificationsSectionState();
}

class _CertificationsSectionState extends State<_CertificationsSection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return VisibilityDetector(
      key: const Key('factory-tour-certs'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.2 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surfaceAlt, AppColors.background],
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: AppSpacing.section, horizontal: hPad),
        child: Column(
          children: [
            if (_visible)
              SectionHeader(
                label: 'factoryTour.certs.label'.tr(),
                title: 'factoryTour.certs.title'.tr(),
                subtitle: 'factoryTour.certs.subtitle'.tr(),
              )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, end: 0, duration: 700.ms),
            const SizedBox(height: AppSpacing.xxxl),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              alignment: WrapAlignment.center,
              children: _certs.asMap().entries.map((e) {
                final cert = e.value;
                return _CertBadge(
                  icon: cert.icon,
                  title: cert.title,
                  subKey: 'quality.${cert.sub}'.tr(),
                  visible: _visible,
                  delay: Duration(milliseconds: 100 * e.key),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertBadge extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subKey;
  final bool visible;
  final Duration delay;

  const _CertBadge({
    required this.icon,
    required this.title,
    required this.subKey,
    required this.visible,
    required this.delay,
  });

  @override
  State<_CertBadge> createState() => _CertBadgeState();
}

class _CertBadgeState extends State<_CertBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 220,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.cardColor
              : AppColors.cardColor.withOpacity(0.5),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.7)
                : AppColors.accent.withOpacity(0.2),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.15),
                    blurRadius: 30,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withOpacity(0.5)),
                color: AppColors.accent.withOpacity(0.08),
              ),
              child: Icon(widget.icon, color: AppColors.accent, size: 26),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              widget.title,
              style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              widget.subKey,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    )
        .animate(delay: widget.delay)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 500.ms);
  }
}

// ─── Visit CTA ────────────────────────────────────────────────────────────────

class _VisitCTASection extends StatelessWidget {
  const _VisitCTASection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPad),
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2D66), Color(0xFF071B3B)],
        ),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 30, height: 1, color: AppColors.accent),
              const SizedBox(width: 12),
              Text('factoryTour.cta.label'.tr(), style: AppTextStyles.labelLarge),
              const SizedBox(width: 12),
              Container(width: 30, height: 1, color: AppColors.accent),
            ],
          )
              .animate()
              .fadeIn(duration: 500.ms),
          const SizedBox(height: AppSpacing.md),
          Text(
            'factoryTour.cta.title'.tr(),
            style: AppTextStyles.headlineLarge.copyWith(color: AppColors.background),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: isDesktop ? 560 : double.infinity,
            child: Text(
              'factoryTour.cta.subtitle'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFFC7BFB0)),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: AppSpacing.xxl),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              LuxuryButton(
                label: 'factoryTour.cta.button'.tr(),
                type: LuxuryButtonType.primary,
                icon: Icons.calendar_month_outlined,
                onTap: () => context.go('/contact'),
              ),
              LuxuryButton(
                label: 'nav.products'.tr(),
                type: LuxuryButtonType.outline,
                icon: Icons.arrow_forward,
                onTap: () => context.go('/products'),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms),
        ],
      ),
    );
  }
}
