import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final int earnedStars;
  final int totalStars;
  final double starSize;
  final bool animate;

  const StarRating({
    super.key,
    required this.earnedStars,
    this.totalStars = 3,
    this.starSize = 32.0,
    this.animate = false,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.earnedStars.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(StarRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.earnedStars != oldWidget.earnedStars) {
      _animation = Tween<double>(begin: 0.0, end: widget.earnedStars.toDouble()).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalStars, (index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final double fill = (_animation.value - index).clamp(0.0, 1.0);
            return Icon(
              fill >= 0.5 ? Icons.star_rounded : Icons.star_outline_rounded,
              color: fill >= 0.5 ? Colors.amber : Colors.grey[400],
              size: widget.starSize,
            );
          },
        );
      }),
    );
  }
}
