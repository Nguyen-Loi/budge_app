import 'package:budget_app/common/widget/b_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BButtonIcon extends StatelessWidget {
  const BButtonIcon({
    super.key,
    this.onPressed,
    required this.iconData,
    required this.title,
    this.maxWidth,
    this.padding,
    this.iconSize = 24,
    this.borderRadius = 12,
    this.elevation = 0,
  });

  final VoidCallback? onPressed;
  final String title;
  final IconData iconData;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final double iconSize;
  final double borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.secondary;
    final color = Theme.of(context).colorScheme.onPrimary;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          iconData,
          color: color,
          size: iconSize,
        ),
        label: BText.b1(
          title,
          color: color,
          fontWeight: FontWeight.w600,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: color,
          elevation: elevation,
          shadowColor: elevation > 0 ? Colors.black26 : Colors.transparent,
          padding: paddingData(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: color.withAlpha(150),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry paddingData(BuildContext context) {
    if (padding != null) {
      return padding!;
    }
    return EdgeInsets.symmetric(
      horizontal: !kIsWeb ? 12 : 32,
      vertical: !kIsWeb ? 8 : 20,
    );
  }
}
