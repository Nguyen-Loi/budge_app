import 'dart:io';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_phone_number.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_image.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/profile_view/profile_detail/controller/profile_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfileDetailView extends StatefulWidget {
  const ProfileDetailView({super.key});

  @override
  State<ProfileDetailView> createState() => _ProfileDetailViewState();
}

class _ProfileDetailViewState extends State<ProfileDetailView> {
  late String _name;
  File? _file;
  late PhoneNumber _phoneNumber;
  final _keyState = GlobalKey<FormState>();

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
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userControllerProvider)!;
      final disable = ref.watch(profileDetailControllerProvider);
      _name = user.name;
      _phoneNumber = user.phoneNumber!;
      return Form(
        key: _keyState,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                  onPressed: () {
                    ref
                        .read(profileDetailControllerProvider.notifier)
                        .updateDisable(!disable);
                  },
                  child: disable
                      ? const BText.caption(
                          'Modify',
                        )
                      : const BText.caption('Read Only')),
            ),
            gapH16,
            BFormPickerImage(
                initialUrl: user.profileUrl,
                disable: disable,
                onChanged: (f) {
                  _file = f;
                }),
            gapH24,
            ColumnWithSpacing(
              children: [
                BFormFieldText.init(
                    label: 'Email', disable: true, initialValue: user.email),
                BFormFieldText.init(
                  label: 'Name',
                  disable: disable,
                  initialValue: user.name,
                  validator: (v) => v.validateName,
                  onChanged: (v) {
                    _name = v;
                  },
                ),
                BFormFieldPhoneNumber(
                  disable: disable,
                  initialValue: user.phoneNumber,
                  validator: (v) => v.validatePhoneNumber,
                  onInputChanged: (PhoneNumber value) {
                    _phoneNumber = value;
                  },
                ),
              ],
            ),
            const SizedBox(height: 80),
            if (!disable)
              FilledButton(
                  onPressed: () {
                    if (_keyState.currentState!.validate()) {
                      ref.read(profileDetailControllerProvider.notifier).update(
                          context,
                          file: _file,
                          user: user,
                          name: _name,
                          phoneNumber: _phoneNumber);
                    }
                  },
                  child: BText(
                    'Save',
                    color: ColorManager.white,
                  ))
          ],
        ),
      );
    });
  }
}
