import 'package:budget_app/core/enums/budget_type_enum.dart';
import 'package:budget_app/core/enums/range_date_time_enum.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/providers.dart';
import 'package:budget_app/data/datasources/apis/user_api.dart';
import 'package:budget_app/data/datasources/offline/budget_local.dart';
import 'package:budget_app/data/datasources/offline/transaction_local.dart';
import 'package:budget_app/data/datasources/offline/user_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/data/models/budget_model.dart';
import 'package:budget_app/data/models/transaction_model.dart';
import 'package:budget_app/data/datasources/transfer_data_source.dart';
import 'package:budget_app/core/type_defs.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'transfer_data_integration_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserLocal>(),
  MockSpec<UserApi>(),
  MockSpec<BudgetLocal>(),
  MockSpec<TransactionLocal>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<Ref>(),
])
void main() {
  late MockUserLocal userLocal;
  late MockUserApi userApi;
  late MockBudgetLocal budgetLocal;
  late MockTransactionLocal transactionLocal;
  late MockFirebaseFirestore firestore;
  late MockRef ref;
  late UserModel testUser;
  late List<BudgetModel> testBudgets;
  late List<TransactionModel> testTransactions;

  setUp(() {
    userLocal = MockUserLocal();
    userApi = MockUserApi();
    budgetLocal = MockBudgetLocal();
    transactionLocal = MockTransactionLocal();
    firestore = MockFirebaseFirestore();
    ref = MockRef();
    Uuid uuid = const Uuid();
    testUser = UserModel.defaultData().copyWith(id: 'test_uid', balance: 100);
    String testUserId = uuid.v4();

    // --- Test Budgets ---
    List<BudgetModel> testBudgets = [
      BudgetModel(
        id: uuid.v4(),
        userId: testUserId,
        name: "Groceries",
        iconId: 1,
        currentAmount: 150,
        budgetLimit: 400,
        budgetTypeValue: BudgetTypeEnum.income.value,
        rangeDateTimeTypeValue: RangeDateTimeEnum.week.value,
        startDate: DateTime(2024, 5, 1),
        endDate: DateTime(2024, 5, 31),
        createdDate: DateTime.now().subtract(Duration(days: 10)),
        updatedDate: DateTime.now().subtract(Duration(days: 1)),
      ),
      BudgetModel(
        id: uuid.v4(),
        userId: testUserId,
        name: "Entertainment",
        iconId: 2,
        currentAmount: 75,
        budgetLimit: 200,
        budgetTypeValue: BudgetTypeEnum.income.value,
        rangeDateTimeTypeValue: RangeDateTimeEnum.week.value,
        startDate: DateTime(2024, 5, 1),
        endDate: DateTime(2024, 5, 31),
        createdDate: DateTime.now().subtract(Duration(days: 15)),
        updatedDate: DateTime.now().subtract(Duration(days: 3)),
      ),
      BudgetModel(
        id: uuid.v4(),
        userId: testUserId,
        name: "Transport",
        iconId: 3,
        currentAmount: 50,
        budgetLimit: 100,
        budgetTypeValue: BudgetTypeEnum.income.value,
        rangeDateTimeTypeValue: RangeDateTimeEnum.week.value,
        startDate: DateTime(2024, 5, 20),
        endDate: DateTime(2024, 5, 26),
        createdDate: DateTime.now().subtract(Duration(days: 5)),
        updatedDate: DateTime.now().subtract(Duration(days: 2)),
      ),
      BudgetModel(
        id: uuid.v4(),
        userId: uuid.v4(), //
        name: "Holiday Fund",
        iconId: 4,
        currentAmount: 1250,
        budgetLimit: 5000,
        budgetTypeValue: BudgetTypeEnum.income.value,
        rangeDateTimeTypeValue: RangeDateTimeEnum.week.value,
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),
        createdDate: DateTime.now().subtract(Duration(days: 100)),
        updatedDate: DateTime.now().subtract(Duration(days: 10)),
      ),
    ];

    String groceriesBudgetId = testBudgets[0].id;
    String entertainmentBudgetId = testBudgets[1].id;
    String transportBudgetId = testBudgets[2].id;
    String holidayBudgetId = testBudgets[3].id;

    List<TransactionModel> testTransactions = [
      TransactionModel(
        id: uuid.v4(),
        userId: testUserId,
        budgetId: groceriesBudgetId,
        amount: 55,
        note: "Weekly shop at Tesco",
        transactionTypeValue: TransactionTypeEnum.expenseBudget.value,
        createdDate: DateTime.now().subtract(Duration(days: 2)),
        transactionDate: DateTime(2024, 5, 18),
        updatedDate: DateTime.now().subtract(Duration(days: 2)),
      ),
      TransactionModel(
        id: uuid.v4(),
        userId: testUserId,
        budgetId: groceriesBudgetId,
        amount: 30,
        note: "Fruits and Veg",
         transactionTypeValue: TransactionTypeEnum.expenseBudget.value,
        createdDate: DateTime.now().subtract(Duration(days: 1)),
        transactionDate: DateTime(2024, 5, 19),
        updatedDate: DateTime.now().subtract(Duration(days: 1)),
      ),
      TransactionModel(
        id: uuid.v4(),
        userId: testUserId,
        budgetId: entertainmentBudgetId,
        amount: 25,
        note: "Cinema tickets",
        transactionTypeValue: TransactionTypeEnum.expenseBudget.value,
        createdDate: DateTime.now().subtract(Duration(days: 5)),
        transactionDate: DateTime(2024, 5, 15),
        updatedDate: DateTime.now().subtract(Duration(days: 5)),
      ),
      TransactionModel(
        id: uuid.v4(),
        userId: testUserId,
        budgetId: transportBudgetId,
        amount: 10,
        note: "Bus fare",
        transactionTypeValue: TransactionTypeEnum.expenseBudget.value,
        createdDate: DateTime.now().subtract(Duration(days: 1)),
        transactionDate: DateTime(2024, 5, 20),
        updatedDate: DateTime.now().subtract(Duration(days: 1)),
      ),
      TransactionModel(
        id: uuid.v4(),
        userId: testUserId,
        budgetId:
            groceriesBudgetId,
        amount: 1500,
        note: "Monthly Salary",
        transactionTypeValue: TransactionTypeEnum.incomeBudget.value,
        createdDate: DateTime.now().subtract(Duration(days: 20)),
        transactionDate: DateTime(2024, 5, 1),
        updatedDate: DateTime.now().subtract(Duration(days: 20)),
      ),
      TransactionModel(
        id: uuid.v4(),
        userId: testBudgets[3].userId,
        budgetId: holidayBudgetId,
        amount: 200,
        note: "Saved for vacation",
        transactionTypeValue: TransactionTypeEnum
            .incomeBudget.value, 
        createdDate: DateTime.now().subtract(Duration(days: 7)),
        transactionDate: DateTime(2024, 5, 13),
        updatedDate: DateTime.now().subtract(Duration(days: 7)),
      ),
    ];

    // Setup provider reads
    when(ref.read(userLocalProvider)).thenReturn(userLocal);
    when(ref.read(userApiProvider)).thenReturn(userApi);
    when(ref.read(budgetLocalProvider)).thenReturn(budgetLocal);
    when(ref.read(transactionLocalProvider)).thenReturn(transactionLocal);
    when(ref.read(dbProvider)).thenReturn(firestore);
  });

  group('Integration: sqlite <-> firestore sync', () {
    test('Case 1: sqlite has data, firestore is empty, syncs to firestore',
        () async {
      // Arrange
      when(userLocal.getUserById(any)).thenAnswer((_) async => testUser);
      when(userApi.getUserById(any))
          .thenAnswer((_) async => UserModel.defaultData());
      when(budgetLocal.fetch(any)).thenAnswer((_) async => testBudgets);
      when(transactionLocal.fetchTransaction(any))
          .thenAnswer((_) async => testTransactions);
      // Firestore is empty, so validateSetup triggers sync

      // Act
      final result = await TransferData.sqliteToFirestore(ref,
          user: testUser, validateSetup: true);

      // Assert
      expect(result.isRight(), true);
      // Add more assertions to check that firestore received the correct data
    });

    test(
        'Case 2: sqlite and firestore both have data, user chooses NO (cancel)',
        () async {
      // Arrange
      when(userLocal.getUserById(any))
          .thenAnswer((_) async => testUser.copyWith(balance: 200));
      when(userApi.getUserById(any))
          .thenAnswer((_) async => testUser.copyWith(balance: 300));
      when(budgetLocal.fetch(any)).thenAnswer((_) async => testBudgets);
      when(transactionLocal.fetchTransaction(any))
          .thenAnswer((_) async => testTransactions);
      // Simulate firestore has data (isBudgetsChange = true)
      when(firestore.collection(any)).thenReturn(MockCollectionWithDocs());

      // Act
      final result = await TransferData.sqliteToFirestore(ref,
          user: testUser, validateSetup: true);

      // Assert
      expect(result.isLeft(), true); // Should cancel login
    });

    test(
        'Case 2: sqlite and firestore both have data, user chooses YES (replace sqlite with firestore)',
        () async {
      // Arrange
      // Simulate user chooses YES by calling _firestoreToSqlite directly
      when(firestore.collection(any)).thenReturn(MockCollectionWithDocs());
      // ...setup Firestore docs to return testUser, testBudgets, testTransactions...

      // Act
      final result =
          await TransferData._firestoreToSqlite(ref, userId: testUser.uid);

      // Assert
      expect(result.isRight(), true);
      // Add assertions to check that sqlite now matches firestore data
    });

    test(
        'Case 3: sqlite is empty, firestore has data, sqlite gets data from firestore',
        () async {
      // Arrange
      when(userLocal.getUserById(any))
          .thenAnswer((_) async => UserModel.defaultData());
      when(budgetLocal.fetch(any)).thenAnswer((_) async => []);
      when(transactionLocal.fetchTransaction(any)).thenAnswer((_) async => []);
      // Simulate firestore has data
      when(firestore.collection(any)).thenReturn(MockCollectionWithDocs());
      // ...setup Firestore docs to return testUser, testBudgets, testTransactions...

      // Act
      final result = await TransferData.sqliteToFirestore(ref,
          user: testUser, validateSetup: true);

      // Assert
      expect(result.isRight(), true);
      // Add assertions to check that sqlite now matches firestore data
    });
  });
}

// You will need to implement MockCollectionWithDocs and any other mocks for Firestore collections/docs as needed.
