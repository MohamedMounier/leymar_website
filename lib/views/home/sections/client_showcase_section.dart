import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class ClientShowcaseSection extends StatefulWidget {
  const ClientShowcaseSection({super.key});

  @override
  State<ClientShowcaseSection> createState() => _ClientShowcaseSectionState();
}

class _ClientShowcaseSectionState extends State<ClientShowcaseSection>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  bool _hovered = false;
  late AnimationController _scrollController;
  late Animation<double> _scrollAnimation;

  static const _clients = [
    'Maison Laurent',
    'ProSport GmbH',
    'MedTex Solutions',
    'Dragon Apparel',
    'Nordic Fashion House',
    'Atlas Industries',
    'Pacific Textiles',
    'Euro Comfort',
    'Global Sports Co.',
    'Premium Brands Ltd',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _scrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scrollController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.1 && !_visible) {
      setState(() => _visible = true);
    }
  }

  void _onHoverEnter() {
    if (!_hovered) {
      setState(() => _hovered = true);
      _scrollController.stop();
    }
  }

  void _onHoverExit() {
    if (_hovered) {
      setState(() => _hovered = false);
      _scrollController.repeat();
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
      key: const Key('client-showcase-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.primary.withOpacity(0.3),
              AppColors.background,
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.section,
                bottom: AppSpacing.xxxl,
                left: hPad,
                right: hPad,
              ),
              child: Column(
                children: [
                  if (_visible)
                    SectionHeader(
                      label: 'clients.label'.tr(),
                      title: 'clients.title'.tr(),
                    )
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: 0.3, end: 0, duration: 700.ms),
                ],
              ),
            ),

            // Infinite scroll ticker
            if (_visible) _buildScrollingLogoWall(),

            SizedBox(height: AppSpacing.section),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollingLogoWall() {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: SizedBox(
        height: 100,
        child: AnimatedBuilder(
          animation: _scrollAnimation,
          builder: (context, _) {
            return _ScrollingRow(
              clients: _clients,
              scrollValue: _scrollAnimation.value,
            );
          },
        ),
      )
          .animate()
          .fadeIn(duration: 800.ms, delay: 300.ms),
    );
  }
}

// ─── Scrolling row using a ClipRect + single Row that shifts ─────────────────

class _ScrollingRow extends StatelessWidget {
  final List<String> clients;
  final double scrollValue;

  const _ScrollingRow({
    required this.clients,
    required this.scrollValue,
  });

  @override
  Widget build(BuildContext context) {
    // Each logo card is 200px wide + 16px gap
    const cardWidth = 200.0;
    const gap = 16.0;
    const itemWidth = cardWidth + gap;
    final totalWidth = clients.length * itemWidth;

    // Offset from 0 to totalWidth, then loops
    final offset = -(scrollValue * totalWidth) % totalWidth;

    return ClipRect(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        maxWidth: double.infinity,
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Duplicate the list twice for seamless loop
              ...clients.map((c) => _LogoCard(name: c)),
              ...clients.map((c) => _LogoCard(name: c)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Logo Card ────────────────────────────────────────────────────────────────

class _LogoCard extends StatefulWidget {
  final String name;
  const _LogoCard({required this.name});

  @override
  State<_LogoCard> createState() => _LogoCardState();
}

class _LogoCardState extends State<_LogoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 200,
        height: 80,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F1F3D), Color(0xFF071B3B)],
          ),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.6)
                : AppColors.accent.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            widget.name,
            style: GoogleFonts.cormorant(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _hovered ? AppColors.highlight : AppColors.accent,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
