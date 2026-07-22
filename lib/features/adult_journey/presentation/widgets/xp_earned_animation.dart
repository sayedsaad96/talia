import 'package:flutter/material.dart';
import 'package:talia/core/theme/app_colors.dart';

class XpEarnedAnimation extends StatefulWidget {
  final int xp;

  const XpEarnedAnimation({
    super.key,
    required this.xp,
  });

  @override
  State<XpEarnedAnimation> createState() => _XpEarnedAnimationState();
}

class _XpEarnedAnimationState extends State<XpEarnedAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _xpAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _xpAnimation = IntTween(begin: 0, end: widget.xp).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _xpAnimation,
      builder: (context, child) {
        return Column(
          children: [
            const Icon(Icons.star, color: AppColors.secondary, size: 64),
            Text(
              '+${_xpAnimation.value} XP',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}
