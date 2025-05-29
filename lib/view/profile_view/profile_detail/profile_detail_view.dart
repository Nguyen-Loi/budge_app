import 'dart:io';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/form/b_form_field_phone_number.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_image.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/profile_view/profile_detail/controller/profile_detail_controller.dart';
import 'package:flutter/foundation.dart';
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
  PhoneNumber? _phoneNumber;
  final _keyState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: context.loc.myAccount,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
          child: _form().responsiveCenter(),
        ));
  }

  Widget _form() {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userBaseControllerProvider);
      final disable = ref.watch(profileDetailControllerProvider);
      _name = user.name;
      _phoneNumber = user.phoneNumber;

      return Form(
        key: _keyState,
        child: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: OutlinedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    ref
                        .read(profileDetailControllerProvider.notifier)
                        .updateDisable(!disable);
                  },
                  child: disable
                      ? BText.caption(
                          context.loc.modify,
                        )
                      : BText.caption(context.loc.readOnly)),
            ),
            gapH16,
            BFormPickerImage(
                initialUrl: user.profileUrl,
                disable: disable || kIsWeb,
                onChanged: (f) {
                  _file = f;
                }),
            gapH24,
            ColumnWithSpacing(
              children: [
                BFormFieldText.init(
                    label: context.loc.email,
                    disable: true,
                    initialValue: user.email),
                BFormFieldText.init(
                  label: context.loc.name,
                  disable: disable,
                  initialValue: user.name,
                  validator: (v) => v.validateName(context),
                  onChanged: (v) {
                    _name = v;
                  },
                ),
                AbsorbPointer(
                  absorbing: disable,
                  child: BFormFieldPhoneNumber(
                    initialValue: user.phoneNumber,
                    validator: (v) => v.validatePhoneNumber(context),
                    onInputChanged: (PhoneNumber value) {
                      _phoneNumber = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            if (!disable)
              FilledButton(
                  onPressed: () {
                    if (_keyState.currentState!.validate()) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      ref.read(profileDetailControllerProvider.notifier).update(
                          context,
                          file: _file,
                          user: user,
                          name: _name,
                          phoneNumber: _phoneNumber!);
                    }
                  },
                  child: BText(
                    context.loc.save,
                    color: ColorManager.white,
                  ))
          ],
        ),
      );
    });
  }
}
