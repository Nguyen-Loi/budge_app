import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, outlined, text, premium }

enum ButtonSize { small, medium, large, custom }

class _ButtonSizing {
  final double maxWidth;
  final double minHeight;
  final double minWidth;
  final double horizontalPadding;
  final double verticalPadding;

  const _ButtonSizing({
    required this.maxWidth,
    required this.minHeight,
    required this.minWidth,
    required this.horizontalPadding,
    required this.verticalPadding,
  });
}

class BButton extends StatelessWidget {
  const BButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.minPadding,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.enabled = true,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  })  : type = ButtonType.filled,
        color = null,
        textDecoration = null;

  const BButton.text({
    super.key,
    required this.onPressed,
    required this.title,
    this.color,
    this.textDecoration,
    this.padding,
    this.minPadding,
    this.size = ButtonSize.small,
    this.enabled = true,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  })  : type = ButtonType.text,
        isLoading = false;

  const BButton.outlined({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.minPadding,
    this.color,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.enabled = true,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  })  : type = ButtonType.outlined,
        textDecoration = null;

  const BButton.premium({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.minPadding,
    this.size = ButtonSize.large,
    this.isLoading = false,
    this.enabled = true,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  })  : type = ButtonType.premium,
        color = null,
        textDecoration = null;

  // Convenience constructors for different sizes
  const BButton.small({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.minPadding,
    this.isLoading = false,
    this.enabled = true,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  })  : type = ButtonType.filled,
        color = null,
        textDecoration = null,
        size = ButtonSize.small;

  const BButton.large({
    super.key,
    required this.onPressed,
    required this.title,
    this.padding,
    this.minPadding,
    this.isLoading = false,
    this.enabled = true,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
  })  : type = ButtonType.filled,
        color = null,
        textDecoration = null,
        size = ButtonSize.large;

  final VoidCallback? onPressed;
  final String title;
  final EdgeInsets? padding;
  final EdgeInsets? minPadding;
  final TextDecoration? textDecoration;
  final Color? color;
  final double? minHeight;
  final double? maxWidth;
  final double? minWidth;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = SizeConstants.isSmallScreen(context);

    // Get default sizing based on button size and screen size
    final sizing = _getButtonSizing(isSmallScreen);

    // Use provided padding or calculate based on size and minPadding
    EdgeInsets? paddingItem =
        padding ?? _calculatePadding(sizing, isSmallScreen);

    return ConstrainedBox(
      constraints: type == ButtonType.text
          ? const BoxConstraints()
          : BoxConstraints(
              maxWidth: maxWidth ?? sizing.maxWidth,
              minHeight: minHeight ?? sizing.minHeight,
              minWidth: minWidth ?? sizing.minWidth,
            ),
      child: buildButton(context, padding: paddingItem),
    );
  }

  // Helper method to get button sizing based on size enum
  _ButtonSizing _getButtonSizing(bool isSmallScreen) {
    switch (size) {
      case ButtonSize.small:
        return _ButtonSizing(
          maxWidth: isSmallScreen ? 120 : 140,
          minHeight: isSmallScreen ? 32 : 36,
          minWidth: isSmallScreen ? 60 : 80,
          horizontalPadding: isSmallScreen ? 8 : 12,
          verticalPadding: isSmallScreen ? 4 : 6,
        );
      case ButtonSize.medium:
        return _ButtonSizing(
          maxWidth: isSmallScreen ? 160 : SizeConstants.buttonMaxWidth,
          minHeight: isSmallScreen ? 40 : SizeConstants.buttonMinHeight,
          minWidth: isSmallScreen ? 80 : 100,
          horizontalPadding: isSmallScreen ? 12 : 16,
          verticalPadding: isSmallScreen ? 8 : 12,
        );
      case ButtonSize.large:
        return _ButtonSizing(
          maxWidth: isSmallScreen ? 200 : SizeConstants.buttonMaxWidth + 50,
          minHeight: isSmallScreen ? 48 : SizeConstants.buttonMinHeight + 8,
          minWidth: isSmallScreen ? 100 : 120,
          horizontalPadding: isSmallScreen ? 16 : 24,
          verticalPadding: isSmallScreen ? 12 : 16,
        );
      case ButtonSize.custom:
        return _ButtonSizing(
          maxWidth: SizeConstants.buttonMaxWidth,
          minHeight: SizeConstants.buttonMinHeight,
          minWidth: 60,
          horizontalPadding: 16,
          verticalPadding: 12,
        );
    }
  }

  // Helper method to calculate padding with minPadding support
  EdgeInsets _calculatePadding(_ButtonSizing sizing, bool isSmallScreen) {
    EdgeInsets defaultPadding = EdgeInsets.symmetric(
      horizontal: sizing.horizontalPadding,
      vertical: sizing.verticalPadding,
    );

    if (minPadding != null) {
      return EdgeInsets.symmetric(
        horizontal: (defaultPadding.horizontal < minPadding!.horizontal)
            ? minPadding!.horizontal
            : defaultPadding.horizontal,
        vertical: (defaultPadding.vertical < minPadding!.vertical)
            ? minPadding!.vertical
            : defaultPadding.vertical,
      );
    }

    return defaultPadding;
  }

  Widget buildButton(BuildContext context, {required EdgeInsets? padding}) {
    switch (type) {
      case ButtonType.filled:
        return _filledButton(context, padding);
      case ButtonType.outlined:
        return _outlinedButton(context, padding);
      case ButtonType.text:
        return _textButton(context, padding);
      case ButtonType.premium:
        return _premiumButton(context, padding);
    }
  }

  Widget _filledButton(BuildContext context, EdgeInsets? paddingItem) {
    return AnimatedScale(
      scale: enabled ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withAlpha(200),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [ColorManager.greyLight, ColorManager.greyLight],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(100),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: enabled && onPressed != null
                ? (isLoading ? null : onPressed)
                : null,
            borderRadius: BorderRadius.circular(16),
            splashColor: ColorManager.white.withAlpha(20),
            highlightColor: ColorManager.white.withAlpha(0),
            child: Container(
              padding: paddingItem,
              constraints: BoxConstraints(
                minHeight: minHeight ?? SizeConstants.buttonMinHeight,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorManager.white),
                          ),
                        )
                      : _bTtextBaseSize(
                          key: const ValueKey('text'),
                          title,
                          color: enabled
                              ? ColorManager.white
                              : ColorManager.greyDark,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _outlinedButton(BuildContext context, EdgeInsets? paddingItem) {
    Color buttonColor = color ?? Theme.of(context).colorScheme.primary;

    return AnimatedScale(
      scale: enabled ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: enabled ? buttonColor : ColorManager.greyLight,
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: buttonColor.withAlpha(30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: enabled && onPressed != null
                ? (isLoading ? null : onPressed)
                : null,
            borderRadius: BorderRadius.circular(16),
            splashColor: buttonColor.withAlpha(40),
            highlightColor: buttonColor.withAlpha(20),
            child: Container(
              padding: paddingItem,
              constraints: BoxConstraints(
                minHeight: minHeight ?? SizeConstants.buttonMinHeight,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(buttonColor),
                          ),
                        )
                      : _bTtextBaseSize(
                          key: const ValueKey('text'),
                          title,
                          color: enabled ? buttonColor : ColorManager.greyLight,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textButton(BuildContext context, EdgeInsets? paddingItem) {
    Color linkColor = color ?? Theme.of(context).colorScheme.primary;

    return AnimatedScale(
      scale: enabled ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 150),
      child: InkWell(
        onTap: enabled && onPressed != null ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        splashColor: linkColor.withAlpha(60),
        highlightColor: linkColor.withAlpha(30),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: paddingItem?.vertical ?? 6,
            horizontal: paddingItem?.horizontal ?? 10,
          ),
          child: _bTtextBaseSize(
            title,
            textDecoration: textDecoration ?? TextDecoration.underline,
            fontWeight: FontWeight.w600,
            color: enabled ? linkColor : ColorManager.greyLight,
          ),
        ),
      ),
    );
  }

  Widget _bTtextBaseSize(String text,
      {TextDecoration? textDecoration,
      FontWeight? fontWeight,
      Color? color,
      Key? key}) {
    switch (size) {
      case ButtonSize.small:
        return BText.b3(text,
            key: key,
            textDecoration: textDecoration,
            fontWeight: fontWeight,
            color: color,
            textAlign: TextAlign.center);
      case ButtonSize.medium:
        return BText(text,
            key: key,
            textDecoration: textDecoration,
            fontWeight: fontWeight,
            color: color,
            textAlign: TextAlign.center);
      case ButtonSize.large:
        return BText.b1(text,
            key: key,
            textDecoration: textDecoration,
            fontWeight: fontWeight,
            color: color,
            textAlign: TextAlign.center);
      case ButtonSize.custom:
        return BText.caption(text,
            key: key,
            textDecoration: textDecoration,
            fontWeight: fontWeight,
            color: color,
            textAlign: TextAlign.center);
    }
  }

  Widget _premiumButton(BuildContext context, EdgeInsets? paddingItem) {
    return AnimatedScale(
      scale: enabled ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          gradient: enabled
              ? LinearGradient(
                  colors: [
                    ColorManager.orange,
                    Colors.amber.shade600,
                    ColorManager.yellow,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                )
              : LinearGradient(
                  colors: [ColorManager.greyLight, ColorManager.greyLight],
                ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: ColorManager.orange.withAlpha(100),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.amber.withAlpha(50),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                    spreadRadius: 0,
                  ),
                  // Inner glow effect
                  BoxShadow(
                    color: ColorManager.white.withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                    spreadRadius: -4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: enabled && onPressed != null
                ? (isLoading ? null : onPressed)
                : null,
            borderRadius: BorderRadius.circular(20),
            splashColor: ColorManager.white.withAlpha(120),
            highlightColor: ColorManager.white.withAlpha(80),
            child: Container(
              padding: paddingItem,
              constraints: BoxConstraints(
                minHeight: minHeight ?? (SizeConstants.buttonMinHeight + 8),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          height: 26,
                          width: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorManager.white),
                          ),
                        )
                      : Row(
                          key: const ValueKey('text'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: ColorManager.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            _bTtextBaseSize(
                              title,
                              color: enabled
                                  ? ColorManager.white
                                  : ColorManager.greyDark,
                              fontWeight: FontWeight.w800,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.star,
                              color: ColorManager.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
