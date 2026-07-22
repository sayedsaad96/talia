import 'dart:math';
import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';

class ConfettiAnimation extends StatefulWidget {
  const ConfettiAnimation({super.key});

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          for (var particle in _particles) {
            particle.update();
          }
        });
      });

    _generateParticles();
    _controller.forward();
  }

  void _generateParticles() {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      Colors.pink,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];

    for (int i = 0; i < 100; i++) {
      _particles.add(
        _ConfettiParticle(
          x: _random.nextDouble() * 400 - 200, // Relative to center
          y: _random.nextDouble() * -200, // Start slightly above
          vx: _random.nextDouble() * 10 - 5,
          vy: _random.nextDouble() * -15 - 5, // Upward initial velocity
          color: colors[_random.nextInt(colors.length)],
          size: _random.nextDouble() * 8 + 4,
          rotation: _random.nextDouble() * pi * 2,
          rotationSpeed: _random.nextDouble() * 0.2 - 0.1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ConfettiPainter(_particles),
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double rotation;
  double rotationSpeed;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });

  void update() {
    x += vx;
    y += vy;
    vy += 0.5; // Gravity
    rotation += rotationSpeed;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);

    for (var p in particles) {
      paint.color = p.color;
      canvas.save();
      canvas.translate(center.dx + p.x, center.dy + p.y);
      canvas.rotate(p.rotation);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
