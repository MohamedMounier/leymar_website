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
import '../../core/widgets/section_header.dart';
import '../../cubits/contact/contact_cubit.dart';
import '../../cubits/contact/contact_state.dart';
import '../../cubits/home/home_cubit.dart';
import '../shared/navigation/app_navbar.dart';

// ─── Entry point ─────────────────────────────────────────────────────────────

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ContactCubit()),
      ],
      child: const _ContactScaffold(),
    );
  }
}

class _ContactScaffold extends StatefulWidget {
  const _ContactScaffold();

  @override
  State<_ContactScaffold> createState() => _ContactScaffoldState();
}

class _ContactScaffoldState extends State<_ContactScaffold> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 72),
                const _HeroSection(),
                const _ContactCardsRow(),
                const _MainFormSection(),
                const _FAQSection(),
                const _MapSection(),
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

// ─── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return SizedBox(
      height: isDesktop ? 400 : 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'https://images.unsplash.com/photo-1576153192396-180ecef2a715?w=1920&h=800&fit=crop&auto=format',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.primary),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xF5FBF8F2), Color(0x55FBF8F2)],
              ),
            ),
          ),
          AnimatedThreadBackground(
            enableMouseInteraction: true,
            child: const SizedBox.expand(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Text('nav.home'.tr(),
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.accent.withOpacity(0.8))),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('/',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textMuted)),
                    ),
                    Text('nav.contact'.tr(),
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ).animate().fadeIn(duration: 500.ms),
                const SizedBox(height: AppSpacing.lg),

                Row(
                  children: [
                    Container(width: 30, height: 1, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Text('contact.label'.tr(), style: AppTextStyles.labelLarge),
                    const SizedBox(width: 12),
                    Container(width: 30, height: 1, color: AppColors.accent),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
                const SizedBox(height: AppSpacing.md),

                Text(
                  'contact.title'.tr(),
                  style: (isDesktop
                          ? AppTextStyles.displayMedium
                          : AppTextStyles.headlineLarge)
                      .copyWith(fontWeight: FontWeight.w600),
                )
                    .animate()
                    .fadeIn(duration: 700.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0, duration: 700.ms, delay: 200.ms),
                const SizedBox(height: AppSpacing.sm),

                SizedBox(
                  width: isDesktop ? 520 : double.infinity,
                  child: Text(
                    'contact.subtitle'.tr(),
                    style: AppTextStyles.bodyMedium,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 2,
              decoration: const BoxDecoration(gradient: AppColors.goldGradient),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contact Cards Row ────────────────────────────────────────────────────────

class _ContactCardsRow extends StatelessWidget {
  const _ContactCardsRow();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    final cards = [
      _ContactCardData(
        icon: Icons.phone_outlined,
        labelKey: 'contact.phoneLabel',
        value: 'contact.phone'.tr(),
        action: null,
      ),
      _ContactCardData(
        icon: Icons.email_outlined,
        labelKey: 'contact.emailLabel',
        value: 'contact.email'.tr(),
        action: null,
      ),
      _ContactCardData(
        icon: Icons.chat_bubble_outline,
        labelKey: 'contact.whatsappLabel',
        value: 'contact.whatsapp'.tr(),
        action: null,
      ),
      _ContactCardData(
        icon: Icons.location_on_outlined,
        labelKey: 'contact.addressLabel',
        value: 'contact.address'.tr(),
        action: null,
      ),
    ];

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 0),
      transform: Matrix4.translationValues(0, -40, 0),
      child: isTablet
          ? Row(
              children: cards.asMap().entries.map((e) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: e.key < cards.length - 1 ? AppSpacing.md : 0),
                    child: _ContactInfoCard(
                      data: e.value,
                      delay: Duration(milliseconds: 80 * e.key),
                    ),
                  ),
                );
              }).toList(),
            )
          : Column(
              children: cards.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ContactInfoCard(
                    data: e.value,
                    delay: Duration(milliseconds: 80 * e.key),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _ContactCardData {
  final IconData icon;
  final String labelKey;
  final String value;
  final VoidCallback? action;
  const _ContactCardData({
    required this.icon,
    required this.labelKey,
    required this.value,
    this.action,
  });
}

class _ContactInfoCard extends StatefulWidget {
  final _ContactCardData data;
  final Duration delay;

  const _ContactInfoCard({required this.data, required this.delay});

  @override
  State<_ContactInfoCard> createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<_ContactInfoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.data.action != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.data.action,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withOpacity(0.7)
                  : AppColors.accent.withOpacity(0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.gold.withOpacity(0.22)
                    : AppColors.primary.withOpacity(0.08),
                blurRadius: _hovered ? 30 : 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(_hovered ? 0.15 : 0.08),
                  border: Border.all(
                      color: AppColors.accent.withOpacity(_hovered ? 0.6 : 0.3)),
                ),
                child: Icon(widget.data.icon,
                    color: AppColors.accent, size: 20),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.data.labelKey.tr(),
                style: AppTextStyles.labelMedium.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 4),
              Text(
                widget.data.value,
                style: AppTextStyles.titleMedium,
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

// ─── Main Form Section ────────────────────────────────────────────────────────

class _MainFormSection extends StatelessWidget {
  const _MainFormSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.xl),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 55, child: _QuoteForm()),
                const SizedBox(width: AppSpacing.xxxl),
                Expanded(flex: 45, child: const _ContactInfoPanel()),
              ],
            )
          : const Column(
              children: [
                _QuoteForm(),
                SizedBox(height: AppSpacing.xl),
                _ContactInfoPanel(),
              ],
            ),
    );
  }
}

