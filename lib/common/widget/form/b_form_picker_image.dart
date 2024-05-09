import 'dart:io';

import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/type_def.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BFormPickerImage extends FormField<File> {
  final OnChangeImage onChanged;
  final double size;
  final bool disable;
  final String? initialUrl;

  BFormPickerImage(
      {super.key,
      required this.onChanged,
      this.size = 40,
      this.disable = false,
      this.initialUrl})
      : super(builder: (field) {
          final _BFormPickerImage state = field as _BFormPickerImage;
          return SizedBox(
            height: 80,
            child: InkWell(
              onTap: disable ? null : state.onTap,
              child: Ink(
                decoration: disable
                    ? null
                    : BoxDecoration(
                        color: ColorManager.grey2,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state.image(),
                    if (field.hasError) gapH16,
                    if (field.hasError)
                      Text(
                        field.errorText ?? 'Invalid',
                        style: Theme.of(field.context)
                            .inputDecorationTheme
                            .errorStyle,
                      )
                  ],
                ),
              ),
            ),
          );
        });

  @override
  FormFieldState<File> createState() {
    return _BFormPickerImage();
  }
}

class _BFormPickerImage extends FormFieldState<File> {
  @override
  BFormPickerImage get widget => super.widget as BFormPickerImage;

  @override
  void initState() {
    if (widget.initialUrl != null) {
      super.setValue(File(''));
    }
    super.initState();
  }

  Widget image() {
    bool startFileEmpty = super.value!.path.isEmpty;
    return widget.initialUrl != null && startFileEmpty
        ? _showImageNetwork()
        : super.value == null
            ? _showImageEmpty()
            : _showImageFile();
  }

  Widget _showImageEmpty() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(IconManager.galley, size: 30),
        gapW16,
        BText(context.loc.noImage)
      ],
    );
  }

  Widget _showImageNetwork() {
    return BAvatar.network(
      widget.initialUrl!,
      size: widget.size,
    );
  }

  Widget _showImageFile() {
    return CircleAvatar(
      radius: widget.size,
      child: Image.file(
        super.value!,
        fit: BoxFit.contain,
      ),
    );
  }

  final ImagePicker picker = ImagePicker();

  void onTap() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 2000);
    if (image != null) {
      File file = File(image.path);
      super.didChange(file);
      widget.onChanged(file);
    }
  }
}
