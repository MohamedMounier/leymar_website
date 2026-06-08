import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/animated_thread_background.dart';
import '../../core/widgets/luxury_button.dart';
import '../../cubits/products/products_cubit.dart';
import '../../cubits/products/products_state.dart';
import '../../cubits/home/home_cubit.dart';
import '../../cubits/cart/cart_cubit.dart';
import '../../cubits/cart/cart_state.dart';
import '../../models/product_model.dart';
import '../../repositories/products_repository.dart';
import '../shared/navigation/app_navbar.dart';

// ─── Gallery images per category ────────────────────────────────────────────

const _kBase = <String, String>{
  'elastic':     'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
  'jacquard':    'https://images.unsplash.com/photo-1614683489572-246acd13da13',
  'waistband':   'https://images.unsplash.com/photo-1562887243-97e4f2c91c5e',
  'drawcords':   'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3',
  'webbing':     'https://images.unsplash.com/photo-1504898770365-14faca6a7320',
  'tapes':       'https://images.unsplash.com/photo-1587302168395-ef37ccf53d43',
  'accessories': 'https://images.unsplash.com/photo-1585771724684-38269d6639fd',
  'custom':      'https://images.unsplash.com/photo-1565008782736-2b1e5fcb5c15',
};

List<String> _gallery(String category) {
  final b = _kBase[category] ?? _kBase['elastic']!;
  return [
    '$b?w=900&h=680&fit=crop&auto=format',
    '$b?w=400&h=300&fit=crop&crop=top&auto=format',
    '$b?w=400&h=300&fit=crop&crop=center&auto=format',
    '$b?w=400&h=300&fit=crop&crop=bottom&auto=format',
  ];
}

// ─── Public entry point ─────────────────────────────────────────────────────

class ProductDetailView extends StatelessWidget {
  final String productId;
  const ProductDetailView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ProductsCubit(repository: ProductsRepository())),
      ],
      child: _ProductDetailScaffold(productId: productId),
    );
  }
}

// ─── Scaffold ───────────────────────────────────────────────────────────────

class _ProductDetailScaffold extends StatefulWidget {
  final String productId;
  const _ProductDetailScaffold({required this.productId});

  @override
  State<_ProductDetailScaffold> createState() => _ProductDetailScaffoldState();
}

class _ProductDetailScaffoldState extends State<_ProductDetailScaffold> {
  final _scrollController = ScrollController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state.status == ProductsStatus.loading) {
                return const _DetailLoading();
              }
              if (state.status == ProductsStatus.error ||
                  state.status == ProductsStatus.initial) {
                return const _DetailLoading();
              }

              final id = int.tryParse(widget.productId);
              final product = state.products.cast<ProductModel?>().firstWhere(
                    (p) => p?.id == id,
                    orElse: () => null,
                  );

              if (product == null) {
                return _NotFound(onBack: () => context.go('/products'));
              }

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 72),
                    _DetailContent(
                      product: product,
                      allProducts: state.products,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              );
            },
          ),
          const Positioned(top: 0, left: 0, right: 0, child: AppNavbar()),
        ],
      ),
    );
  }
}

// ─── Main detail content ────────────────────────────────────────────────────

class _DetailContent extends StatefulWidget {
  final ProductModel product;
  final List<ProductModel> allProducts;

  const _DetailContent({required this.product, required this.allProducts});

