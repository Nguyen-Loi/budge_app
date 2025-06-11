import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Amount invalid'**
  String get amountInvalid;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get amountHint;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Money from salary'**
  String get noteHint;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @welecomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welecome back!'**
  String get welecomeBack;

  /// No description provided for @signInDescription.
  ///
  /// In en, this message translates to:
  /// **'Hey you\'re back, fill in your details to get back in'**
  String get signInDescription;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get orLoginWith;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @welecomeAppName.
  ///
  /// In en, this message translates to:
  /// **'Welecome to SmartBudget!'**
  String get welecomeAppName;

  /// No description provided for @signUpToStart.
  ///
  /// In en, this message translates to:
  /// **'Complete then sign up to get started'**
  String get signUpToStart;

  /// No description provided for @pleaseEnableService.
  ///
  /// In en, this message translates to:
  /// **'Please enable our terms of service'**
  String get pleaseEnableService;

  /// No description provided for @nEableServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{By the signing up, you agree to the  } =1{Terms of Service and Privay Policy} other{{count} errorText}}'**
  String nEableServiceDescription(num count);

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your.email@gmail.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'*******'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @noTransactionDescription.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any transactions yet'**
  String get noTransactionDescription;

  /// No description provided for @monthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get monthlyExpense;

  /// No description provided for @noTransactionThisBudget.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any transactions with this budget.'**
  String get noTransactionThisBudget;

  /// No description provided for @youAlreadySpent.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already spent'**
  String get youAlreadySpent;

  /// No description provided for @modifyBudget.
  ///
  /// In en, this message translates to:
  /// **'Modify Budget'**
  String get modifyBudget;

  /// No description provided for @budgetName.
  ///
  /// In en, this message translates to:
  /// **'Budget name'**
  String get budgetName;

  /// No description provided for @errorChooseYourBudgetIcon.
  ///
  /// In en, this message translates to:
  /// **'Please choose your budget icon'**
  String get errorChooseYourBudgetIcon;

  /// No description provided for @chooseYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Choose your budget'**
  String get chooseYourBudget;

  /// No description provided for @errorChooseYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Please choose your budget'**
  String get errorChooseYourBudget;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New Budget'**
  String get newBudget;

  /// No description provided for @budgetNameHint.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get budgetNameHint;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @thereAreNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'There are no transactions'**
  String get thereAreNoTransactions;

  /// No description provided for @yourAvailableBalanceIs.
  ///
  /// In en, this message translates to:
  /// **'Your available balance is'**
  String get yourAvailableBalanceIs;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get newExpense;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @readModeOnly.
  ///
  /// In en, this message translates to:
  /// **'View only'**
  String get readModeOnly;

  /// No description provided for @editModeActive.
  ///
  /// In en, this message translates to:
  /// **'Editing enabled'**
  String get editModeActive;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Budget SS'**
  String get appName;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// No description provided for @approaced.
  ///
  /// In en, this message translates to:
  /// **'Approaced'**
  String get approaced;

  /// No description provided for @exceeded.
  ///
  /// In en, this message translates to:
  /// **'Exceeded'**
  String get exceeded;

  /// No description provided for @anErrorUnexpectedOccur.
  ///
  /// In en, this message translates to:
  /// **'An error unexpected occur, please try again'**
  String get anErrorUnexpectedOccur;

  /// No description provided for @errorUploadFiles.
  ///
  /// In en, this message translates to:
  /// **'Error when upload files'**
  String get errorUploadFiles;

  /// No description provided for @errorUploadFile.
  ///
  /// In en, this message translates to:
  /// **'\'An error occur when upload image\''**
  String get errorUploadFile;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {obj}'**
  String deleteTitle(Object obj);

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this {obj}?'**
  String deleteMessage(Object obj);

  /// No description provided for @deleteUp.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteUp;

  /// No description provided for @cancelUp.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelUp;

  /// No description provided for @errorUp.
  ///
  /// In en, this message translates to:
  /// **'ERRROR'**
  String get errorUp;

  /// No description provided for @successUp.
  ///
  /// In en, this message translates to:
  /// **'SUCCESS'**
  String get successUp;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @noBudget.
  ///
  /// In en, this message translates to:
  /// **'No budget available'**
  String get noBudget;

  /// No description provided for @textFieldHintDefault.
  ///
  /// In en, this message translates to:
  /// **'Enter your text'**
  String get textFieldHintDefault;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose icon'**
  String get chooseIcon;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'No Image'**
  String get noImage;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Email Invalid'**
  String get emailInvalid;

  /// No description provided for @dataEmpty.
  ///
  /// In en, this message translates to:
  /// **'Data Empty'**
  String get dataEmpty;

  /// No description provided for @phoneNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number invalid'**
  String get phoneNumberInvalid;

  /// No description provided for @nameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Name invalid'**
  String get nameInvalid;

  /// No description provided for @passwordMininum6.
  ///
  /// In en, this message translates to:
  /// **'Password minimum is 6 characters'**
  String get passwordMininum6;

  /// No description provided for @confirmPasswordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Confirm password invalid'**
  String get confirmPasswordInvalid;

  /// No description provided for @accountCreatePleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please login'**
  String get accountCreatePleaseLogin;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgetPassword;

  /// No description provided for @pBudgetNameExits.
  ///
  /// In en, this message translates to:
  /// **'Budget {budgetName} already exist. Please change budget name and try again'**
  String pBudgetNameExits(String budgetName);

  /// No description provided for @budgetEmpty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any budget yet.'**
  String get budgetEmpty;

  /// No description provided for @pExpensesExceedIncome.
  ///
  /// In en, this message translates to:
  /// **'Expenses exceed income ({money}). Increase your income and try again'**
  String pExpensesExceedIncome(String money);

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get passwordTooWeak;

  /// No description provided for @emailAlreadyExits.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get emailAlreadyExits;

  /// No description provided for @errorSignInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Error occurred using Google Sign-In. Try again.'**
  String get errorSignInGoogle;

  /// No description provided for @errorSignInFacebook.
  ///
  /// In en, this message translates to:
  /// **'Error occurred using Facebook Sign-In. Try again.'**
  String get errorSignInFacebook;

  /// No description provided for @accountAlreadyExits.
  ///
  /// In en, this message translates to:
  /// **'The account already exists with a different credential.'**
  String get accountAlreadyExits;

  /// No description provided for @errorCredentials.
  ///
  /// In en, this message translates to:
  /// **'Error occurred while accessing credentials. Try again.'**
  String get errorCredentials;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please try again.'**
  String get invalidEmailOrPassword;

  /// No description provided for @walletInvalidMatches.
  ///
  /// In en, this message translates to:
  /// **'The value matches the value currently'**
  String get walletInvalidMatches;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @budgetInUse.
  ///
  /// In en, this message translates to:
  /// **'Budget in use'**
  String get budgetInUse;

  /// No description provided for @budgetExpired.
  ///
  /// In en, this message translates to:
  /// **'Budget expired'**
  String get budgetExpired;

  /// No description provided for @budgetUtilized.
  ///
  /// In en, this message translates to:
  /// **'Budget utilized'**
  String get budgetUtilized;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent transactions'**
  String get recentTransactions;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction date'**
  String get transactionDate;

  /// No description provided for @updateBalance.
  ///
  /// In en, this message translates to:
  /// **'Update balance'**
  String get updateBalance;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My wallet'**
  String get myWallet;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created date'**
  String get createdDate;

  /// No description provided for @updatedDate.
  ///
  /// In en, this message translates to:
  /// **'Updated date'**
  String get updatedDate;

  /// No description provided for @balanceAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Balance adjustment'**
  String get balanceAdjustment;

  /// No description provided for @pThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week ({dateStart} - {dateEnd})'**
  String pThisWeek(String dateStart, String dateEnd);

  /// No description provided for @pThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month ({dateStart} - {dateEnd})'**
  String pThisMonth(String dateStart, String dateEnd);

  /// No description provided for @pThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year ({dateStart} - {dateEnd})'**
  String pThisYear(String dateStart, String dateEnd);

  /// No description provided for @pThisDayTimeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom ({dateStart} - {dateEnd})'**
  String pThisDayTimeCustom(String dateStart, String dateEnd);

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @operatingTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get operatingTime;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @developingFreatures.
  ///
  /// In en, this message translates to:
  /// **'Developing Features'**
  String get developingFreatures;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get exportExcel;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @budgetSummary.
  ///
  /// In en, this message translates to:
  /// **'Budget summary'**
  String get budgetSummary;

  /// No description provided for @currentValue.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get currentValue;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @pBudgetInformationFromDateToEndDate.
  ///
  /// In en, this message translates to:
  /// **'Budget information from date {fromDate} to {endDate}'**
  String pBudgetInformationFromDateToEndDate(Object endDate, Object fromDate);

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @youMustCreateAtLeastOneBudget.
  ///
  /// In en, this message translates to:
  /// **'You must create at least one budget to use this feature'**
  String get youMustCreateAtLeastOneBudget;

  /// No description provided for @navigateToIt.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigateToIt;

  /// No description provided for @reportExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Report exported successfully'**
  String get reportExportedSuccessfully;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @budgetTypeIsNotEmpty.
  ///
  /// In en, this message translates to:
  /// **'Budget type is not empty'**
  String get budgetTypeIsNotEmpty;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'endDate date'**
  String get endDate;

  /// No description provided for @chooseBudgets.
  ///
  /// In en, this message translates to:
  /// **'Choose budgets'**
  String get chooseBudgets;

  /// No description provided for @chooseMonth.
  ///
  /// In en, this message translates to:
  /// **'Choose month'**
  String get chooseMonth;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reasonChartNotVisible.
  ///
  /// In en, this message translates to:
  /// **'The chart is not displayed because the filter is showing income and expense'**
  String get reasonChartNotVisible;

  /// No description provided for @transactionNotScopeBudget.
  ///
  /// In en, this message translates to:
  /// **'The transaction date is not within the budget time range'**
  String get transactionNotScopeBudget;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @newVersionDescription.
  ///
  /// In en, this message translates to:
  /// **'Please update to the latest version of the app.'**
  String get newVersionDescription;

  /// No description provided for @newVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'New version available'**
  String get newVersionTitle;

  /// No description provided for @openFile.
  ///
  /// In en, this message translates to:
  /// **'Open file'**
  String get openFile;

  /// No description provided for @currentIncome.
  ///
  /// In en, this message translates to:
  /// **'Current Income'**
  String get currentIncome;

  /// No description provided for @currentExpense.
  ///
  /// In en, this message translates to:
  /// **'Current Expense'**
  String get currentExpense;

  /// No description provided for @startIncome.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your income to meet your goals.'**
  String get startIncome;

  /// No description provided for @processIncome.
  ///
  /// In en, this message translates to:
  /// **'Your income is steady. Keep it up!'**
  String get processIncome;

  /// No description provided for @almostDoneIncome.
  ///
  /// In en, this message translates to:
  /// **'You\'re close to your goal. Stay focused!'**
  String get almostDoneIncome;

  /// No description provided for @completeIncome.
  ///
  /// In en, this message translates to:
  /// **'Great! You\'ve met your goal.'**
  String get completeIncome;

  /// No description provided for @startExpense.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your expenses to stay on budget.'**
  String get startExpense;

  /// No description provided for @processExpense.
  ///
  /// In en, this message translates to:
  /// **'Expenses are under control. Keep it up!'**
  String get processExpense;

  /// No description provided for @almostDoneExpense.
  ///
  /// In en, this message translates to:
  /// **'Almost there! Stay within your limit.'**
  String get almostDoneExpense;

  /// No description provided for @completeExpense.
  ///
  /// In en, this message translates to:
  /// **'Budget limit reached. Watch out!'**
  String get completeExpense;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Message ViBot'**
  String get chatHint;

  /// No description provided for @chatWithViBot.
  ///
  /// In en, this message translates to:
  /// **'Chat with ViBot'**
  String get chatWithViBot;

  /// No description provided for @viBotHello.
  ///
  /// In en, this message translates to:
  /// **'Hello, I am ViBot, the virtual assistant of Vi Nho app.\nHow can I help you?'**
  String get viBotHello;

  /// No description provided for @pAppVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String pAppVersion(Object version);

  /// No description provided for @coming.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get coming;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @reviewExpense.
  ///
  /// In en, this message translates to:
  /// **'You need to make your last transaction on {date} to have more {money} in coins. Continue'**
  String reviewExpense(Object date, Object money);

  /// No description provided for @featureMaintain.
  ///
  /// In en, this message translates to:
  /// **'This feature is under maintenance, please try again later'**
  String get featureMaintain;

  /// No description provided for @errorContactSupport.
  ///
  /// In en, this message translates to:
  /// **'An error occurred, please contact support'**
  String get errorContactSupport;

  /// No description provided for @errorInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errorInternet;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @invalidDateRange.
  ///
  /// In en, this message translates to:
  /// **'The new date range must fully include the current date range.'**
  String get invalidDateRange;

  /// No description provided for @emailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get emailNotFound;

  /// No description provided for @weAreSendEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an email to reset your password. Please check your inbox.'**
  String get weAreSendEmailPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDescription;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @dailyTransactionReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Transaction Reminder'**
  String get dailyTransactionReminder;

  /// No description provided for @guestAccess.
  ///
  /// In en, this message translates to:
  /// **'Guest Access'**
  String get guestAccess;

  /// No description provided for @loginToUse.
  ///
  /// In en, this message translates to:
  /// **'You need to login to use this feature'**
  String get loginToUse;

  /// No description provided for @pAccountAlreadyHasExistingData.
  ///
  /// In en, this message translates to:
  /// **'The account {accountName} already has existing data. If you proceed with this login, all current data will be deleted.\nAre you sure you want to continue?'**
  String pAccountAlreadyHasExistingData(Object accountName);

  /// No description provided for @loginCancelledByUser.
  ///
  /// In en, this message translates to:
  /// **'Login cancelled by user'**
  String get loginCancelledByUser;

  /// No description provided for @syncLocalToCloud.
  ///
  /// In en, this message translates to:
  /// **'Sync local data to cloud'**
  String get syncLocalToCloud;

  /// No description provided for @syncLocalToCloudLoading.
  ///
  /// In en, this message translates to:
  /// **'Syncing local data to cloud...'**
  String get syncLocalToCloudLoading;

  /// No description provided for @syncLocalToCloudSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sync local data to cloud success'**
  String get syncLocalToCloudSuccess;

  /// No description provided for @syncLocalToCloudError.
  ///
  /// In en, this message translates to:
  /// **'Sync local data to cloud error. Please try again'**
  String get syncLocalToCloudError;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @incomeExpenseThisMonth.
  ///
  /// In en, this message translates to:
  /// **'INCOME - EXPENSE THIS MONTH'**
  String get incomeExpenseThisMonth;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @pSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent {value}%'**
  String pSpent(Object value);

  /// No description provided for @noBudgetsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No budgets available'**
  String get noBudgetsAvailable;

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions'**
  String get noRecentTransactions;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummary;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @budgetPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage and track your budgets'**
  String get budgetPageDesc;

  /// No description provided for @errorValidateForm.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors in the form.'**
  String get errorValidateForm;

  /// No description provided for @protected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protected;

  /// No description provided for @initializingTheApplication.
  ///
  /// In en, this message translates to:
  /// **'Initializing the application...'**
  String get initializingTheApplication;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @removeAll.
  ///
  /// In en, this message translates to:
  /// **'Remove All'**
  String get removeAll;

  /// No description provided for @noAppToOpen.
  ///
  /// In en, this message translates to:
  /// **'No app available to open this file'**
  String get noAppToOpen;

  /// No description provided for @pFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File `{file}` not found'**
  String pFileNotFound(Object file);

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @budgetDistribution.
  ///
  /// In en, this message translates to:
  /// **'Budget Distribution'**
  String get budgetDistribution;

  /// No description provided for @noBudgetsSelectedTransaction.
  ///
  /// In en, this message translates to:
  /// **'No budgets available for selected transaction types'**
  String get noBudgetsSelectedTransaction;

  /// No description provided for @incomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get incomeVsExpense;

  /// No description provided for @incomeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Income Analysis'**
  String get incomeAnalysis;

  /// No description provided for @expenseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Expense Analysis'**
  String get expenseAnalysis;

  /// No description provided for @budgetBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Budget Breakdown'**
  String get budgetBreakdown;

  /// No description provided for @incomeBudgetDistribution.
  ///
  /// In en, this message translates to:
  /// **'Income Budget Distribution'**
  String get incomeBudgetDistribution;

  /// No description provided for @expenseBudgetDistribution.
  ///
  /// In en, this message translates to:
  /// **'Expense Budget Distribution'**
  String get expenseBudgetDistribution;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @incomeProgress.
  ///
  /// In en, this message translates to:
  /// **'Income Progress'**
  String get incomeProgress;

  /// No description provided for @spendingProgress.
  ///
  /// In en, this message translates to:
  /// **'Spending Progress'**
  String get spendingProgress;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
