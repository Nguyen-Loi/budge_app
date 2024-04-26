import 'package:budget_app/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/b_datetime.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetNewControllerProvider = Provider((ref) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  final budgetController =
      ref.watch(budgetsCurMonthControllerProvider.notifier);
  return BudgetNewController(
      budgetApi: budgetApi, uid: uid, budgetController: budgetController);
});

class BudgetNewController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;
  final BudgetController _budgetController;
  final String _uid;

  BudgetNewController(
      {required BudgetApi budgetApi,
      required String uid,
      required BudgetController budgetController})
      : _budgetApi = budgetApi,
        _uid = uid,
        _budgetController = budgetController,
        super(false);

  String? _errorValidate(BuildContext context,{required String budgetName}) {
    List<BudgetModel> list = _budgetController.state;
    final currentId = GenId.budget(budgetName);
    final budgetExits = list.firstWhereOrNull((e) => e.id == currentId);
    if (budgetExits != null) {
      return context.loc.pBudgetNameExits(budgetName);
    }
    return null;
  }

  void addBudget(
    BuildContext context, {
    required String budgetName,
    required int iconId,
    required int limit,
  }) async {
    //Check valid
    String? error = _errorValidate(context,budgetName: budgetName);
    if (error != null) {
      showBDialogInfoError(context, message: error);
    }

    final now = DateTime.now();
    BudgetModel model = BudgetModel(
      id: GenId.budget(budgetName),
      userId: _uid,
      name: budgetName,
      month: BDateTime.month(now),
      iconId: iconId,
      currentAmount: 0,
      budgetTypeValue: BudgetTypeEnum.budget.value,
      limit: limit,
      createdDate: now,
      updatedDate: now,
    );
    final closeDialog = showLoading(context: context);
    final res = await _budgetApi.addBudget(model: model);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      _budgetController.addBudgetState(model);
      Navigator.pop(context);
    });
  }
}
