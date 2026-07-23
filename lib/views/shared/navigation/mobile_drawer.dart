import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/cubits/localization/localization_cubit.dart';
import 'package:lymar_sample_project/core/utils/whatsapp_launcher.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  static const List<_DrawerItem> _items = [
    _DrawerItem(Icons.home_outlined, 'nav.home', '/'),
    _DrawerItem(Icons.category_outlined, 'nav.products', '/products'),
    _DrawerItem(Icons.info_outline, 'nav.about', '/about'),
    // _DrawerItem(Icons.factory_outlined, 'nav.industries', '/industries'),
    // _DrawerItem(Icons.tour_outlined, 'nav.factoryTour', '/factory-tour'),
    _DrawerItem(Icons.contact_mail_outlined, 'nav.contact', '/contact'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ylmar', style: AppTextStyles.logoText),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.accent.withOpacity(0.2), height: 1),
            const SizedBox(height: AppSpacing.md),

            // Nav items
            ..._items.map((item) => _DrawerNavItem(item: item)),

            const Spacer(),

            // WhatsApp CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  launchWhatsApp();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.accent.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chat, color: AppColors.accent, size: 16),
                      const SizedBox(width: 8),
                      Text('nav.whatsapp'.tr(),
                          style: AppTextStyles.labelMedium),
                    ],
                  ),
                ),
              ),
            ),

            // Language toggle
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: BlocBuilder<LocalizationCubit, dynamic>(
                builder: (context, _) {
                  return GestureDetector(
                    onTap: () {
                      final cubit = context.read<LocalizationCubit>();
                      cubit.toggleLocale();
                      context.setLocale(cubit.state.locale);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.accent.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language,
                              color: AppColors.accent, size: 16),
                          const SizedBox(width: 8),
                          Text('nav.language'.tr(),
                              style: AppTextStyles.labelMedium),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  final _DrawerItem item;
  const _DrawerNavItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        context.go(item.path);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(item.icon, color: AppColors.accent, size: 20),
            const SizedBox(width: AppSpacing.md),
            Text(item.label.tr(), style: AppTextStyles.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String label;
  final String path;
  const _DrawerItem(this.icon, this.label, this.path);
}