  @override
  State<_DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<_DetailContent>
    with SingleTickerProviderStateMixin {
  int _galleryIndex = 0;
  int _colorIndex = 0;
  int _widthIndex = 0;
  bool _addedToCart = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _hexColor(String hex) {
    try {
      final c = hex.replaceAll('#', '');
      if (c.length == 6) return Color(int.parse('FF$c', radix: 16));
    } catch (_) {}
    return AppColors.accent;
  }

  bool _isHexColor(String s) => s.startsWith('#');

  void _addToCart() {
    final product = widget.product;
    final selectedColor = product.colors.isNotEmpty
        ? product.colors[_colorIndex.clamp(0, product.colors.length - 1)]
        : 'default';
    final selectedWidth = product.widths.isNotEmpty
        ? product.widths[_widthIndex.clamp(0, product.widths.length - 1)]
        : 'default';

    context.read<CartCubit>().addItem(CartItem(
          productId: product.id,
          productName: product.name,
          productNameAr: product.nameAr,
          category: product.category,
          selectedColor: selectedColor,
          selectedWidth: selectedWidth,
        ));

    setState(() => _addedToCart = true);
    Future.delayed(const Duration(seconds: 2),
        () => mounted ? setState(() => _addedToCart = false) : null);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;
    final isAr = context.locale.languageCode == 'ar';
    final product = widget.product;

    final related = widget.allProducts
        .where((p) => p.category == product.category && p.id != product.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Breadcrumb ────────────────────────────────────────────
        Padding(
          padding:
              EdgeInsets.fromLTRB(hPad, AppSpacing.lg, hPad, AppSpacing.md),
          child: Row(
            children: [
              _BreadcrumbItem(
                  label: 'nav.home'.tr(), onTap: () => context.go('/')),
              const _BreadcrumbSep(),
              _BreadcrumbItem(
                  label: 'nav.products'.tr(),
                  onTap: () => context.go('/products')),
              const _BreadcrumbSep(),
              Text(
                isAr ? product.nameAr : product.name,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // ── Main 2-col ────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 55,
                      child: _GalleryPanel(
                        product: product,
                        activeIndex: _galleryIndex,
                        onThumbTap: (i) =>
                            setState(() => _galleryIndex = i),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxl),
                    Expanded(
                      flex: 45,
                      child: _InfoPanel(
                        product: product,
                        colorIndex: _colorIndex,
                        widthIndex: _widthIndex,
                        addedToCart: _addedToCart,
                        isAr: isAr,
                        hexColor: _hexColor,
                        isHexColor: _isHexColor,
                        onColorTap: (i) => setState(() => _colorIndex = i),
                        onWidthTap: (i) => setState(() => _widthIndex = i),
                        onAddToCart: _addToCart,
                        onRequestQuote: () => context.go('/contact'),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _GalleryPanel(
                      product: product,
                      activeIndex: _galleryIndex,
                      onThumbTap: (i) => setState(() => _galleryIndex = i),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _InfoPanel(
                      product: product,
                      colorIndex: _colorIndex,
                      widthIndex: _widthIndex,
                      addedToCart: _addedToCart,
                      isAr: isAr,
                      hexColor: _hexColor,
                      isHexColor: _isHexColor,
                      onColorTap: (i) => setState(() => _colorIndex = i),
                      onWidthTap: (i) => setState(() => _widthIndex = i),
                      onAddToCart: _addToCart,
                      onRequestQuote: () => context.go('/contact'),
                    ),
                  ],
                ),
        ),

        const SizedBox(height: AppSpacing.xxxl),

        // ── Specs / Applications tabs ─────────────────────────────
        _SpecsSection(
          product: product,
          isAr: isAr,
          tabController: _tabController,
          hPad: hPad,
        ),

        // ── Related products ──────────────────────────────────────
        if (related.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxxl),
          _RelatedProducts(
            products: related,
            hPad: hPad,
            isAr: isAr,
          ),
        ],
      ],
    );
  }
}

// ─── Breadcrumb helpers ─────────────────────────────────────────────────────

class _BreadcrumbItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _BreadcrumbItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          label,
          style: AppTextStyles.bodySmall
              .copyWith(color: AppColors.accent.withOpacity(0.8)),
        ),
      ),
    );
  }
}

class _BreadcrumbSep extends StatelessWidget {
  const _BreadcrumbSep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text('/', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted)),
    );
  }
}

// ─── Gallery Panel ──────────────────────────────────────────────────────────

class _GalleryPanel extends StatelessWidget {
  final ProductModel product;
  final int activeIndex;
  final ValueChanged<int> onThumbTap;

  const _GalleryPanel({
    required this.product,
    required this.activeIndex,
    required this.onThumbTap,
  });

