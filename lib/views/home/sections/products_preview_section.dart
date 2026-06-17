import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/glass_card.dart';
import 'package:lymar_sample_project/core/widgets/luxury_button.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';
import 'package:go_router/go_router.dart';
import 'package:lymar_sample_project/cubits/products/products_cubit.dart';
import 'package:lymar_sample_project/cubits/products/products_state.dart';
import 'package:lymar_sample_project/models/product_model.dart';

class ProductsPreviewSection extends StatefulWidget {
  const ProductsPreviewSection({super.key});

  @override
  State<ProductsPreviewSection> createState() => _ProductsPreviewSectionState();
}

class _ProductsPreviewSectionState extends State<ProductsPreviewSection> {
  bool _visible = false;

  static const List<Color> _placeholderColors = [
    Color(0xFF1A3A5C),
    Color(0xFF2C1A5C),
    Color(0xFF1A4A2C),
    Color(0xFF4A2C1A),
    Color(0xFF1A4A4A),
    Color(0xFF3A1A4A),
    Color(0xFF4A3A1A),
    Color(0xFF1A2C4A),
  ];

  Color _colorFromHex(String hex, int fallbackIndex) {
    try {
      final cleaned = hex.replaceAll('#', '');
      if (cleaned.length == 6) {
        return Color(int.parse('FF$cleaned', radix: 16));
      }
    } catch (_) {}
    return _placeholderColors[fallbackIndex % _placeholderColors.length];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadProducts();
    });
  }

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
      key: const Key('products-preview-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_visible) {
          setState(() => _visible = true);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFBF8F2),
              Color(0xFFF1E8D6),
              Color(0xFFFBF8F2),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.section,
          horizontal: hPad,
        ),
        child: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Section header
                if (_visible)
                  SectionHeader(
                    label: 'products.label'.tr(),
                    title: 'products.title'.tr(),
                  )
                      .animate()
                      .fadeIn(duration: 700.ms)
                      .slideY(begin: 0.3, end: 0, duration: 700.ms),

                const SizedBox(height: AppSpacing.xxl),

                // Category filter chips
                if (state.status == ProductsStatus.loaded &&
                    state.categories.isNotEmpty)
                  _CategoryFilterRow(
                    categories: state.categories
                        .map((c) => c.id)
                        .toList(),
                    categoryNames: {
                      'all': 'products.filter_all'.tr(),
                      for (final c in state.categories)
                        c.id: context.locale.languageCode == 'ar' ? c.nameAr : c.name,
                    },
                    selected: state.selectedCategory,
                    onSelect: (cat) =>
                        context.read<ProductsCubit>().filterByCategory(cat),
                    visible: _visible,
                  ),

                const SizedBox(height: AppSpacing.xxl),

                // Product grid or loading / error
                if (state.status == ProductsStatus.loading)
                  const _LoadingGrid()
                else if (state.status == ProductsStatus.error)
                  _ErrorState(message: state.errorMessage ?? 'products.error'.tr())
                else if (state.status == ProductsStatus.loaded)
                  _ProductGrid(
                    products: state.filteredProducts,
                    isDesktop: isDesktop,
                    isTablet: isTablet,
                    visible: _visible,
                    colorFromHex: _colorFromHex,
                  ),

                const SizedBox(height: AppSpacing.xxxl),

                // View all button
                if (_visible)
                  LuxuryButton(
                    label: 'products.view_all'.tr(),
                    type: LuxuryButtonType.outline,
                    icon: Icons.arrow_forward,
                    onTap: () => context.go('/products'),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Category Filter Row ────────────────────────────────────────────────────

class _CategoryFilterRow extends StatelessWidget {
  final List<String> categories;
  final Map<String, String> categoryNames;
  final String selected;
  final ValueChanged<String> onSelect;
  final bool visible;

  const _CategoryFilterRow({
    required this.categories,
    required this.categoryNames,
    required this.selected,
    required this.onSelect,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    final allCategories = ['all', ...categories];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: allCategories.asMap().entries.map((entry) {
          final index = entry.key;
          final cat = entry.value;
          final isSelected = cat == selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _FilterChip(
              label: categoryNames[cat] ?? cat,
              isSelected: isSelected,
              onTap: () => onSelect(cat),
              visible: visible,
              delay: Duration(milliseconds: 100 * index),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool visible;
  final Duration delay;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.visible,
    required this.delay,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.accent.withOpacity(0.15)
                : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? AppColors.accent
                  : AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: AppTextStyles.labelMedium.copyWith(
              color: isActive ? AppColors.accent : AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
      ),
    )
        .animate(target: widget.visible ? 1 : 0)
        .fadeIn(duration: 500.ms, delay: widget.delay)
        .slideX(begin: -0.2, end: 0, duration: 500.ms, delay: widget.delay);
  }
}

// ─── Product Grid ───────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool isDesktop;
  final bool isTablet;
  final bool visible;
  final Color Function(String hex, int index) colorFromHex;

  const _ProductGrid({
    required this.products,
    required this.isDesktop,
    required this.isTablet,
    required this.visible,
    required this.colorFromHex,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text(
            'products.empty'.tr(),
            style: AppTextStyles.bodyLarge,
          ),
        ),
      );
    }

    final crossAxisCount = isDesktop ? 4 : isTablet ? 2 : 1;
    final displayProducts = products.length > 8 ? products.sublist(0, 8) : products;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.75,
      ),
      itemCount: displayProducts.length,
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        final placeholderColor = product.colors.isNotEmpty
            ? colorFromHex(product.colors.first, index)
            : const Color(0xFF1A3A5C);

        return _ProductCard(
          product: product,
          placeholderColor: placeholderColor,
          visible: visible,
          delay: Duration(milliseconds: 80 * index),
          onTap: () => context.go('/product/${product.id}'),
        );
      },
    );
  }
}

