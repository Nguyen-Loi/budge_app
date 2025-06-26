import 'dart:io';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_avatar_profile.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/common/widget/form/b_form_field_phone_number.dart';
import 'package:budget_app/common/widget/form/b_form_field_text.dart';
import 'package:budget_app/common/widget/form/b_form_picker_image.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_validate.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/profile_view/controller/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  String? _name;
  File? _file;
  PhoneNumber? _phoneNumber;
  final _keyState = GlobalKey<FormState>();

  bool _hasChanges(UserModel user) {
    final nameChanged = _name != null && _name != user.name;
    final phoneChanged = _phoneNumber != user.phoneNumber;
    final imageChanged = _file != null;

    return nameChanged || phoneChanged || imageChanged;
  }

  @override
  void initState() {
    UserModel user = ref.read(userBaseControllerProvider);
    _phoneNumber = user.phoneNumber;
    _name = user.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseView(
          title: context.loc.myAccount,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildProfileContent().responsiveCenter(),
          )),
    );
  }

  Widget _buildProfileContent() {
    return Consumer(builder: (_, ref, __) {
      final user = ref.watch(userBaseControllerProvider);
      final isLoading = ref.watch(
          profileControllerProvider.select((state) => state is AsyncLoading));
      final disable =
          ref.watch(profileControllerProvider.select((state) => state));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(ref, disable, isLoading),
          gapH24,
          _buildProfileCard(user, disable, isLoading, ref),
          gapH32,
          if (!disable) _buildActionButtons(ref, user, isLoading),
        ],
      );
    });
  }

  Widget _buildHeader(WidgetRef ref, bool disable, bool isLoading) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(ref.read(userBaseControllerProvider).email,
                    fontWeight: FontWeight.w600),
                gapH4,
                BText.caption(
                  disable
                      ? context.loc.readModeOnly
                      : context.loc.editModeActive,
                  color: disable ? ColorManager.grey : ColorManager.primaryBlue,
                ),
              ],
            ),
            _buildToggleButton(ref, disable, isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(WidgetRef ref, bool disable, bool isLoading) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : OutlinedButton.icon(
              key: ValueKey(disable),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                ref
                    .read(profileControllerProvider.notifier)
                    .updateDisable(!disable);
              },
              icon: Icon(
                disable ? Icons.edit : Icons.lock,
                size: 18,
              ),
              label: BText.caption(
                disable ? context.loc.modify : context.loc.protected,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    disable ? ColorManager.primaryBlue : ColorManager.grey,
              ),
            ),
    );
  }

  Widget _buildProfileCard(
      UserModel user, bool disable, bool isLoading, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: AbsorbPointer(
        absorbing: disable || isLoading,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _keyState,
            child: Column(
              children: [
                _buildProfileImageSection(user, disable),
                gapH32,
                _buildFormFields(user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection(UserModel user, bool disable) {
    return Column(
      children: [
        Stack(
          children: [
            BFormPickerImage(
              initialUrl: user.profileUrl,
              disable: disable || kIsWeb,
              onChanged: (f) {
                setState(() {
                  _file = f;
                });
              },
              empty: BAvatarProfile(
                  url: user.profileUrl, username: user.name, size: 40),
            ),
            if (!disable && !kIsWeb)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorManager.primaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormFields(UserModel user) {
    return ColumnWithSpacing(
      spacing: 20,
      children: [
        _buildFormField(
          child: BFormFieldText.init(
            label: context.loc.name,
            initialValue: _name,
            validator: (v) => v.validateName(context),
            onChanged: (v) {
              setState(() {
                _name = v;
              });
            },
            prefixIcon: IconManager.account,
          ),
        ),
        _buildFormField(
          child: BFormFieldPhoneNumber(
            initialValue: _phoneNumber,
            validator: (v) => v.validatePhoneNumber(context),
            onInputChanged: (PhoneNumber value) {
              setState(() {
                _phoneNumber = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildActionButtons(WidgetRef ref, UserModel user, bool isLoading) {
    final hasChanges = _hasChanges(user);

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: (isLoading || !hasChanges)
                ? null
                : () {
                    // Unfocus immediately when button is pressed
                    FocusScope.of(context).requestFocus(FocusNode());
                    _handleSave(ref, user);
                  },
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save),
            label: BText(
              isLoading ? "Saving..." : context.loc.save,
              color: (isLoading || !hasChanges)
                  ? ColorManager.grey
                  : ColorManager.white,
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor:
                  (isLoading || !hasChanges) ? ColorManager.grey : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isLoading ? null : () => _handleCancel(ref),
            icon: const Icon(Icons.cancel_outlined),
            label: BText.b1(context.loc.cancel),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSave(WidgetRef ref, dynamic user) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_keyState.currentState!.validate()) {
      ref.read(profileControllerProvider.notifier).update(
            context,
            file: _file,
            user: user,
            name: _name ?? user.name,
            phoneNumber:
                _phoneNumber ?? PhoneNumber(phoneNumber: user.phoneNumber),
          );
    } else {
      showSnackBarError(context, context.loc.errorValidateForm);
    }
  }

  void _handleCancel(WidgetRef ref) {
    FocusScope.of(context).requestFocus(FocusNode());
    ref.read(profileControllerProvider.notifier).updateDisable(true);
    _keyState.currentState?.reset();

    // Reset tracking variables and trigger rebuild
    setState(() {
      final user = ref.read(userBaseControllerProvider);
      _name = user.name;
      _file = null;
      _phoneNumber = user.phoneNumber;
    });
  }
}
