class FireStorePath {
  static const String _budget = 'Budget';
  static const String _budgetTransaction = 'BudgetTransaction';
  static const String _goal = 'Goal';
  static const String _goalTransaction = 'GoalTransaction';
  static const String _user = 'User';

  static String users() => _user;
  static String user(String uid) => '$_user/$uid';

  static String budgets({required String uid}) => '$user/$uid/$_budget';
  static String budget({required String uid,required String budgetId}) => '$user/$uid/$_budget/$budgetId';
  static String budgetTransactions({required String uid, required String budgetId}) => '$user/$uid/$_budget/$budgetId/$_budgetTransaction';
  
  static String goals({required String uid}) => '$user/$uid/$_goal';
  static String goal({required String uid,required String goalId}) => '$user/$uid/$_goal/$goalId';
  static String goalTransactions({required String uid, required String goalId}) => '$user/$uid/$_goal/$goalId/$_goalTransaction';
}
