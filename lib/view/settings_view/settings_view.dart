import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/shared_pref/theme_controller.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
        title: context.loc.settings,
        child: ListViewWithSpacing(
          children: [
            _themeSwitch(context),
            _languageDropdown(context),
          ],
        ));
  }

  Widget _themeSwitch(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      return SwitchListTile(
          title: BText(context.loc.darkMode),
          value: ref.watch(isDarkControllerProvider),
          onChanged: (_) {
            ref.read(isDarkControllerProvider.notifier).toggleTheme();
          });
    });
  }

  Widget _languageDropdown(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      return ListTile(
        title: BText(context.loc.language),
        trailing: DropdownButton<LanguageEnum>(
            value: ref.watch(languageControllerProvider),
            items: LanguageEnum.values
                .map((e) => DropdownMenuItem<LanguageEnum>(
                    value: e,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          e.svgAsset,
                          width: 80,
                          height: 80,
                        ),
                        gapW16,
                        BText(e.name)
                      ],
                    )))
                .toList(),
            onChanged: (e) {
              ref.read(languageControllerProvider.notifier).updateLanguage(e!);
            }),
      );
    });
  }
}
