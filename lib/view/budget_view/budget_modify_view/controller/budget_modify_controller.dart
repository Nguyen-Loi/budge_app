import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/controller/budget_detail_controller.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetModifyControllerProvider =
    Provider.family<BudgetModifyController, BudgetModel>((ref, budgetModel) {
  final budgetRepository = ref.watch(budgetRepositoryProvider);
  final uid = ref.watch(uidControllerProvider);
  final budgetDetailController =
      ref.watch(budgetDetailControllerProvider(budgetModel).notifier);
  return BudgetModifyController(
      budgetRepository: budgetRepository,
      uid: uid,
      budgetDetailController: budgetDetailController);
});

class BudgetModifyController extends StateNotifier<void> {
  final BudgetRepository _budgetRepository;
  final BudgetDetailController _budgetDetailController;

  BudgetModifyController(
      {required BudgetRepository budgetRepository,
      required String uid,
      required BudgetDetailController budgetDetailController})
      : _budgetRepository = budgetRepository,
        _budgetDetailController = budgetDetailController,
        super(null);

  void updateBudget(BuildContext context,
      {required BudgetModel budget,
      required int iconId,
      required int limit,
      required DatetimeRangeModel dateTimeRange}) async {
    final now = DateTime.now();
    final budgetModify = budget.copyWith(
        iconId: iconId,
        budgetLimit: limit,
        updatedDate: now,
        startDate: dateTimeRange.startDate,
        endDate: dateTimeRange.endDate,
        rangeDateTimeTypeValue: dateTimeRange.rangeDateTimeType.value);

    final closeDialog = showLoading(context: context);
    final res = await _budgetRepository.updateBudget(model: budgetModify);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      _budgetDetailController.updateState(budgetModify);
      Navigator.pop(context);
    });
  }
}
