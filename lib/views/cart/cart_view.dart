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
import '../../cubits/cart/cart_cubit.dart';
import '../../cubits/cart/cart_state.dart';
import '../../cubits/home/home_cubit.dart';
import '../shared/navigation/app_navbar.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _CartScaffold(),
    );
  }
}

class _CartScaffold extends StatelessWidget {
  const _CartScaffold();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                // Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(hPad, 48, hPad, 48),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: AppColors.gold.withOpacity(0.25), width: 1),
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.surfaceAlt,
                        AppColors.background,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 30, height: 1, color: AppColors.accent),
                          const SizedBox(width: 12),
                          Text('cart.label'.tr(),
                              style: AppTextStyles.labelLarge),
                          const SizedBox(width: 12),
                          Container(width: 30, height: 1, color: AppColors.accent),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('cart.title'.tr(),
                          style: AppTextStyles.headlineLarge),
                    ],
                  ),
                ),

                // Cart content
                Padding(
                  padding: EdgeInsets.all(hPad),
                  child: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                      if (state.isEmpty) {
                        return _EmptyCart(hPad: hPad);
                      }

                      return isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 65,
                                  child: _CartItemList(
                                      items: state.items, isAr: context.locale.languageCode == 'ar'),
                                ),
                                const SizedBox(width: AppSpacing.xxl),
                                SizedBox(
                                  width: 320,
                                  child: _CartSummary(state: state),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _CartItemList(
                                    items: state.items, isAr: context.locale.languageCode == 'ar'),
                                const SizedBox(height: AppSpacing.xl),
                                _CartSummary(state: state),
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

// ─── Cart Item List ──────────────────────────────────────────────────────────

class _CartItemList extends StatelessWidget {
  final List<CartItem> items;
  final bool isAr;

  const _CartItemList({required this.items, required this.isAr});

  Color _hexColor(String hex) {
    try {
      final c = hex.replaceAll('#', '');
      if (c.length == 6) return Color(int.parse('FF$c', radix: 16));
    } catch (_) {}
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.asMap().entries.map((e) {
        final idx = e.key;
        final item = e.value;
        final name = isAr ? item.productNameAr : item.productName;
        final isHex = item.selectedColor.startsWith('#');

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(color: AppColors.accent.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              // Color swatch or icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isHex
                      ? _hexColor(item.selectedColor)
                      : AppColors.secondary,
                  border: Border.all(
                      color: AppColors.accent.withOpacity(0.3)),
                ),
                child: isHex
                    ? null
                    : const Icon(Icons.texture,
                        color: AppColors.accent, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${item.selectedColor} · ${item.selectedWidth}',
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quantity controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () => context
                        .read<CartCubit>()
                        .updateQuantity(idx, item.quantity - 1),
                  ),
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: AppTextStyles.titleMedium,
                      ),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => context
                        .read<CartCubit>()
                        .updateQuantity(idx, item.quantity + 1),
                  ),
                ],
              ),

              const SizedBox(width: AppSpacing.md),

              // Remove
              IconButton(
                onPressed: () => context.read<CartCubit>().removeAt(idx),
                icon: const Icon(Icons.close,
                    color: AppColors.textMuted, size: 18),
              ),
            ],
          ),
        )
            .animate(delay: Duration(milliseconds: 60 * idx))
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, end: 0, duration: 400.ms);
      }).toList(),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        ),
        child: Icon(icon, color: AppColors.accent, size: 16),
      ),
    );
  }
}

// ─── Cart Summary ────────────────────────────────────────────────────────────

class _CartSummary extends StatelessWidget {
  final CartState state;

  const _CartSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('cart.summary'.tr(), style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.accent.withOpacity(0.2)),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('cart.totalItems'.tr(),
                  style: AppTextStyles.bodyMedium),
              Text(
                '${state.totalItems}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('cart.products'.tr(),
                  style: AppTextStyles.bodyMedium),
              Text(
                '${state.items.length}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accent.withOpacity(0.15)),
            ),
            child: Text(
              'cart.quoteNote'.tr(),
              style: AppTextStyles.bodySmall.copyWith(height: 1.6),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: LuxuryButton(
              label: 'cart.submitInquiry'.tr(),
              type: LuxuryButtonType.primary,
              icon: Icons.send_outlined,
              onTap: () => context.go('/contact'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: LuxuryButton(
              label: 'cart.clearAll'.tr(),
              type: LuxuryButtonType.outline,
              onTap: () => context.read<CartCubit>().clear(),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideX(begin: 0.1, end: 0, duration: 500.ms, delay: 200.ms);
  }
}

// ─── Empty Cart ──────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  final double hPad;
  const _EmptyCart({required this.hPad});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined,
                color: AppColors.accent, size: 72),
            const SizedBox(height: AppSpacing.lg),
            Text('cart.empty'.tr(), style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            Text(
              'cart.emptySubtitle'.tr(),
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            LuxuryButton(
              label: 'nav.products'.tr(),
              type: LuxuryButtonType.outline,
              icon: Icons.arrow_forward,
              onTap: () => context.go('/products'),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 600.ms);
  }
}
