import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_controller/currency_base_controller.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BFormFieldAmount extends ConsumerStatefulWidget {
  const BFormFieldAmount({
    super.key,
    required this.label,
    this.hint,
    this.onChanged,
    this.validator,
    this.initialValue,
  });

  final String label;
  final String? hint;
  final Function(int?)? onChanged;
  final String? Function(String?)? validator;
  final int? initialValue;

  @override
  ConsumerState<BFormFieldAmount> createState() => _BFormFieldAmountState();
}

class _BFormFieldAmountState extends ConsumerState<BFormFieldAmount> {
  void _reload(String str) {
    final currencyManager = ref.read(currencyManagerProvider);
    final currentCurrency =
        ref.read(userBaseControllerProvider.select((value) => value.currency));

    // Clean the input string
    String strFormat =
        str.replaceAll(',', '').replaceAll(RegExp(r'[^\d.]'), '');

    // Parse the amount
    final parsedAmount =
        currencyManager.parseAmount(strFormat, currentCurrency);

    if (parsedAmount != null) {
      // Convert to integer for storage (handle decimal currencies properly)
      int intValue;
      if (currentCurrency.hasDecimals) {
        // For currencies with decimals, store as cents/minor units
        intValue = (parsedAmount * 100).round();
      } else {
        // For currencies without decimals, store as-is
        intValue = parsedAmount.round();
      }

      // Format for display
      try {
        final formatter = currencyManager.getCurrencyFormatter(currentCurrency);
        strFormat = formatter.format(parsedAmount);
      } catch (e) {
        strFormat = str;
      }

      _controller.value = TextEditingValue(
        text: strFormat,
        selection: TextSelection.collapsed(offset: strFormat.length),
      );

      // Store the integer value
      value = intValue;
      widget.onChanged?.call(value);
    } else {
      value = null;
      widget.onChanged?.call(null);
    }
  }

  late TextEditingController _controller;
  late int? value;

  @override
  void initState() {
    _controller = TextEditingController();
    value = widget.initialValue;
    if (widget.initialValue != null) {
      // Convert stored integer back to display format
      final currentCurrency =
          CurrencyType.usd; // Default, will be updated in build
      double displayValue;
      if (currentCurrency.hasDecimals) {
        displayValue = widget.initialValue! / 100.0;
      } else {
        displayValue = widget.initialValue!.toDouble();
      }
      _reload(displayValue.toString());
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BText(
          widget.label,
          fontWeight: FontWeight.w700,
        ),
        gapH8,
        Consumer(builder: (context, ref, _) {
          final currentCurrency = ref.watch(
              userBaseControllerProvider.select((value) => value.currency));
          final currencyManager = ref.watch(currencyManagerProvider);

          String currencySymbol =
              currencyManager.getCurrencySymbol(currentCurrency);

          return TextFormField(
            textInputAction: TextInputAction.done,
            controller: _controller,
            validator: widget.validator ?? (_) => value.validateAmount(context),
            maxLength: 16,
            keyboardType: currentCurrency.hasDecimals
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(currentCurrency.hasDecimals
                  ? RegExp(r'[0-9.,]')
                  : RegExp(r'[0-9,]')),
            ],
            decoration: InputDecoration(
              prefixText: '$currencySymbol ',
              hintText:
                  widget.hint ?? (currentCurrency.hasDecimals ? '0.00' : '0'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              counterText: '', // Hide character counter
            ),
            onChanged: (string) {
              _reload(string);
            },
          );
        }),
      ],
    );
  }
}
