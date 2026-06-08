import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/glass_card.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class QualitySection extends StatefulWidget {
  const QualitySection({super.key});

  @override
  State<QualitySection> createState() => _QualitySectionState();
}

class _QualitySectionState extends State<QualitySection> {
  bool _visible = false;

  static const _certificates = [
    _Certificate(
      titleKey: 'quality.oeko.title',
      descKey: 'quality.oeko.description',
      icon: Icons.verified_outlined,
    ),
    _Certificate(
      titleKey: 'quality.iso.title',
      descKey: 'quality.iso.description',
      icon: Icons.workspace_premium_outlined,
    ),
    _Certificate(
      titleKey: 'quality.grs.title',
      descKey: 'quality.grs.description',
      icon: Icons.recycling,
    ),
    _Certificate(
      titleKey: 'quality.custom.title',
      descKey: 'quality.custom.description',
      icon: Icons.settings_outlined,
    ),
  ];

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.15 && !_visible) {
      setState(() => _visible = true);
    }
  }

  void _showCertificateDialog(BuildContext context, _Certificate cert) {
    showDialog(
      context: context,
      builder: (ctx) => _CertificateDialog(certificate: cert),
    );
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
      key: const Key('quality-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        color: AppColors.background,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.section,
            horizontal: hPad,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_visible)
                SectionHeader(
                  label: 'quality.label'.tr(),
                  title: 'quality.title'.tr(),
                  subtitle: 'quality.subtitle'.tr(),
                )
                    .animate()
                    .fadeIn(duration: 700.ms)
                    .slideY(begin: 0.3, end: 0, duration: 700.ms),

              const SizedBox(height: AppSpacing.xxxl),

              isDesktop || isTablet
                  ? _buildDesktopGrid(context, isDesktop)
                  : _buildMobileGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopGrid(BuildContext context, bool isDesktop) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _certificates.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: e.key > 0 ? AppSpacing.lg : 0,
            ),
            child: _CertificateCard(
              certificate: e.value,
              visible: _visible,
              delay: Duration(milliseconds: 150 * e.key),
              onTap: () => _showCertificateDialog(context, e.value),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _CertificateCard(
                certificate: _certificates[0],
                visible: _visible,
                delay: Duration.zero,
                onTap: () => _showCertificateDialog(context, _certificates[0]),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _CertificateCard(
                certificate: _certificates[1],
                visible: _visible,
                delay: const Duration(milliseconds: 150),
                onTap: () => _showCertificateDialog(context, _certificates[1]),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _CertificateCard(
                certificate: _certificates[2],
                visible: _visible,
                delay: const Duration(milliseconds: 300),
                onTap: () => _showCertificateDialog(context, _certificates[2]),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _CertificateCard(
                certificate: _certificates[3],
                visible: _visible,
                delay: const Duration(milliseconds: 450),
                onTap: () => _showCertificateDialog(context, _certificates[3]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

class _Certificate {
  final String titleKey;
  final String descKey;
  final IconData icon;

  const _Certificate({
    required this.titleKey,
    required this.descKey,
    required this.icon,
  });
}

// ─── Certificate Card ─────────────────────────────────────────────────────────

class _CertificateCard extends StatelessWidget {
  final _Certificate certificate;
  final bool visible;
  final Duration delay;
  final VoidCallback onTap;

  const _CertificateCard({
    required this.certificate,
    required this.visible,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget card = GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            certificate.icon,
            color: AppColors.accent,
            size: 40,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            certificate.titleKey.tr(),
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: 32,
            height: 1,
            color: AppColors.accent.withOpacity(0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            certificate.descKey.tr(),
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Text(
                'quality.viewDetails'.tr(),
                style: AppTextStyles.labelMedium.copyWith(
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.accent,
                size: 13,
              ),
            ],
          ),
        ],
      ),
    );

    if (!visible) return card;

    return card
        .animate()
        .fadeIn(duration: 700.ms, delay: delay)
        .slideY(begin: 0.3, end: 0, duration: 700.ms, delay: delay);
  }
}

// ─── Certificate Dialog ───────────────────────────────────────────────────────

class _CertificateDialog extends StatelessWidget {
  final _Certificate certificate;

  const _CertificateDialog({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          border: Border.all(
            color: AppColors.accent.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.15),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.accent.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    certificate.icon,
                    color: AppColors.accent,
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      certificate.titleKey.tr(),
                      style: AppTextStyles.headlineSmall,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certificate.descKey.tr(),
                    style: AppTextStyles.bodyLarge.copyWith(height: 1.8),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Gold separator
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: AppColors.accent.withOpacity(0.15),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'quality.certifiedBy'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    certificate.titleKey.tr(),
                    style: AppTextStyles.goldAccent,
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
