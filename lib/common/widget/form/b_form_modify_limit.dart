import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BFormModifyLimit extends FormField<int> {
  BFormModifyLimit({
    Key? key,
    int? initialValue,
    FormFieldValidator<int>? validator,
    required void Function(int? iconId) onChanged,
    String? hint,
  }) : super(
          key: key,
          validator: validator,
          builder: (state) {     
            TextEditingController controller = TextEditingController(
                text: initialValue == null ? '0' : initialValue.toString());
            state.didChange(int.tryParse(controller.text));
            return GestureDetector(
              onTap: () {
                FocusScope.of(state.context).unfocus();
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
                            int newValue = int.parse(controller.text) - 10;
                            controller.text = newValue.toString();
                            onChanged(newValue);
                          }),
                      gapW16,
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      gapW16,
                      _IconButtonLimit(
                          icon: IconConstants.add,
                          onTap: () {
                            int newValue = int.parse(controller.text) + 10;
                            controller.text = newValue.toString();
                          })
                    ],
                  ),
                  if (state.hasError)
                    BText(
                      state.errorText ?? "Invalid",
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

 @override
  void initState() {
    super.initState();
  }

 @override
  void dispose() {
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
