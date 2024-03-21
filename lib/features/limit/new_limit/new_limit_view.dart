import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_modify_limit.dart';
import 'package:budget_app/common/widget/form/b_form_picker_icon.dart';
import 'package:budget_app/constants/budget_icon_constant.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';

class NewLimitView extends StatefulWidget {
  const NewLimitView({Key? key}) : super(key: key);

  @override
  State<NewLimitView> createState() => _NewLimitViewState();
}

class _NewLimitViewState extends State<NewLimitView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late int iconId;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BText.h2('New limit'),
        centerTitle: true,
        backgroundColor: ColorManager.purple12,
      ),
      body: ColoredBox(
        color: ColorManager.purple12,
        child: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: _body(),
            )
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        child: _form());
  }

  Widget _form() {
    return Column(
      children: [
        BFormFieldText(_nameController, label: 'Name'),
        gapH16,
        BFormPickerIcon(
          items: BudgetIconConstant.listIcon,
          onChanged: (iconId) {
            logSuccess(iconId.toString());
          },
        ),
        gapH32,
        BFormModifyLimit(onChanged: (v) {
          logSuccess(v.toString());
        })
      ],
    );
  }
}
