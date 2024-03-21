import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';

class BFormPickerIcon extends FormField<IconModel> {
  BFormPickerIcon({
    Key? key,
    required List<IconModel> items,
    IconModel? initialValue,
    String label = 'Icon',
    FormFieldValidator<IconModel>? validator,
    required void Function(int? iconId) onChanged,
    String? hint,
  }) : super(
          key: key,
          validator: validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(
                  label,
                  fontWeight: FontWeightManager.semiBold,
                ),
                gapH8,
                InkWell(
                    onTap: () async {
                      IconModel? icon = await showDialog(
                          context: state.context,
                          builder: (context) {
                            return _PickerIconDialog(
                                listIcon: items, initialValue: initialValue);
                          });
                      if (icon != null) state.didChange(icon);
                    },
                    child: Ink(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: ColorManager.white,
                          border: Border.all(width: 0.5, color: ColorManager.green1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: state.value == null
                          ? BText('Picker your icon', color: ColorManager.grey2)
                          : Icon(
                              state.value!.iconData,
                              color: state.value!.color,
                            ),
                    )),
                if (state.hasError)
                  BText(
                    state.errorText ?? "Invalid",
                    color: ColorManager.error,
                  )
              ],
            );
          },
        );
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
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _listIcon.map((e) => _icon(e)).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: BText('Cancel', color: ColorManager.grey1),
        ),
        TextButton(
          onPressed: _selectedIcon == null
              ? null
              : () {
                  Navigator.pop(context, _selectedIcon);
                },
          child: BText('Get', color: ColorManager.purple11),
        )
      ],
    );
  }

  Widget _icon(IconModel icon) {
    bool isSelected = _selectedIcon != null && icon.id == _selectedIcon!.id;
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedIcon = null;
          } else {
            _selectedIcon = icon;
          }
          Navigator.pop(context, _selectedIcon);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.purple12 : ColorManager.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Icon(icon.iconData, color: icon.color),
      ),
    );
  }
}
