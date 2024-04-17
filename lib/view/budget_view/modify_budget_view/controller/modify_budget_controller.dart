import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/b_datetime.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newBudgetControllerProvider = Provider((ref) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  final budgetController =
      ref.watch(budgetsCurMonthControllerProvider.notifier);
  return ModifyBudgetController(
      budgetApi: budgetApi, uid: uid, budgetController: budgetController);
});

class ModifyBudgetController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;
  final BudgetController _budgetController;
  final String _uid;

  ModifyBudgetController(
      {required BudgetApi budgetApi,
      required String uid,
      required BudgetController budgetController})
      : _budgetApi = budgetApi,
        _uid = uid,
        _budgetController = budgetController,
        super(false);

  void updateBudget(
    BuildContext context, {
    required BudgetModel budget,
    required int iconId,
    required int limit,
  }) async {
    final now = DateTime.now();
    final budgetModify =
        budget.copyWith(iconId: iconId, limit: limit, updatedDate: now);

    final closeDialog = showLoading(context: context);
    final res = await _budgetApi.updateBudget(model: budgetModify);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      _budgetController.addBudgetState(model);
      Navigator.pop(context);
    });
  }
}