// ─── Quote Form ───────────────────────────────────────────────────────────────

class _QuoteForm extends StatefulWidget {
  const _QuoteForm();

  @override
  State<_QuoteForm> createState() => _QuoteFormState();
}

class _QuoteFormState extends State<_QuoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _moqCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _companyCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _countryCtrl.dispose();
    _moqCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = ctx.read<ContactCubit>();
      cubit.setName(_nameCtrl.text);
      cubit.setCompany(_companyCtrl.text);
      cubit.setEmail(_emailCtrl.text);
      cubit.setPhone(_phoneCtrl.text);
      cubit.setCountry(_countryCtrl.text);
      cubit.setMoq(_moqCtrl.text);
      cubit.setMessage(_messageCtrl.text);
      cubit.submitRequest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        if (state.status == ContactStatus.success) {
          return _SuccessState(
              onReset: () => context.read<ContactCubit>().reset());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 30, height: 1, color: AppColors.accent),
                const SizedBox(width: 12),
                Text('contact.form.label'.tr(), style: AppTextStyles.labelLarge),
                const SizedBox(width: 12),
                Container(width: 30, height: 1, color: AppColors.accent),
              ],
            ).animate().fadeIn(duration: 500.ms),
            const SizedBox(height: AppSpacing.md),
            Text('contact.title'.tr(),
                style: AppTextStyles.headlineLarge)
                .animate()
                .fadeIn(duration: 600.ms, delay: 100.ms),
            const SizedBox(height: AppSpacing.xl),

            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.6),
                border: Border.all(color: AppColors.accent.withOpacity(0.12)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name + Company
                    _FormRow(
                      children: [
                        _LuxuryField(
                          controller: _nameCtrl,
                          label: 'contact.name'.tr(),
                          icon: Icons.person_outline,
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'contact.validation.required'.tr()
                              : null,
                        ),
                        _LuxuryField(
                          controller: _companyCtrl,
                          label: 'contact.company'.tr(),
                          icon: Icons.business_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Email + Phone
                    _FormRow(
                      children: [
                        _LuxuryField(
                          controller: _emailCtrl,
                          label: 'contact.emailLabel'.tr(),
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'contact.validation.required'.tr();
                            }
                            if (!v.contains('@')) {
                              return 'contact.validation.email'.tr();
                            }
                            return null;
                          },
                        ),
                        _LuxuryField(
                          controller: _phoneCtrl,
                          label: 'contact.phoneLabel'.tr(),
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Country + MOQ
                    _FormRow(
                      children: [
                        _LuxuryField(
                          controller: _countryCtrl,
                          label: 'contact.country'.tr(),
                          icon: Icons.public_outlined,
                        ),
                        _LuxuryField(
                          controller: _moqCtrl,
                          label: 'contact.moq'.tr(),
                          icon: Icons.inventory_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Message
                    _LuxuryField(
                      controller: _messageCtrl,
                      label: 'contact.message'.tr(),
                      icon: Icons.notes_outlined,
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Required note
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'contact.required'.tr(),
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: state.status == ContactStatus.loading
                          ? Container(
                              color: AppColors.accent.withOpacity(0.3),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => _submit(context),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.send_outlined,
                                          color: AppColors.primary, size: 18),
                                      const SizedBox(width: 10),
                                      Text(
                                        'contact.submit'.tr(),
                                        style: AppTextStyles.titleMedium.copyWith(
                                          color: AppColors.primary,
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
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          ],
        );
      },
    );
  }
}

class _FormRow extends StatelessWidget {
  final List<Widget> children;
  const _FormRow({required this.children});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 768) {
      return Column(
        children: children.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: c,
        )).toList(),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: e.key < children.length - 1 ? AppSpacing.md : 0,
            ),
            child: e.value,
          ),
        );
      }).toList(),
    );
  }
}

