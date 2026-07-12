// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:visibility_detector/visibility_detector.dart';
// import 'package:lymar_sample_project/core/theme/app_colors.dart';
// import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
// import 'package:lymar_sample_project/core/theme/app_spacing.dart';
// import 'package:lymar_sample_project/core/widgets/section_header.dart';
//
// class GlobalReachSection extends StatefulWidget {
//   const GlobalReachSection({super.key});
//
//   @override
//   State<GlobalReachSection> createState() => _GlobalReachSectionState();
// }
//
// class _GlobalReachSectionState extends State<GlobalReachSection>
//     with TickerProviderStateMixin {
//   bool _visible = false;
//   late AnimationController _rotationController;
//   late AnimationController _pulseController;
//   late AnimationController _counterController;
//   late List<Animation<double>> _counterAnimations;
//
//   static const _regions = [
//     _Region(labelKey: 'globalReach.europe', countries: 28),
//     _Region(labelKey: 'globalReach.americas', countries: 12),
//     _Region(labelKey: 'globalReach.asiaPacific', countries: 15),
//     _Region(labelKey: 'globalReach.middleEast', countries: 8),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//
//     _rotationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 20),
//     )..repeat();
//
//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat(reverse: true);
//
//     _counterController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1800),
//     );
//
//     _counterAnimations = _regions.map((r) {
//       return Tween<double>(begin: 0, end: r.countries.toDouble()).animate(
//         CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
//       );
//     }).toList();
//   }
//
//   @override
//   void dispose() {
//     _rotationController.dispose();
//     _pulseController.dispose();
//     _counterController.dispose();
//     super.dispose();
//   }
//
//   void _onVisibilityChanged(VisibilityInfo info) {
//     if (info.visibleFraction > 0.15 && !_visible) {
//       setState(() => _visible = true);
//       _counterController.forward();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isDesktop = screenWidth >= 1200;
//     final isTablet = screenWidth >= 768;
//     final hPad = isDesktop
//         ? AppSpacing.sectionHPadding
//         : isTablet
//             ? AppSpacing.tabletPadding
//             : AppSpacing.mobilePadding;
//
//     return VisibilityDetector(
//       key: const Key('global-reach-section'),
//       onVisibilityChanged: _onVisibilityChanged,
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.background,
//               AppColors.surfaceAlt,
//               AppColors.background,
//             ],
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: AppSpacing.section,
//             horizontal: hPad,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               if (_visible)
//                 SectionHeader(
//                   label: 'globalReach.label'.tr(),
//                   title: 'globalReach.title'.tr(),
//                   subtitle: 'globalReach.subtitle'.tr(),
//                 )
//                     .animate()
//                     .fadeIn(duration: 700.ms)
//                     .slideY(begin: 0.3, end: 0, duration: 700.ms),
//
//               const SizedBox(height: AppSpacing.xxxl),
//
//               isDesktop
//                   ? _buildDesktopLayout()
//                   : _buildMobileLayout(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDesktopLayout() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Globe visualization
//         Expanded(
//           flex: 6,
//           child: _buildGlobe(),
//         ),
//         const SizedBox(width: AppSpacing.xxxl),
//         // Region stats
//         Expanded(
//           flex: 4,
//           child: _buildRegionStats(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMobileLayout() {
//     return Column(
//       children: [
//         _buildGlobe(),
//         const SizedBox(height: AppSpacing.xxxl),
//         _buildRegionStats(),
//       ],
//     );
//   }
//
//   Widget _buildGlobe() {
//     return AnimatedOpacity(
//       opacity: _visible ? 1.0 : 0.0,
//       duration: const Duration(milliseconds: 800),
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return AnimatedBuilder(
//               animation: Listenable.merge([_rotationController, _pulseController]),
//               builder: (context, _) {
//                 return CustomPaint(
//                   painter: _GlobePainter(
//                     rotationAngle: _rotationController.value * 2 * math.pi,
//                     pulseValue: _pulseController.value,
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRegionStats() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: _regions.asMap().entries.map((e) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: e.key < _regions.length - 1 ? AppSpacing.xl : 0,
//           ),
//           child: _RegionStatRow(
//             region: e.value,
//             animation: _counterAnimations[e.key],
//             visible: _visible,
//             delay: Duration(milliseconds: 200 * e.key),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
//
// // ─── Data model ──────────────────────────────────────────────────────────────
//
// class _Region {
//   final String labelKey;
//   final int countries;
//
//   const _Region({
//     required this.labelKey,
//     required this.countries,
//   });
// }
//
// // ─── Globe CustomPainter ─────────────────────────────────────────────────────
//
// class _GlobePainter extends CustomPainter {
//   final double rotationAngle;
//   final double pulseValue;
//
//   _GlobePainter({required this.rotationAngle, required this.pulseValue});
//
//   // Export country positions as normalized (x, y) on globe surface
//   static const List<Offset> _countries = [
//     Offset(0.42, 0.28),  // Germany
//     Offset(0.38, 0.32),  // France
//     Offset(0.35, 0.40),  // Spain
//     Offset(0.55, 0.25),  // Russia
//     Offset(0.60, 0.38),  // Gulf
//     Offset(0.65, 0.42),  // India
//     Offset(0.75, 0.35),  // China
//     Offset(0.80, 0.55),  // Australia
//     Offset(0.25, 0.40),  // USA
//     Offset(0.22, 0.55),  // Brazil
//   ];
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width * 0.42;
//
//     // --- Outer glow ---
//     final glowPaint = Paint()
//       ..shader = RadialGradient(
//         colors: [
//           AppColors.secondary.withOpacity(0.25),
//           AppColors.accent.withOpacity(0.05),
//           Colors.transparent,
//         ],
//         stops: const [0.0, 0.7, 1.0],
//       ).createShader(Rect.fromCircle(center: center, radius: radius * 1.3));
//     canvas.drawCircle(center, radius * 1.3, glowPaint);
//
//     // --- Globe fill ---
//     final fillPaint = Paint()
//       ..shader = RadialGradient(
//         center: const Alignment(-0.3, -0.3),
//         colors: [
//           AppColors.secondary,
//           AppColors.primary,
//           AppColors.primaryDark,
//         ],
//         stops: const [0.0, 0.55, 1.0],
//       ).createShader(Rect.fromCircle(center: center, radius: radius));
//     canvas.drawCircle(center, radius, fillPaint);
//
//     // --- Latitude lines ---
//     final latPaint = Paint()
//       ..color = AppColors.highlight.withOpacity(0.24)
//       ..strokeWidth = 0.8
//       ..style = PaintingStyle.stroke;
//
//     for (int i = 1; i <= 5; i++) {
//       final yOffset = radius * (i / 3 - 1.0);
//       final latRadius = math.sqrt(math.max(0, radius * radius - yOffset * yOffset));
//       final rect = Rect.fromCenter(
//         center: Offset(center.dx, center.dy + yOffset),
//         width: latRadius * 2,
//         height: latRadius * 0.5,
//       );
//       canvas.drawOval(rect, latPaint);
//     }
//
//     // --- Longitude lines ---
//     final lonPaint = Paint()
//       ..color = AppColors.highlight.withOpacity(0.16)
//       ..strokeWidth = 0.8
//       ..style = PaintingStyle.stroke;
//
//     for (int i = 0; i < 6; i++) {
//       final angle = (rotationAngle + i * math.pi / 3) % (math.pi * 2);
//       final xOffset = radius * 0.85 * math.sin(angle);
//       final rect = Rect.fromCenter(
//         center: center,
//         width: math.max(4, xOffset.abs() * 2),
//         height: radius * 2,
//       );
//       canvas.drawOval(rect, lonPaint);
//     }
//
//     // --- Globe outline ---
//     final outlinePaint = Paint()
//       ..color = AppColors.accent.withOpacity(0.4)
//       ..strokeWidth = 1.5
//       ..style = PaintingStyle.stroke;
//     canvas.drawCircle(center, radius, outlinePaint);
//
//     // --- Pulsing origin circle (Turkey) ---
//     final turkeyPos = Offset(
//       center.dx + radius * 0.08,
//       center.dy - radius * 0.15,
//     );
//     for (int i = 0; i < 3; i++) {
//       final pulseRadius = (16.0 + i * 12) * (0.6 + pulseValue * 0.4);
//       final pulseOpacity = (1.0 - i * 0.3) * (0.7 - pulseValue * 0.4);
//       final pulsePaint = Paint()
//         ..color = AppColors.accent.withOpacity(pulseOpacity.clamp(0, 1))
//         ..strokeWidth = 1
//         ..style = PaintingStyle.stroke;
//       canvas.drawCircle(turkeyPos, pulseRadius, pulsePaint);
//     }
//
//     // Turkey dot
//     final turkeyDotPaint = Paint()
//       ..color = AppColors.highlight
//       ..style = PaintingStyle.fill;
//     canvas.drawCircle(turkeyPos, 5, turkeyDotPaint);
//
//     // --- Export country dots ---
//     for (final normalized in _countries) {
//       // Rotate x position
//       final baseAngle = normalized.dx * 2 * math.pi;
//       final rotated = (baseAngle + rotationAngle) % (2 * math.pi);
//       // Only draw dots on the visible hemisphere
//       final visibility = math.cos(rotated - math.pi / 2);
//       if (visibility < 0) continue;
//
//       final x = center.dx + radius * math.sin(rotated) * (1 - (normalized.dy - 0.5).abs());
//       final y = center.dy + radius * (normalized.dy * 2 - 1) * 0.85;
//
//       final dotOpacity = (visibility * 0.8 + 0.2).clamp(0.0, 1.0);
//
//       final dotPaint = Paint()
//         ..color = AppColors.accent.withOpacity(dotOpacity)
//         ..style = PaintingStyle.fill;
//       canvas.drawCircle(Offset(x, y), 4 * visibility.clamp(0.3, 1.0), dotPaint);
//
//       // Small glow around dot
//       final dotGlowPaint = Paint()
//         ..color = AppColors.accent.withOpacity(dotOpacity * 0.25)
//         ..style = PaintingStyle.fill;
//       canvas.drawCircle(Offset(x, y), 8 * visibility.clamp(0.3, 1.0), dotGlowPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant _GlobePainter oldDelegate) {
//     return oldDelegate.rotationAngle != rotationAngle ||
//         oldDelegate.pulseValue != pulseValue;
//   }
// }
//
// // ─── Region stat row ─────────────────────────────────────────────────────────
//
// class _RegionStatRow extends StatelessWidget {
//   final _Region region;
//   final Animation<double> animation;
//   final bool visible;
//   final Duration delay;
//
//   const _RegionStatRow({
//     required this.region,
//     required this.animation,
//     required this.visible,
//     required this.delay,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final Widget row = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               region.labelKey.tr(),
//               style: AppTextStyles.titleMedium.copyWith(
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             AnimatedBuilder(
//               animation: animation,
//               builder: (context, _) {
//                 return Text(
//                   '${animation.value.round()} ${'globalReach.countries'.tr()}',
//                   style: AppTextStyles.goldAccent,
//                 );
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: AppSpacing.sm),
//         // Progress bar
//         ClipRect(
//           child: AnimatedBuilder(
//             animation: animation,
//             builder: (context, _) {
//               final progress = region.countries > 0
//                   ? animation.value / region.countries
//                   : 0.0;
//               return LinearProgressIndicator(
//                 value: progress,
//                 backgroundColor: AppColors.secondary.withOpacity(0.3),
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
//                 minHeight: 2,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//
//     if (!visible) return row;
//
//     return row
//         .animate()
//         .fadeIn(duration: 700.ms, delay: delay)
//         .slideX(begin: 0.3, end: 0, duration: 700.ms, delay: delay);
//   }
// }
