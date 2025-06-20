import 'package:budget_app/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

class BAnimatedText extends StatefulWidget {
  const BAnimatedText(this.text, {super.key, this.fontSize});
  final double? fontSize;
  final String text;

  @override
  State<BAnimatedText> createState() => _BAnimatedTextState();
}

class _BAnimatedTextState extends State<BAnimatedText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;
  int _repeatCount = 0;
  static const int maxRepeats = 4;
  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();

    // Animation controller for typing effect
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * 100),
      vsync: this,
    );

    // Animation controller for blinking cursor
    _cursorController = AnimationController(
      duration: const Duration(milliseconds: 530),
      vsync: this,
    );

    _characterCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
    _startCursorAnimation();
  }

  void _startAnimation() async {
    while (_repeatCount < maxRepeats && mounted) {
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      _controller.reset();
      _repeatCount++;
    }
    // Keep the full text displayed after animation completes
    if (mounted) {
      _controller.forward();
    }
  }

  void _startCursorAnimation() {
    _cursorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Display full text on tap and stop animation
        if (_repeatCount < maxRepeats) {
          setState(() {
            _repeatCount = maxRepeats;
          });
          _controller.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          String displayText = widget.text.substring(0, _characterCount.value);

          return AnimatedBuilder(
            animation: _cursorController,
            builder: (context, child) {
              return RichText(
                text: TextSpan(
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: widget.fontSize,
                  ),
                  children: [
                    TextSpan(text: displayText),
                    TextSpan(
                      text: _cursorController.value > 0.5 ? '|' : '',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
