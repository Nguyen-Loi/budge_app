import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/common/widget/dialog/b_loading.dart';
import 'package:budget_app/common/widget/dialog/b_snackbar.dart';
import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/gen_id.dart';
import 'package:budget_app/data/datasources/repositories/budget_repository.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/models_widget/datetime_range_model.dart';
import 'package:budget_app/view/base_controller/uid_controller.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newBudgetControllerProvider = NotifierProvider.autoDispose<NewBudgetController, bool>(NewBudgetController.new);
class NewBudgetController extends Notifier<bool> {
  late BudgetRepository _budgetRepository;
  late BudgetBaseController _budgetBaseController;
  late String _uid;

  @override
  bool build() {
    _uid = ref.watch(uidControllerProvider);
    _budgetBaseController = ref.watch(budgetBaseControllerProvider.notifier);
    _budgetRepository = ref.watch(budgetRepositoryProvider);
    return false;
  }

  String? _errorValidate(BuildContext context, {required String budgetName}) {
    List<BudgetModel> list = _budgetBaseController.getAll;
    final budgetExits = list.firstWhereOrNull((e) => e.id == budgetName);
    if (budgetExits != null) {
      return context.loc.pBudgetNameExits(budgetName);
    }
    return null;
  }

  void addBudget(BuildContext context,
      {required String budgetName,
      required String iconName,
      required int limit,
      required DatetimeRangeModel rangeDatetimeModel,
      required BudgetTypeEnum budgetType}) async {
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
      iconName: iconName,
      currentAmount: 0,
      budgetLimit: limit,
      createdDate: now,
      updatedDate: now,
      rangeDateTimeTypeValue: rangeDatetimeModel.rangeDateTimeType.value,
      startDate: rangeDatetimeModel.startDate,
      endDate: rangeDatetimeModel.endDate,
      budgetTypeValue: budgetType.value,
    );
    final closeDialog = showLoading(context: context);
    final res = await _budgetRepository.addBudget(model: model);
    closeDialog();
    res.fold((failure) {
      showSnackBar(context, failure.message);
    }, (r) {
      _budgetBaseController.addBudgetState(model);
      Navigator.pop(context);
    });
  }
  

}
