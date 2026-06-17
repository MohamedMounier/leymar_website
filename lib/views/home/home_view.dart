import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/cubits/home/home_cubit.dart';
import 'package:lymar_sample_project/cubits/products/products_cubit.dart';
import 'package:lymar_sample_project/cubits/contact/contact_cubit.dart';
import 'package:lymar_sample_project/repositories/products_repository.dart';
import 'package:lymar_sample_project/views/shared/navigation/app_navbar.dart';
import 'package:lymar_sample_project/views/shared/navigation/mobile_drawer.dart';
import 'package:lymar_sample_project/views/home/sections/hero_section.dart';
import 'package:lymar_sample_project/views/home/sections/products_preview_section.dart';
import 'package:lymar_sample_project/views/home/sections/manufacturing_section.dart';
import 'package:lymar_sample_project/views/home/sections/factory_stats_section.dart';
import 'package:lymar_sample_project/views/home/sections/industries_section.dart';
import 'package:lymar_sample_project/views/home/sections/sustainability_section.dart';
import 'package:lymar_sample_project/views/home/sections/quality_section.dart';
import 'package:lymar_sample_project/views/home/sections/global_reach_section.dart';
import 'package:lymar_sample_project/views/home/sections/client_showcase_section.dart';
import 'package:lymar_sample_project/views/home/sections/resources_section.dart';
import 'package:lymar_sample_project/views/home/sections/contact_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
        ),
        BlocProvider<ProductsCubit>(
          create: (_) => ProductsCubit(repository: ProductsRepository())
            ..loadProducts(),
        ),
        BlocProvider<ContactCubit>(
          create: (_) => ContactCubit(),
        ),
      ],
      child: const _HomeViewContent(),
    );
  }
}

class _HomeViewContent extends StatefulWidget {
  const _HomeViewContent();

  @override
  State<_HomeViewContent> createState() => _HomeViewContentState();
}

class _HomeViewContentState extends State<_HomeViewContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    context.read<HomeCubit>().onScroll(_scrollController.offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const MobileDrawer(),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const HeroSection(),
                const ProductsPreviewSection(),
                const ManufacturingSection(),
                const FactoryStatsSection(),
                const IndustriesSection(),
                const SustainabilitySection(),
                const QualitySection(),
                const GlobalReachSection(),
                const ClientShowcaseSection(),
                const ResourcesSection(),
                const ContactSection(),
                const _FooterWidget(),
              ],
            ),
          ),

          // Fixed navbar on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const AppNavbar(),
          ),
        ],
      ),
    );
  }
}

// ─── Footer Widget ────────────────────────────────────────────────────────────

class _FooterWidget extends StatelessWidget {
  const _FooterWidget();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        border: Border(
          top: BorderSide(
            color: AppColors.gold.withOpacity(0.35),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: 48,
        ),
        child: isDesktop
            ? _buildDesktopFooter(context)
            : _buildMobileFooter(context),
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand column
        Expanded(
          flex: 3,
          child: _buildBrandColumn(),
        ),
        const SizedBox(width: 64),
        // Links columns
        Expanded(
          flex: 2,
          child: _buildLinksColumn(
            'footer.company'.tr(),
            ['footer.about'.tr(), 'footer.factory'.tr(), 'footer.sustainability'.tr(), 'footer.careers'.tr()],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildLinksColumn(
            'footer.products'.tr(),
            ['footer.elastic'.tr(), 'footer.ribbon'.tr(), 'footer.jacquard'.tr(), 'footer.custom'.tr()],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildLinksColumn(
            'footer.support'.tr(),
            ['footer.contact'.tr(), 'footer.samples'.tr(), 'footer.resources'.tr(), 'footer.faq'.tr()],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildBrandColumn(),
        const SizedBox(height: 40),
        const Divider(color: Color(0xFF1A3060), height: 1),
        const SizedBox(height: 24),
        Text(
          'footer.copyright'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(0xFFC7BFB0),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBrandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('YELMAR', style: AppTextStyles.logoText),
        const SizedBox(height: 12),
        Text(
          'footer.tagline'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(0xFFC7BFB0),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        // Gold separator
        Container(
          width: 40,
          height: 1,
          color: AppColors.accent.withOpacity(0.4),
        ),
        const SizedBox(height: 16),
        Text(
          'footer.copyright'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: const Color(0xFFC7BFB0),
          ),
        ),
      ],
    );
  }

  Widget _buildLinksColumn(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  item,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFFC7BFB0),
                    height: 1.5,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
