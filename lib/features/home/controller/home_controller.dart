import 'package:budget_app/constants/field_constants.dart';
import 'package:budget_app/models/budget_model.dart';

class HomeController {
  List<Map<String, dynamic>> list = [
    {
      FieldConstants.id: '123',
      FieldConstants.name: 'Accomodation',
      FieldConstants.currentAmount: 150,
      FieldConstants.startDate: DateTime.now(),
      FieldConstants.endDate: DateTime.now(),
      FieldConstants.limit: 200,
    },
    {
      FieldConstants.id: '123',
      FieldConstants.name: 'Data 2',
      FieldConstants.currentAmount: 5,
      FieldConstants.startDate: DateTime.now(),
      FieldConstants.endDate: DateTime.now(),
      FieldConstants.limit: 200,
    },
    {
      FieldConstants.id: '123',
      FieldConstants.name: 'Data 3',
      FieldConstants.currentAmount: 80,
      FieldConstants.startDate: DateTime.now(),
      FieldConstants.endDate: DateTime.now(),
      FieldConstants.limit: 200,
    },
    {
      FieldConstants.id: '123',
      FieldConstants.name: 'Data 4',
      FieldConstants.currentAmount: 200,
      FieldConstants.startDate: DateTime.now(),
      FieldConstants.endDate: DateTime.now(),
      FieldConstants.limit: 200,
    },
    {
      FieldConstants.id: '123',
      FieldConstants.name: 'Data 5',
      FieldConstants.currentAmount: 250,
      FieldConstants.startDate: DateTime.now(),
      FieldConstants.endDate: DateTime.now(),
      FieldConstants.limit: 200,
    }
  ];

  List<BudgetModel> get listBuget => list.map((e) => BudgetModel(e)).toList();
}
