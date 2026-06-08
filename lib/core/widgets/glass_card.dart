import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool enableHoverGlow;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.onTap,
    this.enableHoverGlow = true,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 0,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F1F3D), Color(0xFF071B3B)],
            ),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withOpacity(0.6)
                  : AppColors.accent.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: _hovered && widget.enableHoverGlow
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
