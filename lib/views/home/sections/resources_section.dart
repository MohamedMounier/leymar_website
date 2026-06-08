import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/glass_card.dart';
import 'package:lymar_sample_project/core/widgets/luxury_button.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';

class ResourcesSection extends StatefulWidget {
  const ResourcesSection({super.key});

  @override
  State<ResourcesSection> createState() => _ResourcesSectionState();
}

class _ResourcesSectionState extends State<ResourcesSection> {
  bool _visible = false;

  static const _articles = [
    _Article(
      category: 'Technical Guide',
      title: 'Choosing the Right Elastic Width',
      excerpt:
          'A technical guide to selecting elastic width for different applications — from garment waistbands to industrial strapping, the right choice affects performance.',
      readTime: '8 min read',
      gradientColors: [Color(0xFF071B3B), Color(0xFF0D2D66)],
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=320&fit=crop&auto=format',
    ),
    _Article(
      category: 'Design Guide',
      title: 'The Art of Custom Jacquard Design',
      excerpt:
          'From brand logo integration to complex patterns: how our designers translate your vision into precision-woven textiles with lasting quality.',
      readTime: '12 min read',
      gradientColors: [Color(0xFF1A0A00), Color(0xFF3D1A00)],
      imageUrl: 'https://images.unsplash.com/photo-1614683489572-246acd13da13?w=600&h=320&fit=crop&auto=format',
    ),
    _Article(
      category: 'Industry Trends',
      title: '2025 Trends in Sustainable Textiles',
      excerpt:
          'How recycled materials are reshaping the industry — and why leading brands are shifting to GRS-certified elastic and ribbon solutions.',
      readTime: '10 min read',
      gradientColors: [Color(0xFF001A10), Color(0xFF003020)],
      imageUrl: 'https://images.unsplash.com/photo-1562887243-97e4f2c91c5e?w=600&h=320&fit=crop&auto=format',
    ),
  ];

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.15 && !_visible) {
      setState(() => _visible = true);
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
      key: const Key('resources-section'),
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
                  label: 'resources.label'.tr(),
                  title: 'resources.title'.tr(),
                  subtitle: 'resources.subtitle'.tr(),
                )
                    .animate()
                    .fadeIn(duration: 700.ms)
                    .slideY(begin: 0.3, end: 0, duration: 700.ms),

              const SizedBox(height: AppSpacing.xxxl),

              isDesktop || isTablet
                  ? _buildDesktopRow()
                  : _buildMobileColumn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _articles.asMap().entries.map((e) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: e.key > 0 ? AppSpacing.lg : 0),
              child: _ArticleCard(
                article: e.value,
                visible: _visible,
                delay: Duration(milliseconds: 150 * e.key),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileColumn() {
    return Column(
      children: _articles.asMap().entries.map((e) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: e.key < _articles.length - 1 ? AppSpacing.lg : 0,
          ),
          child: _ArticleCard(
            article: e.value,
            visible: _visible,
            delay: Duration(milliseconds: 150 * e.key),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

class _Article {
  final String category;
  final String title;
  final String excerpt;
  final String readTime;
  final List<Color> gradientColors;
  final String imageUrl;

  const _Article({
    required this.category,
    required this.title,
    required this.excerpt,
    required this.readTime,
    required this.gradientColors,
    required this.imageUrl,
  });
}

// ─── Article Card ─────────────────────────────────────────────────────────────

class _ArticleCard extends StatelessWidget {
  final _Article article;
  final bool visible;
  final Duration delay;

  const _ArticleCard({
    required this.article,
    required this.visible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final Widget card = GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article image
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: article.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(color: const Color(0xFF0F1F3D));
                  },
                ),
                // Dark gradient overlay at bottom for depth
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    article.category.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                Text(
                  article.title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Excerpt
                Text(
                  article.excerpt,
                  style: AppTextStyles.bodyMedium.copyWith(
                    height: 1.65,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Footer: read time + button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          color: AppColors.textSecondary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article.readTime,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    LuxuryButton(
                      label: 'resources.readArticle'.tr(),
                      type: LuxuryButtonType.outline,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
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

