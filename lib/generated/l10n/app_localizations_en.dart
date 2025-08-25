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
  String get welecomeAppName => 'Welecome to SmartBudget!';

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
  String get emailHint => 'your.email@gmail.com';

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
  String get newExpense => 'New expense';

  @override
  String get myAccount => 'My Account';

  @override
  String get modify => 'Modify';

  @override
  String get readModeOnly => 'View only';

  @override
  String get editModeActive => 'Editing enabled';

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
  String get home => 'Home';

  @override
  String get appName => 'SmartBudget';

  @override
  String get left => 'Left';

  @override
  String get approaced => 'Approaced';

  @override
  String get exceeded => 'Exceeded';

  @override
  String get anErrorUnexpectedOccur => 'An error unexpected occur, please try again';

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
  String get accountCreateSuccess => 'Account created successfully!';

  @override
  String get forgetPassword => 'Forgot password?';

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
  String get operatingTime => 'Time';

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
  String get navigateToIt => 'Navigate';

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
  String get startIncome => 'Start tracking your income to meet your goals.';

  @override
  String get processIncome => 'Your income is steady. Keep it up!';

  @override
  String get almostDoneIncome => 'You\'re close to your goal. Stay focused!';

  @override
  String get completeIncome => 'Great! You\'ve met your goal.';

  @override
  String get startExpense => 'Start tracking your expenses to stay on budget.';

  @override
  String get processExpense => 'Expenses are under control. Keep it up!';

  @override
  String get almostDoneExpense => 'Almost there! Stay within your limit.';

  @override
  String get completeExpense => 'Budget limit reached. Watch out!';

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

  @override
  String get coming => 'Coming soon';

  @override
  String get expired => 'Expired';

  @override
  String get active => 'Active';

  @override
  String get status => 'Status';

  @override
  String get review => 'Review';

  @override
  String reviewExpense(Object date, Object money) {
    return 'You need to make your last transaction on $date to have more $money in coins. Continue';
  }

  @override
  String get featureMaintain => 'This feature is under maintenance, please try again later';

  @override
  String get errorContactSupport => 'An error occurred, please contact support';

  @override
  String get errorInternet => 'No internet connection';

  @override
  String get allTime => 'All time';

  @override
  String get invalidDateRange => 'The new time frame must cover the entire current time frame.';

  @override
  String get emailNotFound => 'Email not found';

  @override
  String get weAreSendEmailPassword => 'We\'ve sent you an email to reset your password. Please check your inbox.';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordTitle => 'Forgot your password?';

  @override
  String get resetPasswordDescription => 'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get dailyTransactionReminder => 'Daily Transaction Reminder';

  @override
  String get guestAccess => 'Guest Access';

  @override
  String get loginToUse => 'You need to login to use this feature';

  @override
  String pAccountAlreadyHasExistingData(Object accountName) {
    return 'The account $accountName already has existing data. If you proceed with this login, all current data will be deleted.\nAre you sure you want to continue?';
  }

  @override
  String get loginCancelledByUser => 'Login cancelled by user';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get incomeExpenseThisMonth => 'INCOME - EXPENSE THIS MONTH';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalCost => 'Total Cost';

  @override
  String pSpent(Object value) {
    return 'Spent $value%';
  }

  @override
  String get noBudgetsAvailable => 'No budgets available';

  @override
  String get noRecentTransactions => 'No recent transactions';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get monthlySummary => 'Monthly Summary';

  @override
  String get netBalance => 'Net Balance';

  @override
  String get errorValidateForm => 'Please fix the errors in the form.';

  @override
  String get protected => 'Protected';

  @override
  String get initializingTheApplication => 'Initializing the application...';

  @override
  String get selectAll => 'Select All';

  @override
  String get removeAll => 'Remove All';

  @override
  String get noAppToOpen => 'No app available to open this file';

  @override
  String pFileNotFound(Object file) {
    return 'File `$file` not found';
  }

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get transaction => 'Transaction';

  @override
  String get budgetDistribution => 'Budget Distribution';

  @override
  String get noBudgetsSelectedTransaction => 'No budgets available for selected transaction types';

  @override
  String get incomeVsExpense => 'Income vs Expense';

  @override
  String get incomeAnalysis => 'Income Analysis';

  @override
  String get expenseAnalysis => 'Expense Analysis';

  @override
  String get budgetBreakdown => 'Budget Breakdown';

  @override
  String get incomeBudgetDistribution => 'Income Budget Distribution';

  @override
  String get expenseBudgetDistribution => 'Expense Budget Distribution';

  @override
  String get progress => 'Progress';

  @override
  String get incomeProgress => 'Income Progress';

  @override
  String get spendingProgress => 'Spending Progress';

  @override
  String get defaultBudgetHousing => 'Housing';

  @override
  String get defaultBudgetFood => 'Food & Dining';

  @override
  String get defaultBudgetTransportation => 'Transportation';

  @override
  String get defaultBudgetUtilities => 'Utilities';

  @override
  String get defaultBudgetEntertainment => 'Entertainment';

  @override
  String get defaultBudgetHealthcare => 'Healthcare';

  @override
  String get defaultBudgetShopping => 'Shopping';

  @override
  String get defaultBudgetSalary => 'Salary';

  @override
  String get defaultBudgetFreelance => 'Freelance';

  @override
  String get defaultBudgetInvestments => 'Investments';

  @override
  String get skip => 'Skip';

  @override
  String get createdByViBot => 'Created by ViBot';

  @override
  String get viBotPersonality => 'You are ViBot, a friendly and helpful personal finance assistant for the Smart Budget app.';

  @override
  String get viBotPersonalityTraits => 'Be warm, encouraging, and supportive about financial goals\n- Keep responses brief but informative\n- Use emojis sparingly but appropriately\n- Celebrate financial wins and gently guide on overspending';

  @override
  String get viBotCapabilities => '**Transaction Processing**: Parse natural language like \"Lunch 50k\", \"Coffee 30k yesterday\", \"Paid electricity 100k\"\n2. **Budget Management**: Create new budgets automatically when mentioned\n3. **Smart Insights**: Provide spending summaries and budget status\n4. **Quick Actions**: Support editing, deleting, and adding notes to transactions';

  @override
  String viBotUserInfo(Object balance, Object currency, Object name) {
    return 'Current user info:\n- Name: $name\n- Balance: $balance\n- Currency: $currency';
  }

  @override
  String viBotAvailableBudgets(Object budgets) {
    return 'Available budgets: $budgets';
  }

  @override
  String get viBotTransactionRules => 'When processing transactions:\n- Always create transactions with note \"Created by ViBot\"\n- If budget doesn\'t exist, mention you\'re creating it\n- Provide spending summaries after transactions\n- Warn gently if approaching budget limits\n- Suggest creating budgets for unrecognized categories';

  @override
  String get viBotResponseFormat => 'Response format for transactions:\n- Confirm what was recorded\n- Show budget status if relevant\n- Offer helpful next steps\n- Keep it conversational and friendly';

  @override
  String get viBotExampleUser1 => 'Lunch 50k';

  @override
  String get viBotExampleBot1 => 'I\'ve recorded your 50k lunch expense! 🍽️ You have 150k left in your Lunch budget this month.';

  @override
  String get viBotExampleUser2 => 'Coffee shop 30k yesterday';

  @override
  String get viBotExampleBot2 => 'Got it! I\'ve added yesterday\'s 30k coffee expense. I created a new \'Coffee\' budget for you since this is your first coffee purchase.';

  @override
  String get viBotClosing => 'Always be helpful, accurate, and encouraging about financial management!';

  @override
  String get refresh => 'Refresh';

  @override
  String get removeChatTitle => 'Delete chat';

  @override
  String get removeChatMessage => 'Are you sure you want to delete this chat?';

  @override
  String get signingOutLoading => 'Signing out...';

  @override
  String get currency => 'Currency';

  @override
  String get usdCurrencyName => 'US Dollar';

  @override
  String get eurCurrencyName => 'Euro';

  @override
  String get jpyCurrencyName => 'Japanese Yen';

  @override
  String get vndCurrencyName => 'Vietnamese Dong';

  @override
  String get cadCurrencyName => 'Canadian Dollar';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsDesc => 'We\'re here to help and answer any questions you might have.';

  @override
  String get sendEmail => 'Send Email';

  @override
  String get emailSupport => 'Email Support';

  @override
  String get emailSupportDesc => 'Get help with your account and billing';

  @override
  String get phoneSupport => 'Phone Support';

  @override
  String get phoneSupportDesc => 'Available Mon-Fri, 9AM-6PM EST';

  @override
  String get followUs => 'Follow Us';

  @override
  String get getInTouch => 'Get in Touch';

  @override
  String get copyEmail => 'Copy Email';

  @override
  String get copyPhone => 'Copy Phone';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String pSubjectContactUsEmail(Object appName) {
    return '$appName App Support';
  }

  @override
  String pBodyContactUsEmail(Object appName) {
    return 'Hello $appName Team,\n\nI need assistance with the following:\n\n';
  }

  @override
  String pCopyToClipboard(Object value) {
    return 'Copied to clipboard: $value';
  }

  @override
  String get userNameDefault => 'Guest';

  @override
  String get agreeToTerms => 'By continuing, you agree to our Terms & Privacy Policy';

  @override
  String get selectCurrencyDesc => 'Select your preferred currency for transactions';

  @override
  String get tellUsYourNameToGetStarted => 'Tell us your name to get started';

  @override
  String get letPersonalizeYourExperience => 'Let\\\'s personalize your experience';

  @override
  String get smartBudgetPlanning => 'Smart Budget Planning';

  @override
  String get easyExpenseTracking => 'Easy Expense Tracking';

  @override
  String get detailedReports => 'Detailed Reports';

  @override
  String get next => 'Next';

  @override
  String get takeControlOfYourFinances => 'Take control of your finances with smart budgeting and expense tracking';

  @override
  String get chooseYourCurrency => 'Choose your currency';

  @override
  String pShowingBudgetsFor(Object data) {
    return 'Showing budgets for: $data';
  }

  @override
  String get thankYouYourFeedback => 'Thank you for your interest in reviewing our app! Your feedback is valuable to us.';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get feedback => 'Feedback';

  @override
  String get submitFeedback => 'Submit Feedback';

  @override
  String get submitFeedbackDesc => 'Help us improve our app by sharing your thoughts and suggestions.';

  @override
  String get ratingRequired => 'Rating *';

  @override
  String get rate1Desc => 'Very Poor';

  @override
  String get rate2Desc => 'Poor';

  @override
  String get rate3Desc => 'Average';

  @override
  String get rate4Desc => 'Good';

  @override
  String get rate5Desc => 'Excellent';

  @override
  String get titleRequired => 'Title *';

  @override
  String get feedbackTitleHint => 'Brief summary of your feedback';

  @override
  String get feedbackRequired => 'Feedback *';

  @override
  String get feedbackDescHint => 'Tell us about your experience, suggestions, or issues...';

  @override
  String get feedbackSuccess => 'Thank you for your feedback! We appreciate your input and will use it to improve our app.';

  @override
  String get submitting => 'Submitting...';

  @override
  String get myFeedback => 'My Feedback';

  @override
  String get noFeedbackYet => 'No feedback submitted yet';

  @override
  String get overview => 'Overview';

  @override
  String get netIncome => 'Net Income';

  @override
  String get totalBudgets => 'Total Budgets';

  @override
  String get totalTransactions => 'Total Transactions';

  @override
  String get rankedByActivity => 'Ranked by Activity';

  @override
  String get transactionCount => 'Trans. Count';

  @override
  String get detailedView => 'Detailed View';

  @override
  String get incomeTransactions => 'Income Transactions';

  @override
  String get expenseTransactions => 'Expense Transactions';

  @override
  String get utilization => 'Utilization';

  @override
  String get noLimit => 'No Limit';

  @override
  String get useCurrentData => 'Use Current Data';

  @override
  String get overwriteWithNewData => 'Overwrite with New Data';

  @override
  String get combineData => 'Combine Data';

  @override
  String get chooseAvatar => 'Choose Avatar';

  @override
  String get selectYourFavoriteAvatar => 'Select your favorite avatar';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get premium => 'Premium';

  @override
  String get subscription => 'Subscription';

  @override
  String get upgradeToUnlockFeatures => 'Upgrade to unlock premium features';

  @override
  String get premiumBenefits => 'Premium Benefits';

  @override
  String get noAds => 'No Ads';

  @override
  String get enjoyAdFreeExperience => 'Enjoy an ad-free experience';

  @override
  String get advancedReports => 'Advanced Reports';

  @override
  String get detailedAnalyticsAndInsights => 'Detailed analytics and insights';

  @override
  String get dataExport => 'Data Export';

  @override
  String get exportYourDataAnytime => 'Export your data anytime';

  @override
  String get prioritySupport => 'Priority Support';

  @override
  String get getFastPersonalizedHelp => 'Get fast, personalized help';

  @override
  String get unlimitedBudgets => 'Unlimited Budgets';

  @override
  String get createAsMany => 'Create as many budgets as you need';

  @override
  String get chooseYourPlan => 'Choose Your Plan';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String saveValuePercent(Object value) {
    return 'Save $value%';
  }

  @override
  String get mostPopular => 'Most Popular';

  @override
  String get perMonth => 'per month';

  @override
  String get perYear => 'per year';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get freeTrial => '7-day free trial';

  @override
  String get continueWithPremium => 'Continue with Premium';

  @override
  String get upgradeNow => 'Upgrade Now';

  @override
  String billedAnnuallyAt(Object amount) {
    return 'Billed annually at $amount';
  }

  @override
  String get processing => 'Processing...';

  @override
  String failedToStartSubscription(Object errorMessage) {
    return 'Failed to start subscription. Please try again: $errorMessage';
  }

  @override
  String get bannerDismissed => 'Banner dismissed';

  @override
  String get purchaseSuccessful => 'Purchase successful! Your subscription is now active.';

  @override
  String purchaseFailed(Object errorMessage) {
    return 'Purchase failed: $errorMessage';
  }

  @override
  String get unknownError => 'Unknown error occurred. Please try again later.';

  @override
  String get purchaseCanceledByUser => 'Purchase canceled by user.';

  @override
  String get purchasePending => 'Purchase is pending. Please wait for confirmation.';

  @override
  String get purchaseRestored => 'Purchase restored successfully.';

  @override
  String errorLoadingProducts(Object errorMessage) {
    return 'Error loading products: $errorMessage';
  }

  @override
  String get loadingSubscriptionPlans => 'Loading subscription plans...';

  @override
  String pAnErrorUnexpectedOccur(Object errorMessage) {
    return 'An unexpected error occurred: $errorMessage';
  }

  @override
  String get noInternetConnection => 'No internet connection';
}
