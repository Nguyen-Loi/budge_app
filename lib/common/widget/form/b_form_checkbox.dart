import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';

class BFormCheckbox extends FormField<bool> {
  BFormCheckbox(
      {super.key,
      required Widget title,
      bool initialValue = false,
      String? Function(bool?)? validator})
      : super(
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: field.value,
                        onChanged: (v) => {field.didChange(v)},
                      ),
                      gapW16,
                      Expanded(child: title)
                    ],
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(field.errorText ?? 'Invalid',
                          style: Theme.of(field.context)
                              .inputDecorationTheme
                              .errorStyle),
                    )
                ],
              );
            },
            initialValue: initialValue,
            validator: validator);
}