String _productImageUrl(String category) {
  const urls = <String, String>{
    'elastic':     'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=400&fit=crop&auto=format',
    'jacquard':    'https://images.unsplash.com/photo-1614683489572-246acd13da13?w=600&h=400&fit=crop&auto=format',
    'waistband':   'https://images.unsplash.com/photo-1562887243-97e4f2c91c5e?w=600&h=400&fit=crop&auto=format',
    'drawcords':   'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=600&h=400&fit=crop&auto=format',
    'webbing':     'https://images.unsplash.com/photo-1504898770365-14faca6a7320?w=600&h=400&fit=crop&auto=format',
    'tapes':       'https://images.unsplash.com/photo-1587302168395-ef37ccf53d43?w=600&h=400&fit=crop&auto=format',
    'accessories': 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=600&h=400&fit=crop&auto=format',
    'custom':      'https://images.unsplash.com/photo-1565008782736-2b1e5fcb5c15?w=600&h=400&fit=crop&auto=format',
  };
  return urls[category] ??
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&h=400&fit=crop&auto=format';
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final Color placeholderColor;
  final bool visible;
  final Duration delay;
  final VoidCallback? onTap;

  const _ProductCard({
    required this.product,
    required this.placeholderColor,
    required this.visible,
    required this.delay,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final displayName = isArabic ? product.nameAr : product.name;
    final displayDescription = isArabic ? product.descriptionAr : product.description;

    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 0,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image area
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Product image from network
                Image.network(
                  _productImageUrl(product.category),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: placeholderColor.withOpacity(0.3),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFFC79A3B),
                            strokeWidth: 1.5,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            placeholderColor,
                            placeholderColor.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Color(0xFFC79A3B),
                        size: 32,
                      ),
                    );
                  },
                ),
                // Dark overlay for text readability
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                // Featured badge
                if (product.featured)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      color: const Color(0xFFC79A3B),
                      child: Text(
                        'products.featured'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF071B3B),
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Product info
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product.category.toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Product name
                  Text(
                    displayName,
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Description
                  Expanded(
                    child: Text(
                      displayDescription,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate(target: visible ? 1 : 0)
        .fadeIn(duration: 600.ms, delay: delay)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: delay);
  }
}

// ─── Loading / Error states ─────────────────────────────────────────────────

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          border: Border.all(
            color: AppColors.accent.withOpacity(0.1),
          ),
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
            duration: 1200.ms,
            color: AppColors.accent.withOpacity(0.1),
          ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, color: AppColors.accent, size: 48),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
