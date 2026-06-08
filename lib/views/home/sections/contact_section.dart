import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:lymar_sample_project/core/theme/app_colors.dart';
import 'package:lymar_sample_project/core/theme/app_text_styles.dart';
import 'package:lymar_sample_project/core/theme/app_spacing.dart';
import 'package:lymar_sample_project/core/widgets/luxury_button.dart';
import 'package:lymar_sample_project/core/widgets/section_header.dart';
import 'package:lymar_sample_project/cubits/contact/contact_cubit.dart';
import 'package:lymar_sample_project/cubits/contact/contact_state.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool _visible = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _moqController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _moqController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.1 && !_visible) {
      setState(() => _visible = true);
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<ContactCubit>();
      cubit.setName(_nameController.text);
      cubit.setCompany(_companyController.text);
      cubit.setCountry(_countryController.text);
      cubit.setEmail(_emailController.text);
      cubit.setPhone(_phoneController.text);
      cubit.setMoq(_moqController.text);
      cubit.setMessage(_messageController.text);
      cubit.submitRequest();
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
      key: const Key('contact-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            // Animated woven textile background
            Positioned.fill(
              child: CustomPaint(
                painter: _WovenPatternPainter(),
              ),
            ),
            // Dark overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withOpacity(0.92),
                      AppColors.primary.withOpacity(0.85),
                      AppColors.background.withOpacity(0.95),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.section,
                horizontal: hPad,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_visible)
                    SectionHeader(
                      label: 'contact.label'.tr(),
                      title: 'contact.title'.tr(),
                      subtitle: 'contact.subtitle'.tr(),
                    )
                        .animate()
                        .fadeIn(duration: 700.ms)
                        .slideY(begin: 0.3, end: 0, duration: 700.ms),

                  const SizedBox(height: AppSpacing.xxxl),

                  isDesktop
                      ? _buildDesktopLayout(context)
                      : _buildMobileLayout(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: contact info
        Expanded(
          flex: 4,
          child: _buildContactInfo(context),
        ),
        const SizedBox(width: AppSpacing.xxxl),
        // Right: form
        Expanded(
          flex: 6,
          child: _buildForm(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildContactInfo(context),
        const SizedBox(height: AppSpacing.xxxl),
        _buildForm(context),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company logo text
        Text(
          'YELMAR',
          style: AppTextStyles.logoText.copyWith(
            fontSize: 42,
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'contact.tagline'.tr(),
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.8,
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // WhatsApp CTA
        LuxuryButton(
          label: 'contact.whatsapp'.tr(),
          type: LuxuryButtonType.outline,
          icon: Icons.chat,
          onTap: () {},
        ),

        const SizedBox(height: AppSpacing.xxl),

        // Contact details
        _ContactInfoRow(
          icon: Icons.email_outlined,
          text: 'contact.email'.tr(),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ContactInfoRow(
          icon: Icons.phone_outlined,
          text: 'contact.phone'.tr(),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ContactInfoRow(
          icon: Icons.location_on_outlined,
          text: 'contact.address'.tr(),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 200.ms)
        .slideX(begin: -0.2, end: 0, duration: 700.ms, delay: 200.ms);
  }

  Widget _buildForm(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state.status == ContactStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'contact.successMessage'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF1A5E3E),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ContactStatus.success) {
          return _buildSuccessState();
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.4),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              _buildTabSelector(context, state),
              const SizedBox(height: AppSpacing.xl),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _LuxuryTextField(
                            controller: _nameController,
                            labelKey: 'contact.field.name',
                            required: true,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _LuxuryTextField(
                            controller: _companyController,
                            labelKey: 'contact.field.company',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _LuxuryTextField(
                            controller: _countryController,
                            labelKey: 'contact.field.country',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _LuxuryTextField(
                            controller: _emailController,
                            labelKey: 'contact.field.email',
                            required: true,
                            keyboardType: TextInputType.emailAddress,
                            emailValidation: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _LuxuryTextField(
                            controller: _phoneController,
                            labelKey: 'contact.field.phone',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _LuxuryTextField(
                            controller: _moqController,
                            labelKey: 'contact.field.moq',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _LuxuryTextField(
                      controller: _messageController,
                      labelKey: 'contact.field.message',
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Error message
                    if (state.errorMessage != null && state.status != ContactStatus.loading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Text(
                          state.errorMessage!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: state.status == ContactStatus.loading
                          ? Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : LuxuryButton(
                              label: 'contact.submit'.tr(),
                              type: LuxuryButtonType.primary,
                              onTap: () => _submit(context),
                              width: double.infinity,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    )
        .animate()
        .fadeIn(duration: 700.ms, delay: 400.ms)
        .slideX(begin: 0.2, end: 0, duration: 700.ms, delay: 400.ms);
  }

  Widget _buildTabSelector(BuildContext context, ContactState state) {
    return Row(
      children: [
        _TabButton(
          label: 'contact.tabQuote'.tr(),
          selected: state.selectedTab == 'quote',
          onTap: () => context.read<ContactCubit>().selectTab('quote'),
        ),
        const SizedBox(width: AppSpacing.md),
        _TabButton(
          label: 'contact.tabDesign'.tr(),
          selected: state.selectedTab == 'design',
          onTap: () => context.read<ContactCubit>().selectTab('design'),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.4),
        border: Border.all(
          color: const Color(0xFF2E9B6A).withOpacity(0.4),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: const Color(0xFF2E9B6A),
            size: 64,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'contact.successTitle'.tr(),
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'contact.successMessage'.tr(),
            style: AppTextStyles.bodyLarge.copyWith(height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          LuxuryButton(
            label: 'contact.sendAnother'.tr(),
            type: LuxuryButtonType.outline,
            onTap: () => context.read<ContactCubit>().reset(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 500.ms);
  }
}

// ─── Contact info row ────────────────────────────────────────────────────────

class _ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Tab button ───────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.labelMedium.copyWith(
              color: selected ? AppColors.primary : AppColors.accent,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Luxury text field ────────────────────────────────────────────────────────

class _LuxuryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelKey;
  final bool required;
  final bool emailValidation;
  final int maxLines;
  final TextInputType? keyboardType;

  const _LuxuryTextField({
    required this.controller,
    required this.labelKey,
    this.required = false,
    this.emailValidation = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      cursorColor: AppColors.accent,
      decoration: InputDecoration(
        labelText: labelKey.tr(),
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
        filled: true,
        fillColor: const Color(0xFF071B3B),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return 'contact.validation.required'.tr();
        }
        if (emailValidation && value != null && !value.contains('@')) {
          return 'contact.validation.email'.tr();
        }
        return null;
      },
    );
  }
}

// ─── Woven pattern background painter ────────────────────────────────────────

class _WovenPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 24.0;

    // Horizontal threads
    for (double y = 0; y < size.height; y += spacing) {
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += spacing * 2) {
        path.cubicTo(
          x + spacing * 0.5, y - 4,
          x + spacing, y + 4,
          x + spacing * 2, y,
        );
      }
      canvas.drawPath(path, paint);
    }

    // Vertical threads
    final vPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += spacing) {
      final path = Path();
      path.moveTo(x, 0);
      for (double y = 0; y < size.height; y += spacing * 2) {
        path.cubicTo(
          x + 4, y + spacing * 0.5,
          x - 4, y + spacing,
          x, y + spacing * 2,
        );
      }
      canvas.drawPath(path, vPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
