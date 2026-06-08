import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/widgets/luxury_button.dart';
import 'package:lymar_sample_project/cubits/home/home_cubit.dart';
import 'package:lymar_sample_project/cubits/home/home_state.dart';
import 'package:lymar_sample_project/cubits/localization/localization_cubit.dart';
import 'package:lymar_sample_project/cubits/cart/cart_cubit.dart';
import 'package:lymar_sample_project/cubits/cart/cart_state.dart';

class AppNavbar extends StatefulWidget {
  const AppNavbar({super.key});

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  String? _hoveredItem;

  static const List<_NavItem> _navItems = [
    _NavItem('nav.home', '/'),
    _NavItem('nav.products', '/products'),
    _NavItem('nav.about', '/about'),
    _NavItem('nav.industries', '/industries'),
    _NavItem('nav.factoryTour', '/factory-tour'),
    _NavItem('nav.contact', '/contact'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1200;

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: state.isNavbarOpaque
                ? AppColors.primary.withOpacity(0.95)
                : AppColors.background.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(
                color: state.isNavbarOpaque
                    ? AppColors.accent.withOpacity(0.2)
                    : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 80 : 20,
                ),
                child: Row(
                  children: [
                    // Logo
                    _buildLogo(context),

                    const Spacer(),

                    // Desktop navigation
                    if (isDesktop) ...[
                      ..._navItems.map((item) => _buildNavItem(context, item)),
                      const SizedBox(width: 32),
                      _buildLanguageToggle(context),
                      const SizedBox(width: 16),
                      _buildCartIcon(context),
                      const SizedBox(width: 16),
                      LuxuryButton(
                        label: 'nav.requestQuote'.tr(),
                        type: LuxuryButtonType.outline,
                        onTap: () => context.go('/contact'),
                      ),
                    ] else ...[
                      _buildLanguageToggle(context),
                      const SizedBox(width: 8),
                      _buildCartIcon(context),
                      const SizedBox(width: 8),
                      _buildHamburger(context),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          'YELMAR',
          style: AppTextStyles.logoText,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = item.label),
      onExit: (_) => setState(() => _hoveredItem = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(item.path),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.navItem.copyWith(
              color: _hoveredItem == item.label
                  ? AppColors.accent
                  : AppColors.textPrimary,
            ),
            child: Text(item.label.tr()),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
    return BlocBuilder<LocalizationCubit, dynamic>(
      builder: (context, _) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              final cubit = context.read<LocalizationCubit>();
              cubit.toggleLocale();
              final newLocale = cubit.state.locale;
              context.setLocale(newLocale);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Text(
                'nav.language'.tr(),
                style: AppTextStyles.labelMedium,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go('/cart'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined,
                    color: AppColors.textPrimary, size: 22),
                if (!state.isEmpty)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${state.totalItems}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHamburger(BuildContext context) {
    return IconButton(
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
    );
  }
}

class _NavItem {
  final String label;
  final String path;
  const _NavItem(this.label, this.path);
}
