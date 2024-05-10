import 'package:budget_app/common/type_def.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BFormFieldAmount extends StatefulWidget {
  final String label;
  final String? hint;
  final int? initialValue;
  final OnChangeNumber onChanged;
  final String? Function(String?)? validator;

  const BFormFieldAmount({
    super.key,
    required this.label,
    this.validator,
    this.hint,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<BFormFieldAmount> createState() => _BFormFieldAmountState();
}

class _BFormFieldAmountState extends State<BFormFieldAmount> {
  void _reload(String str) {
    String strFormat = str.replaceAll(',', '');
    try {
      strFormat =
          NumberFormat.decimalPattern('en').format(int.parse(strFormat));
    } catch (e) {
      strFormat = str;
    }
    _controller.value = TextEditingValue(
      text: strFormat,
      selection: TextSelection.collapsed(offset: strFormat.length),
    );

    widget.onChanged(value);
  }

  late TextEditingController _controller;
  late int? value;

  @override
  void initState() {
    _controller = TextEditingController();
    value = widget.initialValue;
    if (widget.initialValue != null) {
      _reload(widget.initialValue.toString());
    }

    super.initState();
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
          String userCurrency = ref.watch(userBaseControllerProvider
              .select((value) => value!.currencyType.code));
          String currency =
              NumberFormat.compactSimpleCurrency(locale: userCurrency)
                  .currencySymbol;
          return TextFormField(
            textInputAction: TextInputAction.done,
            controller: _controller,
            validator: widget.validator ?? (_) => value.validateAmount(context),
            maxLength: 16,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: currency,
              hintText: widget.hint ?? context.loc.amountHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (string) {
              value = int.tryParse(string.replaceAll(',', '')) ?? 0;
              _reload(string);
            },
          );
        }),
      ],
    );
  }
}
