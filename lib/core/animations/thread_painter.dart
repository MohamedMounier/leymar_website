import 'dart:math';
import 'package:flutter/material.dart';

class ThreadParticle {
  Offset position;
  Offset velocity;
  double opacity;

  ThreadParticle({
    required this.position,
    required this.velocity,
    required this.opacity,
  });
}

class ThreadPainter extends CustomPainter {
  final List<ThreadParticle> particles;
  final Offset? mousePosition;

  ThreadPainter({required this.particles, this.mousePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = const Color(0xFFC79A3B).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].position.dx - particles[j].position.dx;
        final dy = particles[i].position.dy - particles[j].position.dy;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 180) {
          final opacity = (1 - distance / 180) * 0.07;
          linePaint.color = Color(0xFFC79A3B).withOpacity(opacity);
          canvas.drawLine(particles[i].position, particles[j].position, linePaint);
        }
      }

      // Draw dot
      canvas.drawCircle(particles[i].position, 1.2, dotPaint);

      // Mouse attraction line
      if (mousePosition != null) {
        final mdx = particles[i].position.dx - mousePosition!.dx;
        final mdy = particles[i].position.dy - mousePosition!.dy;
        final mDist = sqrt(mdx * mdx + mdy * mdy);
        if (mDist < 120) {
          final mOpacity = (1 - mDist / 120) * 0.12;
          linePaint.color = Color(0xFFE0BC74).withOpacity(mOpacity);
          canvas.drawLine(particles[i].position, mousePosition!, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ThreadPainter oldDelegate) => true;
}
