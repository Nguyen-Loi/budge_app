// import 'package:budget_app/apis/transaction_api.dart';
// import 'package:budget_app/common/widget/dialog/b_loading.dart';
// import 'package:budget_app/core/enums/transaction_type_enum.dart';
// import 'package:budget_app/core/gen_id.dart';
// import 'package:budget_app/core/utils.dart';
// import 'package:budget_app/localization/app_localizations_context.dart';
// import 'package:budget_app/models/transaction_model.dart';
// import 'package:budget_app/view/home_page/controller/uid_controller.dart';
// import 'package:budget_app/view/home_page/widgets/home_budget_list/controller/budget_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final expenseControllerProvider = Provider<NewExpenseController>((ref) {
//   final transactionApi = ref.watch(transactionApiProvider);
//   final budgetsCurMonthController =
//       ref.watch(budgetsCurMonthControllerProvider.notifier);
//   final uid = ref.watch(uidControllerProvider);
//   return NewExpenseController(
//       transactionApi: transactionApi,
//       uid: uid,
//       budgetController: budgetsCurMonthController);
// });

// class NewExpenseController extends StateNotifier<bool> {
//   final TransactionApi _transactionApi;
//   final BudgetController _budgetController;
//   final String _uid;
//   NewExpenseController(
//       {required TransactionApi transactionApi,
//       required String uid,
//       required BudgetController budgetController})
//       : _transactionApi = transactionApi,
//         _budgetController = budgetController,
//         _uid = uid,
//         super(false);

//   void addMoneyExpense(BuildContext context,
//       {required String budgetId,
//       required int amount,
//       required String? note}) async {
   

//     final now = DateTime.now();
//     final newTransaction = TransactionModel(
//         id: GenId.income,
//         budgetId: budgetId,
//         amount: amount,
//         note: note ?? '',
//         transactionTypeValue: TransactionType.decrease.value,
//         createdDate: now,
//         transactionDate: now,
//         updatedDate: now);
//     final closeDialog = showLoading(context: context);
//     final res = await _transactionApi.add(_uid, transaction: newTransaction);

//     if (res.isLeft() && context.mounted) {
//       closeDialog();
//       showSnackBar(context, context.loc.anErrorUnexpectedOccur);
//       return;
//     }

//     await _budgetController.updateAddAmountItemBudget(
//         budgetId: budgetId, amount: amount);

  
//     closeDialog();

//     res.fold((l) {
//       showSnackBar(context, l.message);
//     }, (r) {
//       Navigator.pop(context);
//     });
//   }
// }
