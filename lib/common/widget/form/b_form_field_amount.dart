import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/utils/currency_utils.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Custom input formatter for currency amounts with thousand separators
class CurrencyInputFormatter extends TextInputFormatter {
  final CurrencyType currency;

  CurrencyInputFormatter(this.currency);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handle empty input
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-numeric characters except decimal point
    String newText = newValue.text;

    // Only allow numbers and decimal point for currencies that support decimals
    if (currency.hasDecimals) {
      newText = newText.replaceAll(RegExp(r'[^0-9.]'), '');

      // Prevent multiple decimal points
      final parts = newText.split('.');
      if (parts.length > 2) {
        newText = '${parts[0]}.${parts[1]}';
      }

      // Limit decimal places
      if (parts.length == 2 && parts[1].length > currency.decimalPlaces) {
        newText =
            '${parts[0]}.${parts[1].substring(0, currency.decimalPlaces)}';
      }
    } else {
      newText = newText.replaceAll(RegExp(r'[^0-9]'), '');
    }

    // Handle empty string after cleaning
    if (newText.isEmpty) {
      return const TextEditingValue();
    }

    // Prevent leading zeros (except for decimal cases like 0.50)
    if (newText.length > 1 &&
        newText.startsWith('0') &&
        !newText.startsWith('0.')) {
      newText = newText.substring(1);
    }

    // Add thousand separators
    final formattedText = _addThousandSeparators(newText, currency);

    // Calculate new cursor position
    int newCursorPosition = _calculateCursorPosition(
      oldValue.text,
      newValue.text,
      formattedText,
      oldValue.selection.baseOffset,
      newValue.selection.baseOffset,
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  String _addThousandSeparators(String text, CurrencyType currency) {
    if (text.isEmpty) return text;

    // Split into integer and decimal parts
    final parts = text.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Add thousand separators to integer part (skip for single zero)
    if (integerPart.isNotEmpty && integerPart != '0') {
      final intValue = int.tryParse(integerPart);
      if (intValue != null) {
        final formatter = NumberFormat('#,###');
        integerPart = formatter.format(intValue);
      }
    }

    // Combine parts
    if (decimalPart.isNotEmpty || text.endsWith('.')) {
      return '$integerPart.$decimalPart';
    }

    return integerPart;
  }

  int _calculateCursorPosition(
    String oldText,
    String newText,
    String formattedText,
    int oldCursor,
    int newCursor,
  ) {
    // Count numeric characters before cursor position in the new text
    int numericCharsBefore = 0;
    for (int i = 0; i < newCursor && i < newText.length; i++) {
      if (RegExp(r'[0-9.]').hasMatch(newText[i])) {
        numericCharsBefore++;
      }
    }

    // Find corresponding position in formatted text
    int targetPosition = 0;
    int numericCount = 0;
    for (int i = 0; i < formattedText.length; i++) {
      if (RegExp(r'[0-9.]').hasMatch(formattedText[i])) {
        numericCount++;
        if (numericCount >= numericCharsBefore) {
          targetPosition = i + 1;
          break;
        }
      }
      targetPosition = i + 1;
    }

    return targetPosition.clamp(0, formattedText.length);
  }
}

class BFormFieldAmount extends ConsumerStatefulWidget {
  const BFormFieldAmount({
    super.key,
    required this.label,
    this.hint,
    this.onChanged,
    this.initialValue,
    this.showCurrencyPrefix = true,
    this.maxLength = 16,
  });

  final String label;
  final String? hint;
  final Function(int?)? onChanged;
  final int? initialValue;
  final bool showCurrencyPrefix;
  final int maxLength;

  @override
  ConsumerState<BFormFieldAmount> createState() =>
      _BFormFieldAmountEnhancedState();
}

class _BFormFieldAmountEnhancedState extends ConsumerState<BFormFieldAmount> {
  late TextEditingController _controller;
  int? _currentValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _currentValue = widget.initialValue;

    if (widget.initialValue != null) {
      _setInitialValue();
    }
  }

  void _setInitialValue() {
    final currentCurrency = _getCurrentCurrency();
    final displayAmount =
        CurrencyUtils.toDisplayAmount(widget.initialValue!, currentCurrency);

    // Format the initial value with thousand separators
    final formatter = CurrencyInputFormatter(currentCurrency);
    final formattedValue = formatter.formatEditUpdate(
      const TextEditingValue(),
      TextEditingValue(text: displayAmount.toString()),
    );

    _controller.value = formattedValue;
    _currentValue = widget.initialValue;
  }

  CurrencyType _getCurrentCurrency() {
    return ref
        .read(userBaseControllerProvider.select((value) => value.currency));
  }

  void _updateController(String value) {
    final currentCurrency = _getCurrentCurrency();

    // Parse the input (handles comma separators automatically)
    final storageAmount = CurrencyUtils.parseInput(value, currentCurrency);

    _currentValue = storageAmount;
    widget.onChanged?.call(storageAmount);
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
        Consumer(
          builder: (context, ref, _) {
            final currentCurrency = ref.watch(
              userBaseControllerProvider.select((value) => value.currency),
            );

            return TextFormField(
              controller: _controller,
              keyboardType: currentCurrency.hasDecimals
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              inputFormatters: [
                CurrencyInputFormatter(currentCurrency),
              ],
              validator: (_) {
                return CurrencyUtils.validateAmount(
                    _currentValue, currentCurrency);
              },
              decoration: InputDecoration(
                prefixText: widget.showCurrencyPrefix
                    ? '${currentCurrency.symbol} '
                    : null,
                hintText:
                    widget.hint ?? CurrencyUtils.getInputHint(currentCurrency),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                counterText: '', // Hide character counter
                suffixIcon:
                    (_currentValue != null || _controller.text.isNotEmpty)
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              _controller.clear();
                              _currentValue = null;
                              widget.onChanged?.call(null);
                            },
                          )
                        : null,
              ),
              onChanged: _updateController,
              maxLength: widget.maxLength,
            );
          },
        ),
        // Show formatted amount preview
        if (_currentValue != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Consumer(
              builder: (context, ref, _) {
                final currentCurrency = ref.watch(
                  userBaseControllerProvider.select((value) => value.currency),
                );

                return Text(
                  context.loc.previewValue(CurrencyUtils.formatExact(
                      _currentValue!, currentCurrency)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(200),
                      ),
                );
              },
            ),
          ),
      ],
    );
  }
}
