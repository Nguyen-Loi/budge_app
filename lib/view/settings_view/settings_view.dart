import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/shared_pref/theme_controller.dart';
import 'package:budget_app/common/widget/b_switch_list_tile.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
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
        child: Consumer(builder: (_, ref, __) {
          return ListViewWithSpacing(
            children: [
              _themeSwitch(context, ref),
              _languageDropdown(context, ref),
              if (ref.watch(userBaseControllerProvider) != null) ...[
                _dailyTransactionReminderSwitch(context, ref),
              ],
            ],
          );
        }));
  }

  Widget _themeSwitch(BuildContext context, WidgetRef ref) {
    return BSwitchListTile(
        title: context.loc.darkMode,
        value: ref.watch(isDarkControllerProvider),
        onChanged: (_) {
          ref.read(isDarkControllerProvider.notifier).toggleTheme();
        });
  }

  Widget _dailyTransactionReminderSwitch(BuildContext context, WidgetRef ref) {
    return BSwitchListTile(
        title: context.loc.dailyTransactionReminder,
        value:
            ref.watch(userBaseControllerProvider)!.isRemindTransactionEveryDate,
        onChanged: (value) {
          ref
              .read(userBaseControllerProvider.notifier)
              .toggleNotificationTransaction(context, isOn: value);
        });
        
  }

  Widget _languageDropdown(BuildContext context, WidgetRef ref) {
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
  }
}
