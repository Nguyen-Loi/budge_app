import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin FloatingActionMixin<T extends StatefulWidget>
    on State<T> {
  void _onNewTransaction() async {
      final container = ProviderScope.containerOf(context);
    if (container.read(budgetBaseControllerProvider).isEmpty) {
      BDialogInfo(
        message: context.loc.youMustCreateAtLeastOneBudget,
        dialogInfoType: BDialogInfoType.warning,
      ).presentAction(
        context,
        onSubmit: () {
          Navigator.pushNamed(context, RoutePath.newBudget);
        },
        textSubmit: context.loc.navigateToIt,
      );
    } else {
      Navigator.pushNamed(context, RoutePath.newTransaction);
    }
  }

  Widget buildFloatingActionButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(100),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: _onNewTransaction,
          child: Center(
            child: Icon(
              IconManager.add,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