  @override
  Widget build(BuildContext context) {
    final images = _gallery(product.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ClipRect(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Stack(
                key: ValueKey(activeIndex),
                fit: StackFit.expand,
                children: [
                  Image.network(
                    images[activeIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, prog) {
                      if (prog == null) return child;
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 1.5,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary,
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: AppColors.accent, size: 56),
                    ),
                  ),
                  // Vignette
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          radius: 1.4,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.25),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Gold corner accents
                  Positioned(
                    top: 0, left: 0,
                    child: Container(
                      width: 30, height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.accent, width: 2),
                          left: BorderSide(color: AppColors.accent, width: 2),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 30, height: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.accent, width: 2),
                          right: BorderSide(color: AppColors.accent, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Thumbnails
        Row(
          children: images.asMap().entries.map((e) {
            final isActive = e.key == activeIndex;
            return GestureDetector(
              onTap: () => onThumbTap(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isActive
                        ? AppColors.accent
                        : AppColors.accent.withOpacity(0.15),
                    width: isActive ? 2 : 1,
                  ),
                ),
                child: ClipRect(
                  child: Image.network(
                    e.value,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideX(begin: -0.1, end: 0, duration: 600.ms);
  }
}

// ─── Info Panel ─────────────────────────────────────────────────────────────

class _InfoPanel extends StatelessWidget {
  final ProductModel product;
  final int colorIndex;
  final int widthIndex;
  final bool addedToCart;
  final bool isAr;
  final Color Function(String) hexColor;
  final bool Function(String) isHexColor;
  final ValueChanged<int> onColorTap;
  final ValueChanged<int> onWidthTap;
  final VoidCallback onAddToCart;
  final VoidCallback onRequestQuote;

  const _InfoPanel({
    required this.product,
    required this.colorIndex,
    required this.widthIndex,
    required this.addedToCart,
    required this.isAr,
    required this.hexColor,
    required this.isHexColor,
    required this.onColorTap,
    required this.onWidthTap,
    required this.onAddToCart,
    required this.onRequestQuote,
  });

  @override
  Widget build(BuildContext context) {
    final name = isAr ? product.nameAr : product.name;
    final description = isAr ? product.descriptionAr : product.description;
    final hexColors = product.colors.where(isHexColor).toList();
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent.withOpacity(0.5)),
          ),
          child: Text(
            product.category.toUpperCase(),
            style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms),
        const SizedBox(height: AppSpacing.md),

        // Product title
        Text(
          name,
          style: isDesktop
              ? AppTextStyles.displayMedium.copyWith(fontWeight: FontWeight.w500)
              : AppTextStyles.headlineLarge,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 150.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 150.ms),
        const SizedBox(height: AppSpacing.md),

        // Description
        Text(description, style: AppTextStyles.bodyMedium)
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms),

        const SizedBox(height: AppSpacing.lg),

        // Gold divider
        Row(
          children: [
            Expanded(
              child: Container(height: 1, color: AppColors.accent.withOpacity(0.3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Expanded(
              child: Container(height: 1, color: AppColors.accent.withOpacity(0.3)),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 250.ms),

        const SizedBox(height: AppSpacing.lg),

        // ── Color picker ──────────────────────────────────────────
        if (hexColors.isNotEmpty) ...[
          Row(
            children: [
              Text('products.selectColor'.tr(),
                  style: AppTextStyles.labelLarge),
              const SizedBox(width: 12),
              Text(
                hexColors[colorIndex.clamp(0, hexColors.length - 1)],
                style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textMuted, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: hexColors.asMap().entries.map((e) {
              final isActive = e.key == colorIndex;
              return GestureDetector(
                onTap: () => onColorTap(e.key),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: hexColor(e.value),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? AppColors.accent
                            : Colors.white.withOpacity(0.15),
                        width: isActive ? 2.5 : 1,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: hexColor(e.value).withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                  ),
                ),
              );
            }).toList(),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 300.ms),
          const SizedBox(height: AppSpacing.lg),
        ] else if (product.colors.isNotEmpty) ...[
          Row(
            children: [
              Text('products.selectColor'.tr(),
                  style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            product.colors.first,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],

        // ── Width selector ────────────────────────────────────────
        if (product.widths.isNotEmpty && product.widths.first != 'N/A') ...[
          Text('products.selectWidth'.tr(), style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.widths.asMap().entries.map((e) {
              final isActive = e.key == widthIndex;
              return GestureDetector(
                onTap: () => onWidthTap(e.key),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.accent.withOpacity(0.12)
                          : Colors.transparent,
                      border: Border.all(
                        color: isActive
                            ? AppColors.accent
                            : AppColors.accent.withOpacity(0.3),
                        width: isActive ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      e.value,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isActive
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 350.ms),
          const SizedBox(height: AppSpacing.lg),
        ],

        // ── Quality badges ────────────────────────────────────────
        Row(
          children: [
            _QualityBadge('OEKO-TEX'),
            const SizedBox(width: 8),
            _QualityBadge('ISO 9001'),
            const SizedBox(width: 8),
            _QualityBadge('GRS'),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 400.ms),

        const SizedBox(height: AppSpacing.xl),

        // ── Add to Cart ───────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 56,
          child: GestureDetector(
            onTap: addedToCart ? null : onAddToCart,
            child: MouseRegion(
              cursor: addedToCart
                  ? MouseCursor.defer
                  : SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  gradient: addedToCart
                      ? const LinearGradient(
                          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                        )
                      : AppColors.goldGradient,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        addedToCart
                            ? Icons.check_circle_outline
                            : Icons.add_shopping_cart_outlined,
                        color: addedToCart
                            ? Colors.white
                            : AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        addedToCart
                            ? 'products.addedToCart'.tr()
                            : 'products.addToCart'.tr(),
                        style: AppTextStyles.titleMedium.copyWith(
                          color: addedToCart
                              ? Colors.white
                              : AppColors.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 450.ms),

        const SizedBox(height: AppSpacing.md),

        // ── Request Quote ─────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: LuxuryButton(
            label: 'products.requestQuote'.tr(),
            type: LuxuryButtonType.outline,
            icon: Icons.send_outlined,
            onTap: onRequestQuote,
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 500.ms),

        const SizedBox(height: AppSpacing.xl),

        // ── MOQ hint ─────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accent.withOpacity(0.12)),
            color: AppColors.cardColor.withOpacity(0.4),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.accent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'products.moqHint'.tr(),
                  style:
                      AppTextStyles.bodySmall.copyWith(fontSize: 11, height: 1.5),
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 550.ms),
      ],
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final String label;
  const _QualityBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
        color: AppColors.accent.withOpacity(0.05),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ─── Specs Section ──────────────────────────────────────────────────────────

class _SpecsSection extends StatelessWidget {
  final ProductModel product;
  final bool isAr;
  final TabController tabController;
  final double hPad;

  const _SpecsSection({
    required this.product,
    required this.isAr,
    required this.tabController,
    required this.hPad,
  });

  @override
  Widget build(BuildContext context) {
    final specs = isAr && product.specificationsAr != null
        ? product.specificationsAr!
        : product.specifications;
    final apps = isAr && product.applicationsAr != null
        ? product.applicationsAr!
        : product.applications;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: hPad),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.5),
        border: Border.all(color: AppColors.accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar
          TabBar(
            controller: tabController,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.accent,
            indicatorWeight: 2,
            labelStyle: AppTextStyles.labelLarge.copyWith(fontSize: 12),
            unselectedLabelStyle:
                AppTextStyles.labelLarge.copyWith(fontSize: 12),
            tabs: [
              Tab(text: 'products.specifications'.tr()),
              Tab(text: 'products.applications'.tr()),
            ],
          ),

          // Tab views
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: tabController,
              children: [
                // Specifications
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: specs.entries.toList().asMap().entries.map((e) {
                      final isEven = e.key.isEven;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isEven
                              ? AppColors.primary.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                e.value.key,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                e.value.value,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate(delay: Duration(milliseconds: 60 * e.key))
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.1, end: 0, duration: 400.ms);
                    }).toList(),
                  ),
                ),

                // Applications
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: apps.asMap().entries.map((e) {
                      final icons = [
                        Icons.checkroom_outlined,
                        Icons.fitness_center_outlined,
                        Icons.medical_services_outlined,
                        Icons.military_tech_outlined,
                        Icons.chair_outlined,
                        Icons.directions_car_outlined,
                        Icons.factory_outlined,
                      ];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.accent.withOpacity(0.3)),
                          color: AppColors.accent.withOpacity(0.04),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icons[e.key % icons.length],
                              color: AppColors.accent,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              e.value,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate(delay: Duration(milliseconds: 80 * e.key))
                          .fadeIn(duration: 400.ms)
                          .scale(
                              begin: const Offset(0.9, 0.9),
                              duration: 400.ms);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms);
  }
}

// ─── Related Products ────────────────────────────────────────────────────────

class _RelatedProducts extends StatelessWidget {
  final List<ProductModel> products;
  final double hPad;
  final bool isAr;

  const _RelatedProducts({
    required this.products,
    required this.hPad,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final cols = isDesktop ? 4 : isTablet ? 2 : 1;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(width: 30, height: 1, color: AppColors.accent),
              const SizedBox(width: 12),
              Text('products.relatedProducts'.tr(),
                  style: AppTextStyles.labelLarge),
              const SizedBox(width: 12),
              Container(width: 30, height: 1, color: AppColors.accent),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.8,
            ),
            itemCount: products.take(cols).length,
            itemBuilder: (context, i) {
              final p = products[i];
              final name = isAr ? p.nameAr : p.name;
              final base = _kBase[p.category] ?? _kBase['elastic']!;
              final imgUrl = '$base?w=400&h=320&fit=crop&auto=format';

              return GestureDetector(
                onTap: () => context.go('/product/${p.id}'),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.accent.withOpacity(0.15)),
                      color: AppColors.cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            name,
                            style: AppTextStyles.headlineSmall
                                .copyWith(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .animate(delay: Duration(milliseconds: 80 * i))
                  .fadeIn(duration: 500.ms);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Loading / Not Found states ──────────────────────────────────────────────

class _DetailLoading extends StatelessWidget {
  const _DetailLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.accent,
        strokeWidth: 1.5,
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  final VoidCallback onBack;
  const _NotFound({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined,
              color: AppColors.accent, size: 64),
          const SizedBox(height: AppSpacing.lg),
          Text('products.productNotFound'.tr(),
              style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
          LuxuryButton(
            label: 'products.backToProducts'.tr(),
            type: LuxuryButtonType.outline,
            icon: Icons.arrow_back,
            onTap: onBack,
          ),
        ],
      ),
    );
  }
}
