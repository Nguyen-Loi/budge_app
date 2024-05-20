import 'package:budget_app/common/color_manager.dart';
import 'package:flutter/material.dart';

class BProgressBar extends StatelessWidget {
  final int percent;
  final LinearGradient gradient;

  const BProgressBar(
      {required this.percent, required this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: gradient.colors.first,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: percent,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: percent == 100
                    ? const BorderRadius.all(Radius.circular(4))
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        topLeft: Radius.circular(4)),
              ),
              child: const SizedBox(height: 7.0),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 100 - percent,
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.grey2,
                borderRadius: percent == 0
                    ? const BorderRadius.all(Radius.circular(4))
                    : const BorderRadius.only(
                        bottomRight: Radius.circular(4),
                        topRight: Radius.circular(4)),
              ),
              child: const SizedBox(height: 7.0),
            ),
          ),
        ],
      ),
    );
  }
}
