import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/animated_thread_background.dart';
import '../../core/widgets/luxury_button.dart';
import '../../core/widgets/section_header.dart';
import '../../cubits/home/home_cubit.dart';
import '../shared/navigation/app_navbar.dart';
import '../shared/navigation/mobile_drawer.dart';

// ─── Static content ───────────────────────────────────────────────────────────

const _navbarHeight = 72.0;

const _whyKeys = [
  'about.why.i1',
  'about.why.i2',
  'about.why.i3',
  'about.why.i4',
  'about.why.i5',
  'about.why.i6',
  'about.why.i7',
  'about.why.i8',
  'about.why.i9',
  'about.why.i10',
  'about.why.i11',
];

const _sectorKeys = [
  'about.sectors.s1',
  'about.sectors.s2',
  'about.sectors.s3',
  'about.sectors.s4',
  'about.sectors.s5',
  'about.sectors.s6',
  'about.sectors.s7',
  'about.sectors.s8',
  'about.sectors.s9',
  'about.sectors.s10',
  'about.sectors.s11',
];

class _Division {
  final String number;
  final IconData icon;
  final String titleKey;
  final String bodyKey;
  final String category;
  const _Division(
      this.number, this.icon, this.titleKey, this.bodyKey, this.category);
}

const _divisions = [
  _Division('01', Icons.horizontal_rule, 'about.divisions.tapesTitle',
      'about.divisions.tapesBody', 'tapes'),
  _Division('02', Icons.timeline, 'about.divisions.cordsTitle',
      'about.divisions.cordsBody', 'cords'),
  _Division('03', Icons.linear_scale, 'about.divisions.elasticTitle',
      'about.divisions.elasticBody', 'elastic'),
  _Division('04', Icons.print_outlined, 'about.divisions.printingTitle',
      'about.divisions.printingBody', 'printing'),
  _Division('05', Icons.palette_outlined, 'about.divisions.dyeingTitle',
      'about.divisions.dyeingBody', 'dyeing'),
  _Division('06', Icons.pattern, 'about.divisions.knittingTitle',
      'about.divisions.knittingBody', 'knitting'),
];

const _stats = [
  (value: '2010', labelKey: 'about.story.stat1'),
  (value: '15+', labelKey: 'about.story.stat2'),
  (value: '6', labelKey: 'about.story.stat3'),
  (value: '35+', labelKey: 'about.story.stat4'),
];

// ─── Layout helper ────────────────────────────────────────────────────────────

class _Layout {
  final bool isDesktop;
  final bool isTablet;
  final double hPad;

  factory _Layout.of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    return _Layout._(
      isDesktop,
      isTablet,
      isDesktop
          ? AppSpacing.sectionHPadding
          : isTablet
              ? AppSpacing.tabletPadding
              : AppSpacing.mobilePadding,
    );
  }

  const _Layout._(this.isDesktop, this.isTablet, this.hPad);
}

// ─── Entry point ──────────────────────────────────────────────────────────────

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _AboutScaffold(),
    );
  }
}

class _AboutScaffold extends StatefulWidget {
  const _AboutScaffold();

  @override
  State<_AboutScaffold> createState() => _AboutScaffoldState();
}

