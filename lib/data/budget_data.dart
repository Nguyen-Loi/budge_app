import 'package:budget_app/common/table_constant.dart';
import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/models/budget_model.dart';

class BudgetData {
  static List<BudgetModel> listItem = [
    BudgetModel({
      FieldConstants.name: 'Shopping1',
      FieldConstants.iconId: 1,
      FieldConstants.limit: 100,
      FieldConstants.currentAmount: 100,
      TableConstant.budgetTransaction: []
    }),
    BudgetModel({
      FieldConstants.name: 'Shopping2',
      FieldConstants.iconId: 2,
      FieldConstants.limit: 200,
      FieldConstants.currentAmount: 300,
      TableConstant.budgetTransaction: []
    }),
    BudgetModel({
      FieldConstants.name: 'Shopping3',
      FieldConstants.iconId: 3,
      FieldConstants.limit: 300,
      FieldConstants.currentAmount: 100,
      TableConstant.budgetTransaction: []
    }),
    BudgetModel({
      FieldConstants.name: 'Shopping4',
      FieldConstants.iconId: 4,
      FieldConstants.limit: 400,
      FieldConstants.currentAmount: 200,
      TableConstant.budgetTransaction: []
    }),
    BudgetModel({
      FieldConstants.name: 'Shopping5',
      FieldConstants.iconId: 5,
      FieldConstants.limit: 500,
      FieldConstants.currentAmount: 200,
      TableConstant.budgetTransaction: []
    })
  ];
  static BudgetModel item = BudgetModel({
    FieldConstants.name: 'Shopping',
    FieldConstants.iconId: 1,
    FieldConstants.limit: 300,
    FieldConstants.currentAmount: 200,
    TableConstant.budgetTransaction: [
      {
        "id": "66011de6e2ac9b172b9ce00e",
        "budgetId": 1,
        "amount": 5791,
        "description": "Singleton Wise",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 28)
      },
      {
        "id": "66011de6001e1f1cc0faa7fb",
        "budgetId": 1,
        "amount": 8330,
        "description": "Gomez Ingram",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 27)
      },
      {
        "id": "66011de6f905cdaf2ecfba28",
        "budgetId": 1,
        "amount": 9730,
        "description": "Murphy Dillard",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 26)
      },
      {
        "id": "66011de67917ea608fa98533",
        "budgetId": 1,
        "amount": 16556,
        "description": "Camacho Gregory",
        "transactionType": 1,
        "createdAt": DateTime(2024, 03, 27)
      },
      {
        "id": "66011de664e08bdc5eb7213f",
        "budgetId": 1,
        "amount": 161,
        "description": "Buckley Mckinney",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 20)
      },
      {
        "id": "66011de62993d3ac858d91e0",
        "budgetId": 1,
        "amount": 16456,
        "description": "Dean Lucas",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 01)
      },
      {
        "id": "66011de6968b672866d73f33",
        "budgetId": 1,
        "amount": 7497,
        "description": "Marina Burks",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 02)
      },
      {
        "id": "66011de60bc1fb6e83b95f9a",
        "budgetId": 1,
        "amount": 17468,
        "description": "Case Armstrong",
        "transactionType": 1,
        "createdAt": DateTime(2024, 03, 08)
      },
      {
        "id": "66011de6c7da15fa651a1e2d",
        "budgetId": 1,
        "amount": 13488,
        "description": "Kris Harrington",
        "transactionType": 1,
        "createdAt": DateTime(2022, 03, 28)
      },
      {
        "id": "66011de64ab6b1f32296518b",
        "budgetId": 1,
        "amount": 9960,
        "description": "Marisol Emerson",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 21)
      },
      {
        "id": "66011de6ab2f244a2977f34b",
        "budgetId": 1,
        "amount": 10173,
        "description": "Pam Wilkerson",
        "transactionType": 1,
        "createdAt": DateTime(2024, 03, 25)
      },
      {
        "id": "66011de6b2aa465bc59bb67f",
        "budgetId": 1,
        "amount": 1128,
        "description": "Morse Donaldson",
        "transactionType": 2,
        "createdAt": DateTime(2024, 03, 27)
      }
    ]
  });
}
