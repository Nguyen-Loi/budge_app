import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:budget_app/common/shared_pref/theme_controller.dart';
import 'package:budget_app/common/widget/b_switch_list_tile.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/language_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/view/base_controller/currency_base_controller.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
              _currencyDropdown(context, ref),
              _dailyTransactionReminderSwitch(context, ref),
              _asyncDb(context, ref),
              _openInBrowser(context),
            ],
          ).responsiveCenter();
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
            ref.watch(userBaseControllerProvider).isRemindTransactionEveryDate,
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

  Widget _currencyDropdown(BuildContext context, WidgetRef ref) {
    final currencyManager = ref.watch(currencyManagerProvider);
    final currentCurrency =
        ref.watch(userBaseControllerProvider.select((value) => value.currency));
    final supportedCurrencies = currencyManager.getSupportedCurrencies();

    return ListTile(
      title: BText(context.loc.currency),
      trailing: DropdownButton<CurrencyType>(
        value: currentCurrency,
        items: supportedCurrencies.map((currency) {
          return DropdownMenuItem<CurrencyType>(
            value: currency,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  height: 20,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(50),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: BText.b3(currency.symbol,
                      textAlign: TextAlign.center, fontWeight: FontWeight.w600),
                ),
                gapW8,
                BText(
                  currency.code,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (CurrencyType? newCurrency) {
          if (newCurrency != null) {
            ref
                .read(userBaseControllerProvider.notifier)
                .updateCurrency(context, newCurrency: newCurrency);
          }
        },
      ),
    );
  }

  Widget _openInBrowser(BuildContext context) {
    if (!kIsWeb) {
      return ListTile(
        title: BText(context.loc.openInBrowser),
        trailing: IconButton(
          icon: Icon(IconManager.openLink),
          onPressed: () {
            final url = 'https://budget-ss.web.app/';
            launchUrl(Uri.parse(url));
          },
        ),
      );
    }
    return const SizedBox();
  }

  Widget _asyncDb(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return const SizedBox();
    }
    return ListTile(
      title: BText(context.loc.syncLocalToCloud),
      trailing: IconButton(
        icon: Icon(IconManager.sync),
        onPressed: () async {
          if (!ref.read(userBaseControllerProvider.notifier).isLogin) {
            showBDialog(context,
                dialogInfoType: BDialogInfoType.error,
                message: context.loc.loginToUse);
            return;
          }
          ref.read(userBaseControllerProvider.notifier).transferData(context);
        },
      ),
    );
  }
}