class _AboutScaffoldState extends State<_AboutScaffold> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() =>
      context.read<HomeCubit>().onScroll(_scrollController.offset);

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MobileDrawer(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: const Column(
              children: [
                _HeroSection(),
                _StorySection(),
                _VisionMissionSection(),
                _WhySection(),
                _DivisionsSection(),
                _SectorsSection(),
                _QualityBand(),
                _CtaSection(),
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
    final l = _Layout.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: AnimatedThreadBackground(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            l.hPad,
            _navbarHeight + AppSpacing.xxxl,
            l.hPad,
            AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Breadcrumb(current: 'nav.about'.tr()),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                label: 'about.hero.label'.tr(),
                title: 'about.hero.title'.tr(),
                alignment: CrossAxisAlignment.start,
              )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.2, end: 0, duration: 700.ms),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: l.isDesktop ? 720 : double.infinity,
                child: Text(
                  'about.hero.subtitle'.tr(),
                  style: AppTextStyles.bodyLarge,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
              const SizedBox(height: AppSpacing.xxl),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _Badge(
                    icon: Icons.location_on_outlined,
                    label: 'about.hero.badge1'.tr(),
                  ),
                  _Badge(
                    icon: Icons.calendar_today_outlined,
                    label: 'about.hero.badge2'.tr(),
                  ),
                  _Badge(
                    icon: Icons.verified_outlined,
                    label: 'about.hero.badge3'.tr(),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 350.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final String current;
  const _Breadcrumb({required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go('/'),
            child: Text(
              'nav.home'.tr(),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text('/', style: AppTextStyles.bodySmall),
        ),
        Text(
          current,
          style:
              AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withValues(alpha: 0.85),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ─── Story ────────────────────────────────────────────────────────────────────

class _StorySection extends StatelessWidget {
  const _StorySection();

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);

    final narrative = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          label: 'about.story.label'.tr(),
          title: 'about.story.title'.tr(),
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('about.story.p1'.tr(), style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppSpacing.md),
        Text('about.story.p2'.tr(), style: AppTextStyles.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        Text('about.story.p3'.tr(), style: AppTextStyles.bodyMedium),
      ],
    );

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
          horizontal: l.hPad, vertical: AppSpacing.section),
      child: l.isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: narrative),
                const SizedBox(width: AppSpacing.xxxl),
                const Expanded(flex: 4, child: _StatPanel()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                narrative,
                const SizedBox(height: AppSpacing.xxl),
                const _StatPanel(),
              ],
            ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0, duration: 700.ms);
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < _stats.length; i++) ...[
            if (i > 0)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Container(height: 1, color: AppColors.divider),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _stats[i].value,
                  style: AppTextStyles.statNumber.copyWith(fontSize: 44),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    _stats[i].labelKey.tr(),
                    style: AppTextStyles.statLabel,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Vision & Mission ─────────────────────────────────────────────────────────

class _VisionMissionSection extends StatelessWidget {
  const _VisionMissionSection();

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);

    const vision = _PillarCard(
      icon: Icons.visibility_outlined,
      titleKey: 'about.vision.visionTitle',
      bodyKey: 'about.vision.visionBody',
    );
    const mission = _PillarCard(
      icon: Icons.flag_outlined,
      titleKey: 'about.vision.missionTitle',
      bodyKey: 'about.vision.missionBody',
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.sectionGradient),
      padding: EdgeInsets.symmetric(
          horizontal: l.hPad, vertical: AppSpacing.section),
      child: Column(
        children: [
          SectionHeader(
            label: 'about.vision.label'.tr(),
            title: 'about.vision.title'.tr(),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          if (l.isTablet)
            const IntrinsicHeight(

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: vision),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(child: mission),
                ],
              ),
            )
          else
            const Column(
              children: [
                vision,
                SizedBox(height: AppSpacing.lg),
                mission,
              ],
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.1, end: 0, duration: 700.ms);
  }
}

class _PillarCard extends StatefulWidget {
  final IconData icon;
  final String titleKey;
  final String bodyKey;

  const _PillarCard({
    required this.icon,
    required this.titleKey,
    required this.bodyKey,
  });

  @override
  State<_PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<_PillarCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          border: Border.all(
            color: AppColors.gold
                .withValues(alpha: _hovered ? 0.6 : 0.18),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    blurRadius: 36,
                  ),
                ]
              : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: AppColors.accent, size: 28),
            const SizedBox(height: AppSpacing.md),
            Text(widget.titleKey.tr(), style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 1,
              decoration: const BoxDecoration(gradient: AppColors.goldGradient),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(widget.bodyKey.tr(), style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// ─── Why Ylmar ────────────────────────────────────────────────────────────────

class _WhySection extends StatefulWidget {
  const _WhySection();

  @override
  State<_WhySection> createState() => _WhySectionState();
}

class _WhySectionState extends State<_WhySection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);
    final cols = l.isDesktop
        ? 3
        : l.isTablet
            ? 2
            : 1;

    return VisibilityDetector(
      key: const Key('about-why'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        color: AppColors.background,
        padding: EdgeInsets.symmetric(
            horizontal: l.hPad, vertical: AppSpacing.section),
        child: Column(
          children: [
            SectionHeader(
              label: 'about.why.label'.tr(),
              title: 'about.why.title'.tr(),
              subtitle: 'about.why.subtitle'.tr(),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                crossAxisSpacing: AppSpacing.lg,
                mainAxisSpacing: AppSpacing.lg,
                mainAxisExtent: 86,
              ),
              itemCount: _whyKeys.length,
              itemBuilder: (_, i) => _WhyItem(
                index: i,
                labelKey: _whyKeys[i],
                visible: _visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhyItem extends StatelessWidget {
  final int index;
  final String labelKey;
  final bool visible;

  const _WhyItem({
    required this.index,
    required this.labelKey,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final item = Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        color: AppColors.cardColor,
        border: Border(
          left: BorderSide(color: AppColors.gold, width: 2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.check, color: AppColors.accent, size: 18),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              labelKey.tr(),
              style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );

    if (!visible) return Opacity(opacity: 0, child: item);

    return item
        .animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.05, end: 0, duration: 500.ms);
  }
}

// ─── Divisions ────────────────────────────────────────────────────────────────

class _DivisionsSection extends StatelessWidget {
  const _DivisionsSection();

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);
    final cols = l.isDesktop
        ? 3
        : l.isTablet
            ? 2
            : 1;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.sectionGradient),
      padding: EdgeInsets.symmetric(
          horizontal: l.hPad, vertical: AppSpacing.section),
      child: Column(
        children: [
          SectionHeader(
            label: 'about.divisions.label'.tr(),
            title: 'about.divisions.title'.tr(),
            subtitle: 'about.divisions.subtitle'.tr(),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing: AppSpacing.lg,
              mainAxisExtent: 280,
            ),
            itemCount: _divisions.length,
            itemBuilder: (_, i) => _DivisionCard(division: _divisions[i]),
          ),
          const SizedBox(height: AppSpacing.xxl),
          LuxuryButton(
            label: 'about.divisions.cta'.tr(),
            icon: Icons.arrow_forward,
            onTap: () => context.go('/products'),
          ),
        ],
      ),
    );
  }
}

class _DivisionCard extends StatefulWidget {
  final _Division division;
  const _DivisionCard({required this.division});

  @override
  State<_DivisionCard> createState() => _DivisionCardState();
}

class _DivisionCardState extends State<_DivisionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.division;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/products'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(
              color: AppColors.gold
                  .withValues(alpha: _hovered ? 0.6 : 0.18),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      blurRadius: 36,
                    ),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(d.icon, color: AppColors.accent, size: 26),
                  Text(
                    d.number,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.gold.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(d.titleKey.tr(), style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _hovered ? 64 : 32,
                height: 1,
                decoration:
                    const BoxDecoration(gradient: AppColors.goldGradient),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Text(
                  d.bodyKey.tr(),
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sectors ──────────────────────────────────────────────────────────────────

class _SectorsSection extends StatelessWidget {
  const _SectorsSection();

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
          horizontal: l.hPad, vertical: AppSpacing.section),
      child: Column(
        children: [
          SectionHeader(
            label: 'about.sectors.label'.tr(),
            title: 'about.sectors.title'.tr(),
            subtitle: 'about.sectors.subtitle'.tr(),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < _sectorKeys.length; i++)
                _SectorChip(labelKey: _sectorKeys[i], index: i),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectorChip extends StatefulWidget {
  final String labelKey;
  final int index;
  const _SectorChip({required this.labelKey, required this.index});

  @override
  State<_SectorChip> createState() => _SectorChipState();
}

class _SectorChipState extends State<_SectorChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.primary : AppColors.surfaceAlt,
          border: Border.all(
            color: AppColors.gold.withValues(alpha: _hovered ? 0.7 : 0.25),
          ),
        ),
        child: Text(
          widget.labelKey.tr(),
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 14,
            color: _hovered ? AppColors.background : AppColors.textPrimary,
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 40 * widget.index))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.94, 0.94), duration: 400.ms);
  }
}