class _LuxuryField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _LuxuryField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<_LuxuryField> createState() => _LuxuryFieldState();
}

class _LuxuryFieldState extends State<_LuxuryField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          border: Border.all(
            color: _focused
                ? AppColors.accent
                : AppColors.accent.withOpacity(0.25),
            width: _focused ? 1.5 : 1,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.12),
                    blurRadius: 16,
                  )
                ]
              : [],
        ),
        child: TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: _focused ? AppColors.accent : AppColors.textMuted,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: _focused ? AppColors.accent : AppColors.textMuted,
              size: 18,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            errorStyle: AppTextStyles.bodySmall
                .copyWith(color: Colors.redAccent, fontSize: 11),
          ),
          cursorColor: AppColors.accent,
        ),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onReset;
  const _SuccessState({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 2),
            ),
            child: const Icon(Icons.check, color: AppColors.accent, size: 36),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('contact.successTitle'.tr(),
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          Text('contact.successMessage'.tr(),
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xl),
          LuxuryButton(
            label: 'contact.sendAnother'.tr(),
            type: LuxuryButtonType.outline,
            icon: Icons.refresh,
            onTap: onReset,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 600.ms);
  }
}

// ─── Contact Info Panel ───────────────────────────────────────────────────────

class _ContactInfoPanel extends StatelessWidget {
  const _ContactInfoPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company tagline
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surfaceAlt, AppColors.cardColor],
            ),
            border: Border.all(color: AppColors.gold.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('YELMAR', style: AppTextStyles.logoText),
              const SizedBox(height: AppSpacing.sm),
              Text('contact.tagline'.tr(), style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              Divider(color: AppColors.accent.withOpacity(0.2)),
              const SizedBox(height: AppSpacing.lg),
              _InfoRow(
                  icon: Icons.phone_outlined, value: 'contact.phone'.tr()),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                  icon: Icons.email_outlined, value: 'contact.email'.tr()),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                  icon: Icons.location_on_outlined,
                  value: 'contact.address'.tr()),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 300.ms),

        const SizedBox(height: AppSpacing.xl),

        // Working hours
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            border: Border.all(color: AppColors.accent.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('contact.hours.label'.tr(), style: AppTextStyles.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Text('contact.hours.title'.tr(),
                  style: AppTextStyles.headlineSmall.copyWith(fontSize: 20)),
              const SizedBox(height: AppSpacing.lg),
              _HourRow(label: 'contact.hours.weekdays'.tr()),
              const SizedBox(height: 8),
              _HourRow(label: 'contact.hours.weekends'.tr()),
              const SizedBox(height: 8),
              _HourRow(
                  label: 'contact.hours.closed'.tr(), closed: true),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 400.ms),

        const SizedBox(height: AppSpacing.xl),

        // WhatsApp CTA
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFF128C7E).withOpacity(0.1),
              border: Border.all(
                  color: const Color(0xFF25D366).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.chat, color: Color(0xFF25D366), size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('contact.whatsapp'.tr(),
                          style: AppTextStyles.titleMedium),
                      Text('contact.phone'.tr(),
                          style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF25D366))),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward,
                    color: Color(0xFF25D366), size: 18),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 500.ms),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;
  const _InfoRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}

