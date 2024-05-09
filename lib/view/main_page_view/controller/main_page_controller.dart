import 'package:budget_app/common/log.dart';
import 'package:budget_app/view/base_controller/budget_base_controller.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainPageControllerProvider = Provider((ref) {
  final userController = ref.watch(userBaseControllerProvider.notifier);
  final budgetController = ref.watch(budgetBaseControllerProvider.notifier);
  final transactionController =
      ref.watch(transactionsBaseControllerProvider.notifier);
  return MainPageController(
      userController: userController,
      budgetController: budgetController,
      transactionController: transactionController);
});

final mainPageFutureProvider = FutureProvider((ref) {
  final controller = ref.watch(mainPageControllerProvider);
  return controller.loadBaseData();
});

class MainPageController extends StateNotifier<void> {
  final UserBaseController _userController;
  final BudgetBaseController _budgetController;
  final TransactionsBaseController _transactionsController;

  MainPageController(
      {required UserBaseController userController,
      required BudgetBaseController budgetController,
      required TransactionsBaseController transactionController})
      : _userController = userController,
        _budgetController = budgetController,
        _transactionsController = transactionController,
        super(null);

  Future<void> loadBaseData() async {
    logInfo('Loading infomation user....');
    await _userController.fetchUserInfo();
    logInfo('Loading infomation budget...');
    await _budgetController.fetch();
    logInfo('Loading infomation transactions...');
    await _transactionsController.fetch();
  }
}
