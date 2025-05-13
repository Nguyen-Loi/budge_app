import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, outlined, text }

class BButton extends StatelessWidget {
  const BButton(
      {super.key, required this.onPressed, required this.title, this.padding})
      : type = ButtonType.filled, 
        textDecoration = null;

  BButton.text({super.key, required this.onPressed, required this.title, this.textDecoration})
      : type = ButtonType.text,
        padding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  final VoidCallback onPressed;
  final String title;
  final EdgeInsets? padding;
  final TextDecoration? textDecoration;
  final ButtonType type;

  @override
  Widget build(BuildContext context) {
    bool isSmallSreen = SizeConstants.isSmallScreen(context);
    EdgeInsets? paddingItem = padding ??
        (isSmallSreen
            ? null
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 24));
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: SizeConstants.buttonMaxWidth),
      child: buildButton(context, padding: paddingItem),
    );
  }

  Widget buildButton(BuildContext context, {required EdgeInsets? padding}) {
    switch (type) {
      case ButtonType.filled:
        return _filledButton(context, padding);
      case ButtonType.outlined:
        return SizedBox.shrink();
      case ButtonType.text:
        return _textButton(context, padding);
    }
  }

  Widget _filledButton(BuildContext context, EdgeInsets? paddingItem) {
    return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(padding: paddingItem),
        clipBehavior: Clip.antiAlias,
        child: BText.b1(
          title,
          color: ColorManager.white,
        ));
  }

  Widget _textButton(BuildContext context, EdgeInsets? paddingItem) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: paddingItem?.vertical ?? 0,
            horizontal: paddingItem?.horizontal ?? 0),
        child: BText(
          title,
          textDecoration: textDecoration,
          color: Theme.of(context).colorScheme.primary,
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
