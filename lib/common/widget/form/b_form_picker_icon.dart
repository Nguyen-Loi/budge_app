import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';

const double _sizeIconMain = 40;
const double _sizeIconItem = 32;

class BFormPickerIcon extends FormField<IconModel> {
  final void Function(int? iconId) onChanged;
  BFormPickerIcon({
    Key? key,
    required List<IconModel> items,
    IconModel? initialValue,
    String label = 'Icon',
    FormFieldValidator<IconModel>? validator,
    required this.onChanged,
    String? hint,
  }) : super(
          key: key,
          validator: validator,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(
                  label,
                  fontWeight: FontWeightManager.semiBold,
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
                gapH8,
                InkWell(
                    onTap: () async {
                      IconModel? icon = await showDialog(
                          context: field.context,
                          builder: (context) {
                            return _PickerIconDialog(
                                listIcon: items, initialValue: initialValue);
                          });
                      if (icon != null) {
                        field.didChange(icon);
                        onChanged(icon.id);
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Ink(
                        decoration: BoxDecoration(
                            color: ColorManager.white,
                            border: Border.all(
                                width: 0.5, color: ColorManager.green2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: field.value == null
                            ? const _ShowItem(
                                child: BText(
                                  'Choose your icon',
                                ),
                              )
                            : _ShowItem(
                                child: Icon(
                                field.value!.iconData,
                                size: _sizeIconMain,
                                color: field.value!.color,
                              )),
                      ),
                    )),
              ],
            );
          },
        );
}

class _ShowItem extends StatelessWidget {
  const _ShowItem({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: ColorManager.purple25,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: ColorManager.grey2),
      ),
      child: child,
    );
  }
}

class _PickerIconDialog extends StatefulWidget {
  const _PickerIconDialog({required this.listIcon, required this.initialValue});
  final List<IconModel> listIcon;
  final IconModel? initialValue;

  @override
  State<_PickerIconDialog> createState() => _PickerIconDialogState();
}

class _PickerIconDialogState extends State<_PickerIconDialog> {
  late IconModel? _selectedIcon;
  late List<IconModel> _listIcon;
  @override
  void initState() {
    _selectedIcon = widget.initialValue;
    _listIcon = widget.listIcon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: _listIcon.map((e) => _icon(e)).toList(),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const BText('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedIcon == null
              ? null
              : () {
                  Navigator.pop(context, _selectedIcon);
                },
          child: const BText(
            'Get',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _icon(IconModel icon) {
    bool isSelected = _selectedIcon != null && icon.id == _selectedIcon!.id;
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedIcon = null;
            } else {
              _selectedIcon = icon;
            }
          });
        },
        child: Ink(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.purple13 : ColorManager.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Icon(
            icon.iconData,
            color: icon.color,
            size: _sizeIconItem,
          ),
        ),
      ),
    );
  }
}