// ─── Quality band ─────────────────────────────────────────────────────────────

class _QualityBand extends StatelessWidget {
  const _QualityBand();

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.navyGradient),
      padding: EdgeInsets.symmetric(
          horizontal: l.hPad, vertical: AppSpacing.section),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 30, height: 1, color: AppColors.gold),
              const SizedBox(width: AppSpacing.sm + 4),
              Text(
                'about.quality.label'.tr().toUpperCase(),
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.highlight),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Container(width: 30, height: 1, color: AppColors.gold),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'about.quality.title'.tr(),
            style: AppTextStyles.headlineLarge
                .copyWith(color: AppColors.background),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: l.isDesktop ? 720 : double.infinity,
            child: Text(
              'about.quality.body'.tr(),
              style: AppTextStyles.bodyLarge
                  .copyWith(color: const Color(0xFFC7BFB0)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 700.ms)
          .slideY(begin: 0.1, end: 0, duration: 700.ms),
    );
  }
}

// ─── CTA ──────────────────────────────────────────────────────────────────────

class _CtaSection extends StatelessWidget {
  const _CtaSection();

  @override
  Widget build(BuildContext context) {
    final l = _Layout.of(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
          horizontal: l.hPad, vertical: AppSpacing.section),
      child: Column(
        children: [
          SectionHeader(
            label: 'about.cta.label'.tr(),
            title: 'about.cta.title'.tr(),
            subtitle: 'about.cta.subtitle'.tr(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            alignment: WrapAlignment.center,
            children: [
              LuxuryButton(
                label: 'about.cta.primary'.tr(),
                icon: Icons.mail_outline,
                onTap: () => context.go('/contact'),
              ),
              LuxuryButton(
                label: 'about.cta.secondary'.tr(),
                type: LuxuryButtonType.outline,
                icon: Icons.arrow_forward,
                onTap: () => context.go('/products'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
