import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:flutter/material.dart';

class BFormFieldCustomAmount extends FormField<int> {
  final void Function(int value) onChanged;
  final CurrencyType currencyType;
  BFormFieldCustomAmount({
    Key? key,
    int? initialValue,
    FormFieldValidator<int>? validator,
    required String label,
    required this.onChanged,
    this.currencyType = CurrencyType.vnd,
    String? hint,
  }) : super(
          key: key,
          validator: validator,
          initialValue: initialValue,
          builder: (field) {
            final _FormFieldState state = field as _FormFieldState;
            return GestureDetector(
              onTap: () {
                FocusScope.of(field.context).unfocus();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BText.h2(
                    label,
                    color: ColorManager.purple12,
                    fontWeight: FontWeight.w700,
                  ),
                  if (field.hasError)
                    Column(
                      children: [
                        gapH8,
                        Text(
                          field.errorText ?? 'Invalid',
                          style: Theme.of(field.context)
                              .inputDecorationTheme
                              .errorStyle,
                        ),
                      ],
                    ),
                  gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _IconButtonLimit(
                          icon: IconManager.minus,
                          onTap: () {
                            int value =
                                int.tryParse(state.controller.text) ?? -1;
                            if (value > 10) {
                              int newValue =
                                  int.parse(state.controller.text) - 10;
                              state.controller.text = newValue.toString();
                            } else {
                              state.controller.text = '0';
                            }
                          }),
                      gapW16,
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: state.controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            suffixText: '.000 đ',
                          ),
                        ),
                      ),
                      gapW16,
                      _IconButtonLimit(
                          icon: IconManager.add,
                          onTap: () {
                            int value =
                                int.tryParse(state.controller.text) ?? -1;
                            if (value >= 0) {
                              int newValue =
                                  int.parse(state.controller.text) + 10;
                              state.controller.text = newValue.toString();
                            } else {
                              state.controller.text = '10';
                            }
                          })
                    ],
                  ),
                ],
              ),
            );
          },
        );

  @override
  FormFieldState<int> createState() {
    return _FormFieldState();
  }
}

class _FormFieldState extends FormFieldState<int> {
  @override
  BFormFieldCustomAmount get widget => super.widget as BFormFieldCustomAmount;
  late final TextEditingController controller;
  @override
  void initState() {
    String initialValue =
        widget.initialValue == null ? '0' : widget.initialValue.toString();
    controller = TextEditingController(text: initialValue);
    controller.addListener(_onChangedText);
    super.initState();
  }

  void _onChangedText() {
    didChange(int.tryParse(controller.text));
  }

  @override
  void didChange(int? value) {
    if (value != null) {
      if (widget.currencyType == CurrencyType.vnd) {
        widget.onChanged(value);
      }
    }
    super.didChange(value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _IconButtonLimit extends StatelessWidget {
  const _IconButtonLimit({required this.icon, required this.onTap});
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Ink(
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.grey1, width: 1),
            color: ColorManager.white,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(1000.0),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                icon,
                size: 25.0,
                color: ColorManager.black,
              ),
            ),
          ),
        ));
  }
}
