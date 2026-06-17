import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/animated_thread_background.dart';
import '../../cubits/products/products_cubit.dart';
import '../../cubits/products/products_state.dart';
import '../../cubits/home/home_cubit.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../repositories/products_repository.dart';
import '../shared/navigation/app_navbar.dart';

const _kProductImageBase = <String, String>{
  'elastic':     'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
  'jacquard':    'https://images.unsplash.com/photo-1614683489572-246acd13da13',
  'waistband':   'https://images.unsplash.com/photo-1562887243-97e4f2c91c5e',
  'drawcords':   'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3',
  'webbing':     'https://images.unsplash.com/photo-1504898770365-14faca6a7320',
  'tapes':       'https://images.unsplash.com/photo-1587302168395-ef37ccf53d43',
  'accessories': 'https://images.unsplash.com/photo-1585771724684-38269d6639fd',
  'custom':      'https://images.unsplash.com/photo-1565008782736-2b1e5fcb5c15',
};

String _productImageUrl(String category, {int w = 600, int h = 420}) {
  final base = _kProductImageBase[category] ?? _kProductImageBase['elastic']!;
  return '$base?w=$w&h=$h&fit=crop&auto=format';
}

// ─── Public entry point ─────────────────────────────────────────────────────

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ProductsCubit(repository: ProductsRepository())),
      ],
      child: const _ProductsScaffold(),
    );
  }
}

// ─── Scaffold ───────────────────────────────────────────────────────────────

class _ProductsScaffold extends StatefulWidget {
  const _ProductsScaffold();

  @override
  State<_ProductsScaffold> createState() => _ProductsScaffoldState();
}

class _ProductsScaffoldState extends State<_ProductsScaffold> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().loadProducts();
    });
    _scrollController.addListener(() {
      context.read<HomeCubit>().onScroll(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(
            child: AnimatedThreadBackground(
              enableMouseInteraction: false,
              child: const SizedBox.expand(),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                _PageHeader(hPad: hPad, isDesktop: isDesktop),
                _SearchBar(
                  controller: _searchController,
                  hPad: hPad,
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      if (state.status == ProductsStatus.loading) {
                        return const _LoadingShimmer();
                      }
                      if (state.status == ProductsStatus.error) {
                        return _ErrorBanner(
                            message: state.errorMessage ?? 'products.error'.tr());
                      }

                      final products = state.filteredProducts.where((p) {
                        if (_search.isEmpty) return true;
                        final q = _search.toLowerCase();
                        return p.name.toLowerCase().contains(q) ||
                            p.nameAr.contains(q) ||
                            p.description.toLowerCase().contains(q);
                      }).toList();

                      if (isDesktop) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CategorySidebar(
                              categories: state.categories,
                              selected: state.selectedCategory,
                              onSelect: (c) =>
                                  context.read<ProductsCubit>().filterByCategory(c),
                            ),
                            const SizedBox(width: AppSpacing.xxl),
                            Expanded(
                              child: _ProductGrid(
                                products: products,
                                isDesktop: true,
                                isTablet: true,
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          _MobileCategoryChips(
                            categories: state.categories,
                            selected: state.selectedCategory,
                            onSelect: (c) =>
                                context.read<ProductsCubit>().filterByCategory(c),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          _ProductGrid(
                            products: products,
                            isDesktop: false,
                            isTablet: isTablet,
                          ),
                        ],
                      );
                    },
                  ),
                ),
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

// ─── Page Header ────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final double hPad;
  final bool isDesktop;

  const _PageHeader({required this.hPad, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 60),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceAlt,
            AppColors.background,
          ],
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.gold.withOpacity(0.25), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              GestureDetector(
                onTap: () => context.go('/'),
                child: Text(
                  'nav.home'.tr(),
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.accent.withOpacity(0.8)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('/',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textMuted)),
              ),
              Text(
                'nav.products'.tr(),
                style:
                    AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 500.ms),
          const SizedBox(height: AppSpacing.md),

          // Gold label
          Row(
            children: [
              Container(width: 30, height: 1, color: AppColors.accent),
              const SizedBox(width: 12),
              Text('products.label'.tr(), style: AppTextStyles.labelLarge),
              const SizedBox(width: 12),
              Container(width: 30, height: 1, color: AppColors.accent),
            ],
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(
            'products.title'.tr(),
            style: (isDesktop
                    ? AppTextStyles.displayMedium
                    : AppTextStyles.headlineLarge)
                .copyWith(fontWeight: FontWeight.w600),
          )
              .animate()
              .fadeIn(duration: 700.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0, duration: 700.ms, delay: 200.ms),
          const SizedBox(height: AppSpacing.sm),

          // Subtitle
          SizedBox(
            width: isDesktop ? 600 : double.infinity,
            child: Text(
              'products.subtitle'.tr(),
              style: AppTextStyles.bodyMedium,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms),
        ],
      ),
    );
  }
}

// ─── Search Bar ─────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final double hPad;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.hPad,
    required this.onChanged,
  });

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(widget.hPad, AppSpacing.xl, widget.hPad, 0),
      child: Focus(
        onFocusChange: (v) => setState(() => _focused = v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(
              color: _focused
                  ? AppColors.accent
                  : AppColors.accent.withOpacity(0.2),
              width: _focused ? 1.5 : 1,
            ),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.15),
                      blurRadius: 20,
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Icon(Icons.search, color: AppColors.accent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'products.search'.tr(),
                    hintStyle: AppTextStyles.bodyMedium,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                  ),
                  cursorColor: AppColors.accent,
                ),
              ),
              if (widget.controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.close,
                      color: AppColors.textMuted, size: 18),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 400.ms),
    );
  }
}

