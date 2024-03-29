import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_phone_number.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_image.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/features/base_view.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfileDetailView extends StatefulWidget {
  const ProfileDetailView({super.key});

  @override
  State<ProfileDetailView> createState() => _ProfileDetailViewState();
}

class _ProfileDetailViewState extends State<ProfileDetailView> {
  late TextEditingController _nameFieldController;
  late TextEditingController _emailFieldController;

  @override
  void initState() {
    _nameFieldController = TextEditingController();
    _emailFieldController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: 'My Account',
        child: Padding(
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            child: _form()));
  }

  Widget _form() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          gapH16,
          _avatar(),
          gapH24,
          ColumnWithSpacing(
            children: _fields,
          ),
          const SizedBox(height: 80),
          FilledButton(
              onPressed: () {},
              child: BText(
                'Save',
                color: ColorManager.white,
              ))
        ],
      ),
    );
  }

  List<Widget> get _fields => [
        BFormFieldText(_nameFieldController, label: 'Name'),
        BFormFieldText(_emailFieldController, label: 'E-mail'),
        BFormFieldPhoneNumber(
          onInputChanged: (PhoneNumber value) {},
        ),
      ];

  Widget _avatar() {
    return BFormPickerImage(
        initialUrl:
            'https://e7.pngegg.com/pngimages/155/513/png-clipart-cat-feline-mammal-kawaii-animal-domestic-cute.png',
        onChanged: (file) {

        });
  }
}
