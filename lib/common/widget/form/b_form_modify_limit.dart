import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BFormModifyLimit extends FormField<int> {
  final void Function(int value) onChanged;
  BFormModifyLimit({
    Key? key,
    int? initialValue,
    FormFieldValidator<int>? validator,
    required this.onChanged,
    String? hint,
  }) : super(
          key: key,
          validator: validator,
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
                    'Monthly limit',
                    color: ColorManager.purple12,
                    fontWeight: FontWeightManager.semiBold,
                  ),
                  gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _IconButtonLimit(
                          icon: IconConstants.minus,
                          onTap: () {
                            int newValue =
                                int.parse(state.controller.text) - 10;
                            state.controller.text = newValue.toString();
                          }),
                      gapW16,
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: state.controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      gapW16,
                      _IconButtonLimit(
                          icon: IconConstants.add,
                          onTap: () {
                            int newValue =
                                int.parse(state.controller.text) + 10;
                            state.controller.text = newValue.toString();
                          })
                    ],
                  ),
                  if (field.hasError)
                    BText(
                      field.errorText ?? "Invalid",
                      color: ColorManager.error,
                    )
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
  BFormModifyLimit get widget => super.widget as BFormModifyLimit;
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
      widget.onChanged(value);
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
            border: Border.all(color: ColorManager.grey, width: 1),
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
