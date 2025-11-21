import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/budget_view/budget_detail_view/controller/budget_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final budgetModifyControllerProvider = NotifierProvider.autoDispose
    .family<BudgetModifyController, void, String>(
  (budgetId) {
    return BudgetModifyController(budgetId: budgetId);
  },
);

class BudgetModifyController extends Notifier<void> {
  late BudgetRepository _budgetRepository;
  late BudgetDetailController _budgetDetailController;
  final String budgetId;
  late BudgetModel budgetDetail;

  BudgetModifyController({
    required this.budgetId,
  });

  @override
  void build() {
    _budgetRepository = ref.watch(budgetRepositoryProvider);
    _budgetDetailController =
        ref.watch(budgetDetailControllerProvider(budgetId).notifier);
    budgetDetail = _budgetDetailController.state;
  }

  void updateBudget(BuildContext context,
      {required String budgetName,
      required String iconName,
      required int limit,
      required DatetimeRangeModel dateTimeRange}) async {
    final now = DateTime.now();
    final budgetModify = budgetDetail.copyWith(
        name: budgetName,
        iconName: iconName,
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
    }, (_) {
      _budgetDetailController.updateState(budgetModify);
      Navigator.pop(context);
    });
  }
}
