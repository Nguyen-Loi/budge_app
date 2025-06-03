import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/material.dart';

class BButtonIcon extends StatelessWidget {
  const BButtonIcon({
    super.key,
    this.onPressed,
    required this.iconData,
    required this.title,
  });

  final VoidCallback? onPressed;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final backgroudColor = Theme.of(context).colorScheme.secondary;
    final color = Theme.of(context).colorScheme.onSecondary;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: color,
        size: 24,
      ),
      label: BText.b1(
        title,
        color: color,
        fontWeight: FontWeight.w600,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroudColor,
        foregroundColor: color,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: color.withAlpha(150),
            width: 1,
          ),
        ),
      ),
    );
  }
}
