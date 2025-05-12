import 'package:budget_app/data/datasources/apis/budget_api.dart';
import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/home_page/controller/uid_controller.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newBudgetControllerProvider = Provider((ref) {
  final budgetApi = ref.watch(budgetAPIProvider);
  final uid = ref.watch(uidControllerProvider);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  return NewBudgetController(
      budgetApi: budgetApi, uid: uid, budgetController: budgetController);
});

class NewBudgetController extends StateNotifier<bool> {
  final BudgetApi _budgetApi;
  final BudgetBaseController _budgetBaseController;
  final String _uid;

  NewBudgetController(
      {required BudgetApi budgetApi,
      required String uid,
      required BudgetBaseController budgetController})
      : _budgetApi = budgetApi,
        _uid = uid,
        _budgetBaseController = budgetController,
        super(false);

  String? _errorValidate(BuildContext context, {required String budgetName}) {
    List<BudgetModel> list = _budgetBaseController.budgetAvailable;
    final budgetExits = list.firstWhereOrNull((e) => e.id == budgetName);
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
    required DatetimeRangeModel rangeDatetimeModel,
    required BudgetTypeEnum budgetType
  }) async {
    //Check valid
    String? error = _errorValidate(context, budgetName: budgetName);
    if (error != null) {
      showBDialogInfoError(context, message: error);
    }

    final now = DateTime.now();
    BudgetModel model = BudgetModel(
      id: GenId.budget(),
      userId: _uid,
      name: budgetName,
      iconId: iconId,
      currentAmount: 0,
      limit: limit,
      createdDate: now,
      updatedDate: now,
      rangeDateTimeTypeValue: rangeDatetimeModel.rangeDateTimeType.value,
      startDate: rangeDatetimeModel.startDate,
      endDate: rangeDatetimeModel.endDate,
      budgetTypeValue: budgetType.value,
    );
    final closeDialog = showLoading(context: context);
    final res = await _budgetApi.addBudget(model: model);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      _budgetBaseController.addBudgetState(model);
      Navigator.pop(context);
    });
  }
}
