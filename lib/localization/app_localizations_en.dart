// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get amount => 'Amount';

  @override
  String get amountInvalid => 'Amount invalid';

  @override
  String get amountHint => '0';

  @override
  String get note => 'Note';

  @override
  String get noteHint => 'Money from salary';

  @override
  String get date => 'Date';

  @override
  String get signIn => 'Sign In';

  @override
  String get welecomeBack => 'Welecome back!';

  @override
  String get signInDescription => 'Hey you\'re back, fill in your details to get back in';

  @override
  String get email => 'Email';

  @override
  String get orLoginWith => 'Or login with';

  @override
  String get signUp => 'Sign up';

  @override
  String get welecomeAppName => 'Welecome to Budget Application!';

  @override
  String get signUpToStart => 'Complete then sign up to get started';

  @override
  String get pleaseEnableService => 'Please enable our terms of service';

  @override
  String nEableServiceDescription(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errorText',
      one: 'Terms of Service and Privay Policy',
      zero: 'By the signing up, you agree to the  ',
    );
    return '$_temp0';
  }

  @override
  String get emailHint => 'peter@gmail.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => '*******';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get create => 'Create';

  @override
  String get transactions => 'Transactions';

  @override
  String get noData => 'No Data';

  @override
  String get noTransactionDescription => 'You don\'t have any transactions yet';

  @override
  String get monthlyExpense => 'Monthly Expense';

  @override
  String get noTransactionThisBudget => 'You don\'t have any transactions with this budget.';

  @override
  String get youAlreadySpent => 'You\'ve already spent';

  @override
  String get spendLimitPerMonth => 'Spend limit per Month';

  @override
  String get modifyBudget => 'Modify Budget';

  @override
  String get budgetName => 'Budget name';

  @override
  String get errorChooseYourBudgetIcon => 'Please choose your budget icon';

  @override
  String get chooseYourBudget => 'Choose your budget';

  @override
  String get errorChooseYourBudget => 'Please choose your budget';

  @override
  String get update => 'Update';

  @override
  String get newBudget => 'New Budget';

  @override
  String get budgetNameHint => 'Water';

  @override
  String get add => 'Add';

  @override
  String get limit => 'Limit';

  @override
  String get target => 'Target';

  @override
  String get thereAreNoTransactions => 'There are no transactions';

  @override
  String get yourAvailableBalanceIs => 'Your available balance is';

  @override
  String get financesGood => 'Your finances are looking good';

  @override
  String get newExpense => 'New expense';

  @override
  String get myAccount => 'My Account';

  @override
  String get modify => 'Modify';

  @override
  String get readOnly => 'Read Only';

  @override
  String get name => 'Name';

  @override
  String get save => 'Save';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get contact => 'Contact';

  @override
  String get signOut => 'Sign Out';

  @override
  String pUserJoinDescriptions(Object dateTime, Object numberMonth) {
    return 'You joined ViNho on $dateTime. It\'s been $numberMonth month since then and our mission is still the same and help you better manage your money';
  }

  @override
  String get home => 'Home';

  @override
  String get appName => 'Budget SS';

  @override
  String get left => 'Left';

  @override
  String get approaced => 'Approaced';

  @override
  String get exceeded => 'Exceeded';

  @override
  String get anErrorUnexpectedOccur => 'An error unexpected occur';

  @override
  String get errorUploadFiles => 'Error when upload files';

  @override
  String get errorUploadFile => '\'An error occur when upload image\'';

  @override
  String deleteTitle(Object obj) {
    return 'Delete $obj';
  }

  @override
  String deleteMessage(Object obj) {
    return 'Are you sure you want to delete this $obj?';
  }

  @override
  String get deleteUp => 'DELETE';

  @override
  String get cancelUp => 'CANCEL';

  @override
  String get errorUp => 'ERRROR';

  @override
  String get successUp => 'SUCCESS';

  @override
  String get close => 'Close';

  @override
  String get continueText => 'Continue';

  @override
  String get invalid => 'Invalid';

  @override
  String get noBudget => 'No budget available';

  @override
  String get textFieldHintDefault => 'Enter your text';

  @override
  String get chooseIcon => 'Choose icon';

  @override
  String get noImage => 'No Image';

  @override
  String get emailInvalid => 'Email Invalid';

  @override
  String get dataEmpty => 'Data Empty';

  @override
  String get phoneNumberInvalid => 'Phone number invalid';

  @override
  String get nameInvalid => 'Name invalid';

  @override
  String get passwordMininum6 => 'Password minimum is 6 characters';

  @override
  String get confirmPasswordInvalid => 'Confirm password invalid';

  @override
  String get accountCreatePleaseLogin => 'Account created! Please login';

  @override
  String nForgotPassword(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString errorText',
      one: ' password?',
      zero: 'Forgot',
    );
    return '$_temp0';
  }

  @override
  String pBudgetNameExits(String budgetName) {
    return 'Budget $budgetName already exist. Please change budget name and try again';
  }

  @override
  String get budgetEmpty => 'You don\'t have any budget yet.';

  @override
  String pExpensesExceedIncome(String money) {
    return 'Expenses exceed income ($money). Increase your income and try again';
  }

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get passwordTooWeak => 'The password provided is too weak.';

  @override
  String get emailAlreadyExits => 'The account already exists for that email.';

  @override
  String get errorSignInGoogle => 'Error occurred using Google Sign-In. Try again.';

  @override
  String get errorSignInFacebook => 'Error occurred using Facebook Sign-In. Try again.';

  @override
  String get accountAlreadyExits => 'The account already exists with a different credential.';

  @override
  String get errorCredentials => 'Error occurred while accessing credentials. Try again.';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password. Please try again.';

  @override
  String get walletInvalidMatches => 'The value matches the value currently';

  @override
  String get cancel => 'Cancel';

  @override
  String get dateRange => 'Date range';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String get budgetInUse => 'Budget in use';

  @override
  String get budgetExpired => 'Budget expired';

  @override
  String get budgetUtilized => 'Budget utilized';

  @override
  String get recentTransactions => 'Recent transactions';

  @override
  String get budget => 'Budget';

  @override
  String get transactionDate => 'Transaction date';

  @override
  String get updateBalance => 'Update balance';

  @override
  String get myWallet => 'My wallet';

  @override
  String get cash => 'Cash';

  @override
  String get createdDate => 'Created date';

  @override
  String get updatedDate => 'Updated date';

  @override
  String get balanceAdjustment => 'Balance adjustment';

  @override
  String pThisWeek(String dateStart, String dateEnd) {
    return 'This week ($dateStart - $dateEnd)';
  }

  @override
  String pThisMonth(String dateStart, String dateEnd) {
    return 'This month ($dateStart - $dateEnd)';
  }

  @override
  String pThisYear(String dateStart, String dateEnd) {
    return 'This year ($dateStart - $dateEnd)';
  }

  @override
  String pThisDayTimeCustom(String dateStart, String dateEnd) {
    return 'Custom ($dateStart - $dateEnd)';
  }

  @override
  String get custom => 'Custom';

  @override
  String get operatingPeriod => 'Operating period';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get developingFreatures => 'Developing Features';

  @override
  String get exportExcel => 'Export Excel';

  @override
  String get warning => 'Warning';

  @override
  String get confirm => 'Confirm';

  @override
  String get budgetSummary => 'Budget summary';

  @override
  String get currentValue => 'Current value';

  @override
  String get budgets => 'Budgets';

  @override
  String pBudgetInformationFromDateToEndDate(Object endDate, Object fromDate) {
    return 'Budget information from date $fromDate to $endDate';
  }

  @override
  String get duration => 'Duration';

  @override
  String get type => 'Type';

  @override
  String get thisMonth => 'This month';

  @override
  String get viewAll => 'View all';

  @override
  String get youMustCreateAtLeastOneBudget => 'You must create at least one budget to use this feature';

  @override
  String get navigateToIt => 'Navigate to it';

  @override
  String get reportExportedSuccessfully => 'Report exported successfully';

  @override
  String get report => 'Report';

  @override
  String get value => 'Value';

  @override
  String get debit => 'Debit';

  @override
  String get budgetTypeIsNotEmpty => 'Budget type is not empty';

  @override
  String get select => 'Select';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'endDate date';

  @override
  String get incomeWallet => 'Wallet for Income';

  @override
  String get expenseWallet => 'Wallet for Expenses';

  @override
  String get incomeBudget => 'Budget for Income';

  @override
  String get expenseBudget => 'Budget for Expenses';

  @override
  String get chooseBudgets => 'Choose budgets';

  @override
  String get chooseMonth => 'Choose month';

  @override
  String get filter => 'Filter';

  @override
  String get accept => 'Accept';

  @override
  String get reasonChartNotVisible => 'The chart is not displayed because the filter is showing income and expense';

  @override
  String get transactionNotScopeBudget => 'The transaction date is not within the budget time range';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get newVersionDescription => 'Please update to the latest version of the app.';

  @override
  String get newVersionTitle => 'New version available';

  @override
  String get openFile => 'Open file';

  @override
  String get currentIncome => 'Current Income';

  @override
  String get currentExpense => 'Current Expense';

  @override
  String get startIncome => 'Start tracking your income to ensure you\'re meeting your financial goals.';

  @override
  String get processIncome => 'Your income is steady. Keep aiming for your financial goals.';

  @override
  String get almostDoneIncome => 'You\'re close to hitting your income goal. Keep it up!';

  @override
  String get completeIncome => 'Excellent! You\'ve met or exceeded your income goal.';

  @override
  String get startExpense => 'Start tracking your expenses to avoid exceeding your budget.';

  @override
  String get processExpense => 'Your expenses are under control. Keep managing them carefully!';

  @override
  String get almostDoneExpense => 'You\'re almost done with your spending goal. Don’t forget to stay under the limit!';

  @override
  String get completeExpense => 'Attention, your budget has reached its limit!';

  @override
  String get send => 'Send';

  @override
  String get chatHint => 'Message ViBot';

  @override
  String get chatWithViBot => 'Chat with ViBot';

  @override
  String get viBotHello => 'Hello, I am ViBot, the virtual assistant of Vi Nho app.\nHow can I help you?';

  @override
  String pAppVersion(Object version) {
    return 'Version $version';
  }
}
