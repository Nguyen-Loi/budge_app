import 'package:budget_app/common/shared_pref/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class BPickerMonthDialog {
  BPickerMonthDialog._();
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final container = ProviderScope.containerOf(context);
    final languageCode = container.read(languageControllerProvider).code;

    return await showMonthPicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate ?? DateTime.now(),
      monthPickerDialogSettings: MonthPickerDialogSettings(
        headerSettings: PickerHeaderSettings(
          titleSpacing: 1,
          hideHeaderRow: true,
          headerSelectedIntervalTextStyle:
              Theme.of(context).textTheme.titleMedium!.copyWith(),
        ),
        dialogSettings: PickerDialogSettings(
          locale: Locale(languageCode),
        ),
      ),
    );
  }
}
