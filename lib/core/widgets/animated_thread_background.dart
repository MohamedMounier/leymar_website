import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../animations/thread_painter.dart';

class AnimatedThreadBackground extends StatefulWidget {
  final Widget child;
  final bool enableMouseInteraction;

  const AnimatedThreadBackground({
    super.key,
    required this.child,
    this.enableMouseInteraction = true,
  });

  @override
  State<AnimatedThreadBackground> createState() =>
      _AnimatedThreadBackgroundState();
}

class _AnimatedThreadBackgroundState extends State<AnimatedThreadBackground>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<ThreadParticle> _particles = [];
  Offset? _mousePosition;
  Size _size = Size.zero;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _initParticles(Size size) {
    if (_particles.isNotEmpty) return;
    _size = size;
    for (int i = 0; i < 60; i++) {
      _particles.add(ThreadParticle(
        position: Offset(
          _random.nextDouble() * size.width,
          _random.nextDouble() * size.height,
        ),
        velocity: Offset(
          (_random.nextDouble() - 0.5) * 0.4,
          (_random.nextDouble() - 0.5) * 0.4,
        ),
        opacity: _random.nextDouble() * 0.5 + 0.3,
      ));
    }
  }

  void _onTick(Duration elapsed) {
    if (_size == Size.zero) return;
    setState(() {
      for (final p in _particles) {
        p.position = Offset(
          p.position.dx + p.velocity.dx,
          p.position.dy + p.velocity.dy,
        );

        // Bounce off edges
        if (p.position.dx < 0 || p.position.dx > _size.width) {
          p.velocity = Offset(-p.velocity.dx, p.velocity.dy);
        }
        if (p.position.dy < 0 || p.position.dy > _size.height) {
          p.velocity = Offset(p.velocity.dx, -p.velocity.dy);
        }

        p.position = Offset(
          p.position.dx.clamp(0, _size.width),
          p.position.dy.clamp(0, _size.height),
        );
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initParticles(size);

        Widget canvas = CustomPaint(
          painter: ThreadPainter(
            particles: _particles,
            mousePosition: _mousePosition,
          ),
          child: widget.child,
        );

        if (widget.enableMouseInteraction) {
          canvas = MouseRegion(
            onHover: (event) {
              setState(() => _mousePosition = event.localPosition);
            },
            onExit: (_) {
              setState(() => _mousePosition = null);
            },
            child: canvas,
          );
        }

        return canvas;
      },
    );
  }
}
