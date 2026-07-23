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
import 'package:lymar_sample_project/core/utils/whatsapp_launcher.dart';

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
    // _NavItem('nav.industries', '/industries'),
    // _NavItem('nav.factoryTour', '/factory-tour'),
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
                ? Colors.white.withOpacity(0.94)
                : AppColors.background.withOpacity(0.55),
            border: Border(
              bottom: BorderSide(
                color: state.isNavbarOpaque
                    ? AppColors.gold.withOpacity(0.25)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            boxShadow: state.isNavbarOpaque
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
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
                      LuxuryButton(
                        label: 'nav.whatsapp'.tr(),
                        type: LuxuryButtonType.outline,
                        icon: Icons.chat,
                        onTap: () => launchWhatsApp(),
                      ),
                    ] else ...[
                      _buildLanguageToggle(context),
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
          'Ylmar',
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
