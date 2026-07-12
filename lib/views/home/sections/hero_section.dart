import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/animated_thread_background.dart';
import 'package:lymar_sample_project/core/widgets/luxury_button.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _scrollBounceController;
  late AnimationController _glowPulseController;

  late Animation<double> _gradientAnimation;
  late Animation<double> _scrollBounceAnimation;
  late Animation<double> _glowPulseAnimation;

  Offset _glowOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _scrollBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _scrollBounceAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _scrollBounceController, curve: Curves.easeInOut),
    );

    _glowPulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _scrollBounceController.dispose();
    _glowPulseController.dispose();
    super.dispose();
  }

  void _onMouseMove(PointerEvent event, BoxConstraints constraints) {
    final dx = event.localPosition.dx / constraints.maxWidth;
    final dy = event.localPosition.dy / constraints.maxHeight;
    setState(() {
      _glowOffset = Offset(
        (dx - 0.5) * 80,
        (dy - 0.5) * 60,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1200;
    final isMobile = size.width < 768;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MouseRegion(
            onHover: (event) => _onMouseMove(event, constraints),
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _gradientAnimation,
                _glowPulseAnimation,
              ]),
              builder: (context, child) {
                final t = _gradientAnimation.value;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(
                        -1.0 + t * 0.6,
                        -1.0,
                      ),
                      end: Alignment(
                        1.0 - t * 0.4,
                        1.0,
                      ),
                      colors: [
                        Color.lerp(
                          const Color(0xFFFFFDF9),
                          const Color(0xFFF6EFE2),
                          t,
                        )!,
                        Color.lerp(
                          const Color(0xFFF1E8D6),
                          const Color(0xFFFBF8F2),
                          t,
                        )!,
                        const Color(0xFFFBF8F2),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Full-screen factory background image (subtle, behind everything)
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.10,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1504898770365-14faca6a7320?w=1920&h=1080&fit=crop&auto=format&q=50',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                            loadingBuilder: (context, child, progress) => child,
                          ),
                        ),
                      ),

                      // Animated factory GIF — bottom right decorative element
                      Positioned(
                        bottom: 60,
                        right: 60,
                        child: SizedBox(
                          width: 220,
                          height: 140,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  'https://media.giphy.com/media/3oEduSbSGpHMVHOPRK/giphy.gif',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.network(
                                    'https://images.unsplash.com/photo-1565008782736-2b1e5fcb5c15?w=400&h=250&fit=crop&auto=format',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xFFC79A3B).withOpacity(0.5), width: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Animated thread background
                      Positioned.fill(
                        child: AnimatedThreadBackground(
                          enableMouseInteraction: true,
                          child: const SizedBox.expand(),
                        ),
                      ),

                      // Mouse-reactive gold blur glow
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        left: constraints.maxWidth * 0.5 +
                            _glowOffset.dx -
                            200,
                        top: constraints.maxHeight * 0.5 +
                            _glowOffset.dy -
                            200,
                        child: IgnorePointer(
                          child: Container(
                            width: 400,
                            height: 400,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.accent.withOpacity(
                                    0.12 * _glowPulseAnimation.value,
                                  ),
                                  AppColors.accent.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Corner decorative lines
                      Positioned(
                        top: 40,
                        left: 40,
                        child: _CornerDecoration(flip: false),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 40,
                        child: _CornerDecoration(flip: true),
                      ),

                      // Main center content
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile
                                ? AppSpacing.mobilePadding
                                : isDesktop
                                    ? AppSpacing.sectionHPadding
                                    : AppSpacing.tabletPadding,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo / brand mark
                              Text(
                                'Ylmar',
                                style: AppTextStyles.logoText.copyWith(
                                  fontSize: isMobile ? 20 : 28,
                                  letterSpacing: isMobile ? 6 : 10,
                                  color: AppColors.accent,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 200.ms)
                                  .slideY(
                                    begin: -0.3,
                                    end: 0,
                                    duration: 800.ms,
                                    delay: 200.ms,
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: AppSpacing.lg),

                              // Gold separator line
                              Container(
                                width: 60,
                                height: 1,
                                color: AppColors.accent.withOpacity(0.6),
                              )
                                  .animate()
                                  .scaleX(
                                    begin: 0,
                                    end: 1,
                                    duration: 600.ms,
                                    delay: 600.ms,
                                    curve: Curves.easeOut,
                                  )
                                  .fadeIn(duration: 400.ms, delay: 600.ms),

                              const SizedBox(height: AppSpacing.xl),

                              // Headline line 1
                              Text(
                                'hero.headline1'.tr(),
                                style: AppTextStyles.displayLarge.copyWith(
                                  fontSize: isMobile
                                      ? 36
                                      : isDesktop
                                          ? 80
                                          : 56,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              )
                                  .animate()
                                  .fadeIn(duration: 900.ms, delay: 800.ms)
                                  .slideY(
                                    begin: 0.4,
                                    end: 0,
                                    duration: 900.ms,
                                    delay: 800.ms,
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: AppSpacing.sm),

                              // Headline line 2 (gold)
                              Text(
                                'hero.headline2'.tr(),
                                style: AppTextStyles.displayLarge.copyWith(
                                  fontSize: isMobile
                                      ? 36
                                      : isDesktop
                                          ? 80
                                          : 56,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              )
                                  .animate()
                                  .fadeIn(duration: 900.ms, delay: 1100.ms)
                                  .slideY(
                                    begin: 0.4,
                                    end: 0,
                                    duration: 900.ms,
                                    delay: 1100.ms,
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: AppSpacing.xl),

                              // Subtitle
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isDesktop ? 600 : 480,
                                ),
                                child: Text(
                                  'hero.subtitle'.tr(),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontSize: isMobile ? 13 : 16,
                                    height: 1.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 1400.ms)
                                  .slideY(
                                    begin: 0.3,
                                    end: 0,
                                    duration: 800.ms,
                                    delay: 1400.ms,
                                    curve: Curves.easeOut,
                                  ),

                              const SizedBox(height: AppSpacing.xxl),

                              // CTA Buttons
                              Wrap(
                                spacing: AppSpacing.lg,
                                runSpacing: AppSpacing.md,
                                alignment: WrapAlignment.center,
                                children: [
                                  LuxuryButton(
                                    label: 'hero.cta_primary'.tr(),
                                    type: LuxuryButtonType.primary,
                                    icon: Icons.arrow_forward,
                                    onTap: () {},
                                  ),
                                  LuxuryButton(
                                    label: 'hero.cta_secondary'.tr(),
                                    type: LuxuryButtonType.outline,
                                    icon: Icons.play_circle_outline,
                                    onTap: () {},
                                  ),
                                ],
                              )
                                  .animate()
                                  .fadeIn(duration: 700.ms, delay: 1700.ms)
                                  .slideY(
                                    begin: 0.3,
                                    end: 0,
                                    duration: 700.ms,
                                    delay: 1700.ms,
                                    curve: Curves.easeOut,
                                  ),
                            ],
                          ),
                        ),
                      ),

                      // Scroll indicator at bottom
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _scrollBounceAnimation,
                          builder: (context, _) {
                            return Transform.translate(
                              offset: Offset(0, _scrollBounceAnimation.value),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'hero.scroll'.tr(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      letterSpacing: 2,
                                      color:
                                          AppColors.textSecondary.withOpacity(0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.accent.withOpacity(0.7),
                                    size: 28,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            .animate()
                            .fadeIn(duration: 600.ms, delay: 2200.ms),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CornerDecoration extends StatelessWidget {
  final bool flip;
  const _CornerDecoration({required this.flip});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: flip ? math.pi : 0,
      child: SizedBox(
        width: 40,
        height: 40,
        child: CustomPaint(
          painter: _CornerPainter(),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), paint);
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
