import 'package:budget_app/common/table_constant.dart';
import 'package:budget_app/models/base_model.dart';
import 'package:budget_app/models/budget_transaction_model.dart';

class Combinemodel {
  static List<T> combineModels<T extends BaseModel>(
      List<T> listParent, List<BudgetTransactionModel> listChild) {
    Map<String, T> modelMap = {};

    for (var model in listParent) {
      modelMap[model.id] = model;
    }

    for (var transaction in listChild) {
      T? model = modelMap[transaction.budgetId];
      if (model != null) {
        model.data[TableConstant.budgetTransaction] ??= [];
        (model.data[TableConstant.budgetTransaction]
                as List<BudgetTransactionModel>)
            .add(transaction);
      }
    }

    return modelMap.values.toList();
  }
}
