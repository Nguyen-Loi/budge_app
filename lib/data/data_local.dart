import 'dart:math';

import 'package:budget_app/core/enums/account_type_enum.dart';
import 'package:budget_app/core/enums/currency_type_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/models/budget_transaction_model.dart';
import 'package:budget_app/models/goal_model.dart';
import 'package:budget_app/models/goal_transaction_model.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:faker/faker.dart';

var faker = Faker();
Random random = Random();

class DataLocal {
  static UserModel get userModel => _userModel;
  static GoalModel get goalUrgent => _goalUrent;
  static List<BudgetModel> get budgets => _bugets;
  static List<BudgetTransactionModel> get budgetTransactions =>
      _budgetTransactions;
  static List<GoalModel> get goals => _goals;
  static List<GoalTransactionModel> get goalTransactions => _goalTransactions;

  static final UserModel _userModel = UserModel(
      userId: '1',
      email: 'tester@gmail.com',
      profileUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/010/265/384/small_2x/cute-happy-3d-robot-png.png',
      name: 'test',
      accountType: AccountType.emailAndPassword,
      currencyType: CurrencyType.vnd,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now());

  static final List<BudgetModel> _bugets = [
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 1,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 2,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 3,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 4,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 5,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 6,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    BudgetModel(
      id: '1',
      userId: '1',
      name: faker.food.restaurant(),
      iconId: 7,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      transactions: _budgetTransactions,
      startDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      endDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    )
  ];

  static final List<BudgetTransactionModel> _budgetTransactions = [
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.income,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025)),
    BudgetTransactionModel(
        id: '1',
        amount: random.nextInt(100000) + 1000,
        note: faker.lorem.sentence(),
        transactionType: TransactionType.expense,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025))
  ];

  static final GoalModel _goalUrent = GoalModel(
      userId: '1',
      name: '_',
      iconId: 15,
      currentAmount: random.nextInt(2000000) + 1000,
      limit: random.nextInt(10000000) + 1000,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      transactions: _goalTransactions);

  static final List<GoalModel> _goals = [
    GoalModel(
        userId: '1',
        name: faker.animal.name(),
        iconId: 10,
        currentAmount: random.nextInt(2000000) + 1000,
        limit: random.nextInt(10000000) + 1000,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        transactions: _goalTransactions),
    GoalModel(
        userId: '1',
        name: faker.animal.name(),
        iconId: 11,
        currentAmount: random.nextInt(2000000) + 1000,
        limit: random.nextInt(10000000) + 1000,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        transactions: _goalTransactions),
    GoalModel(
        userId: '1',
        name: faker.animal.name(),
        iconId: 12,
        currentAmount: random.nextInt(2000000) + 1000,
        limit: random.nextInt(10000000) + 1000,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        transactions: _goalTransactions),
    GoalModel(
        userId: '1',
        name: faker.animal.name(),
        iconId: 13,
        currentAmount: random.nextInt(2000000) + 1000,
        limit: random.nextInt(10000000) + 1000,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        transactions: _goalTransactions),
    GoalModel(
        userId: '1',
        name: faker.animal.name(),
        iconId: 14,
        currentAmount: random.nextInt(2000000) + 1000,
        limit: random.nextInt(10000000) + 1000,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        transactions: _goalTransactions),
    GoalModel(
        userId: '1',
        name: faker.animal.name(),
        iconId: 15,
        currentAmount: random.nextInt(2000000) + 1000,
        limit: random.nextInt(10000000) + 1000,
        createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
        transactions: _goalTransactions)
  ];

  static final List<GoalTransactionModel> _goalTransactions = [
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
    GoalTransactionModel(
      goalId: '1',
      amount: random.nextInt(100000) + 1000,
      note: faker.lorem.sentence(),
      transactionType: TransactionType.income,
      createdDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
      updatedDate: faker.date.dateTime(minYear: 2000, maxYear: 2025),
    ),
  ];
}
