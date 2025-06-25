import 'package:budget_app/common/color_manager.dart';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    _colors = widget.colors ??
        [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.tertiary,
        ];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _colors.map((color) {
                return Color.lerp(
                  color,
                  color.withAlpha(180),
                  _animation.value,
                )!;
              }).toList(),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class FloatingParticles extends StatefulWidget {
  final int numberOfParticles;
  final Color color;

  const FloatingParticles({
    super.key,
    this.numberOfParticles = 20,
    this.color = ColorManager.gradientBlueEnd,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.numberOfParticles,
      (index) => AnimationController(
        duration: Duration(seconds: 3 + (index % 3)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(
          (controller.hashCode % 100) / 100.0,
          1.2,
        ),
        end: Offset(
          (controller.hashCode % 100) / 100.0,
          -0.2,
        ),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ));
    }).toList();

    for (var controller in _controllers) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _animations.asMap().entries.map((entry) {
        final index = entry.key;
        final animation = entry.value;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: MediaQuery.of(context).size.width * animation.value.dx,
              top: MediaQuery.of(context).size.height * animation.value.dy,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 4 + (index % 3) * 2,
                  height: 4 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