// ─── Category Sidebar (desktop) ─────────────────────────────────────────────

class _CategorySidebar extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _CategorySidebar({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return Container(
      width: 260,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.6),
        border: Border.all(color: AppColors.accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('products.filterTitle'.tr(), style: AppTextStyles.labelLarge),
          const SizedBox(height: 20),
          Container(height: 1, color: AppColors.accent.withOpacity(0.2)),
          const SizedBox(height: 16),
          ...categories.asMap().entries.map((e) {
            final cat = e.value;
            final isActive = cat.id == selected;
            final name = isAr ? cat.nameAr : cat.name;
            return _SidebarItem(
              name: name,
              count: cat.productCount,
              isActive: isActive,
              onTap: () => onSelect(cat.id),
              delay: Duration(milliseconds: 60 * e.key),
            );
          }),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final String name;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  final Duration delay;

  const _SidebarItem({
    required this.name,
    required this.count,
    required this.isActive,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.accent.withOpacity(0.08)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color:
                    active ? AppColors.accent : AppColors.accent.withOpacity(0.15),
                width: widget.isActive ? 3 : 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: active ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.accent.withOpacity(0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: active
                        ? AppColors.accent.withOpacity(0.5)
                        : AppColors.textMuted.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${widget.count}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: active ? AppColors.accent : AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: widget.delay)
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.15, end: 0, duration: 400.ms);
  }
}

// ─── Mobile Category Chips ──────────────────────────────────────────────────

class _MobileCategoryChips extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selected;
  final ValueChanged<String> onSelect;

  const _MobileCategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isActive = cat.id == selected;
          final name = isAr ? cat.nameAr : cat.name;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(cat.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.accent.withOpacity(0.12)
                      : Colors.transparent,
                  border: Border.all(
                    color: isActive
                        ? AppColors.accent
                        : AppColors.accent.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  name.toUpperCase(),
                  style: AppTextStyles.labelMedium.copyWith(
                    color:
                        isActive ? AppColors.accent : AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Product Grid ───────────────────────────────────────────────────────────

class _ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool isDesktop;
  final bool isTablet;

  const _ProductGrid({
    required this.products,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _EmptyState();
    }

    final cols = isDesktop ? 3 : isTablet ? 2 : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) => _ProductCard(
        product: products[i],
        delay: Duration(milliseconds: 60 * i),
      ),
    );
  }
}

// ─── Product Card ───────────────────────────────────────────────────────────

class _ProductCard extends StatefulWidget {
  final ProductModel product;
  final Duration delay;

  const _ProductCard({required this.product, required this.delay});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;

  Color _hexColor(String hex) {
    try {
      final c = hex.replaceAll('#', '');
      if (c.length == 6) return Color(int.parse('FF$c', radix: 16));
    } catch (_) {}
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.locale.languageCode == 'ar';
    final product = widget.product;
    final name = isAr ? product.nameAr : product.name;
    final description = isAr ? product.descriptionAr : product.description;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/product/${product.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withOpacity(0.6)
                  : AppColors.accent.withOpacity(0.12),
              width: 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.22),
                      blurRadius: 40,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.16),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──────────────────────────────────────────────
              Expanded(
                flex: 55,
                child: ClipRect(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AnimatedScale(
                        scale: _hovered ? 1.06 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                        child: Image.network(
                          _productImageUrl(product.category),
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: AppColors.primary,
                              child: const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.accent,
                                    strokeWidth: 1.5,
                                  ),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primary,
                            child: const Icon(Icons.texture,
                                color: AppColors.accent, size: 40),
                          ),
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
                                Colors.black.withOpacity(_hovered ? 0.5 : 0.35),
                              ],
                              stops: const [0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Badges
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          color: AppColors.secondary.withOpacity(0.85),
                          child: Text(
                            product.category.toUpperCase(),
                            style: AppTextStyles.labelMedium
                                .copyWith(fontSize: 9, letterSpacing: 1.5),
                          ),
                        ),
                      ),
                      if (product.featured)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            color: AppColors.accent,
                            child: Text(
                              'products.featured'.tr(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      // Hover arrow
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        bottom: _hovered ? 14 : 4,
                        right: 14,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: _hovered ? 1.0 : 0.0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: const Icon(Icons.arrow_forward,
                                color: AppColors.primary, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Info ───────────────────────────────────────────────
              Expanded(
                flex: 45,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        name,
                        style: AppTextStyles.headlineSmall
                            .copyWith(fontSize: 20, height: 1.2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Expanded(
                        child: Text(
                          description,
                          style: AppTextStyles.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Color swatches
                      if (product.colors.isNotEmpty &&
                          !product.colors.first.startsWith('Custom'))
                        Row(
                          children: [
                            ...product.colors.take(5).map((hex) {
                              if (!hex.startsWith('#')) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                width: 14,
                                height: 14,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: _hexColor(hex),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.textMuted.withOpacity(0.35),
                                    width: 1,
                                  ),
                                ),
                              );
                            }),
                            if (product.colors.length > 5) ...[
                              const SizedBox(width: 4),
                              Text(
                                '+${product.colors.length - 5}',
                                style: AppTextStyles.bodySmall
                                    .copyWith(fontSize: 10),
                              ),
                            ],
                          ],
                        ),

                      const SizedBox(height: 12),

                      // Divider
                      Divider(
                        color: AppColors.accent.withOpacity(0.15),
                        height: 1,
                      ),
                      const SizedBox(height: 12),

                      // View details row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'products.viewDetails'.tr(),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: _hovered
                                  ? AppColors.highlight
                                  : AppColors.accent,
                              fontSize: 10,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            transform: Matrix4.translationValues(
                                _hovered ? 4 : 0, 0, 0),
                            child: Icon(
                              Icons.arrow_forward,
                              color: _hovered
                                  ? AppColors.highlight
                                  : AppColors.accent,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: widget.delay)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms);
  }
}

// ─── States ─────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: AppColors.accent, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text('products.noResults'.tr(), style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(color: AppColors.cardColor)
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
            duration: 1200.ms,
            color: AppColors.accent.withOpacity(0.08),
          ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppColors.accent, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(message, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