class _HourRow extends StatelessWidget {
  final String label;
  final bool closed;
  const _HourRow({required this.label, this.closed = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: closed ? AppColors.textMuted : AppColors.accent,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: closed ? AppColors.textMuted : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── FAQ Section ──────────────────────────────────────────────────────────────

class _FAQSection extends StatefulWidget {
  const _FAQSection();

  @override
  State<_FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<_FAQSection> {
  int? _expanded;

  static const _faqs = [
    (qKey: 'contact.faq.q1', aKey: 'contact.faq.a1'),
    (qKey: 'contact.faq.q2', aKey: 'contact.faq.a2'),
    (qKey: 'contact.faq.q3', aKey: 'contact.faq.a3'),
    (qKey: 'contact.faq.q4', aKey: 'contact.faq.a4'),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return Container(
      color: AppColors.surfaceAlt,
      padding: EdgeInsets.symmetric(
          vertical: AppSpacing.section, horizontal: hPad),
      child: Column(
        children: [
          SectionHeader(
            label: 'contact.faq.label'.tr(),
            title: 'contact.faq.title'.tr(),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: AppSpacing.xxxl),
          SizedBox(
            width: isDesktop ? 800 : double.infinity,
            child: Column(
              children: _faqs.asMap().entries.map((e) {
                final faq = e.value;
                final isOpen = _expanded == e.key;

                return GestureDetector(
                  onTap: () => setState(
                      () => _expanded = isOpen ? null : e.key),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? AppColors.cardColor
                          : AppColors.cardColor.withOpacity(0.5),
                      border: Border.all(
                        color: isOpen
                            ? AppColors.accent.withOpacity(0.5)
                            : AppColors.accent.withOpacity(0.12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question row
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  faq.qKey.tr(),
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: isOpen
                                        ? AppColors.accent
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedRotation(
                                turns: isOpen ? 0.5 : 0,
                                duration: const Duration(milliseconds: 280),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.accent,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Answer
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                    color: AppColors.accent.withOpacity(0.2)),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  faq.aKey.tr(),
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: isOpen
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 280),
                          sizeCurve: Curves.easeInOut,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate(delay: Duration(milliseconds: 80 * e.key))
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0, duration: 500.ms);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Map Section ─────────────────────────────────────────────────────────────

class _MapSection extends StatelessWidget {
  const _MapSection();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDesktop = w >= 1200;
    final isTablet = w >= 768;
    final hPad = isDesktop ? 80.0 : isTablet ? 40.0 : 20.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: AppSpacing.xxl),
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent.withOpacity(0.2)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1920&h=600&fit=crop&auto=format',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.primary),
            ),
            Container(
              color: AppColors.background.withOpacity(0.72),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on,
                      color: AppColors.accent, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Istanbul, Turkey',
                    style: AppTextStyles.headlineMedium,
                  ),
                  Text(
                    '41.0082° N, 28.9784° E',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.accent, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}
