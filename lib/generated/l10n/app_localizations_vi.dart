// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get hello => 'Xin chào';

  @override
  String get income => 'Thu nhập';

  @override
  String get expense => 'Chi tiêu';

  @override
  String get amount => 'Số tiền';

  @override
  String get amountInvalid => 'Số tiền không hợp lệ';

  @override
  String get amountHint => '0';

  @override
  String get note => 'Ghi chú';

  @override
  String get noteHint => 'Tiền từ lương';

  @override
  String get date => 'Ngày';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get welecomeBack => 'Chào mừng trở lại!';

  @override
  String get signInDescription => 'Xin chào, bạn đã quay lại, điền thông tin của bạn để tiếp tục';

  @override
  String get email => 'Email';

  @override
  String get orLoginWith => 'Hoặc đăng nhập bằng';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get welecomeAppName => 'Chào mừng đến với ứng dụng Sổ Tiêu Dùng!';

  @override
  String get signUpToStart => 'Hoàn thành sau đó đăng ký để bắt đầu';

  @override
  String get pleaseEnableService => 'Vui lòng bật điều khoản dịch vụ của chúng tôi';

  @override
  String nEableServiceDescription(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count errorText',
      one: 'điều khoản dịch vụ và chính sách quyền riêng tư',
      zero: 'Bằng việc đăng ký, bạn đồng ý với  ',
    );
    return '$_temp0';
  }

  @override
  String get emailHint => 'your.email@gmail.com';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordHint => '*******';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get create => 'Tạo';

  @override
  String get transactions => 'Các giao dịch';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get noTransactionDescription => 'Bạn chưa có giao dịch nào';

  @override
  String get monthlyExpense => 'Chi tiêu hàng tháng';

  @override
  String get noTransactionThisBudget => 'Bạn chưa có giao dịch nào với ngân sách này.';

  @override
  String get youAlreadySpent => 'Bạn đã chi tiêu';

  @override
  String get modifyBudget => 'Sửa đổi ngân sách';

  @override
  String get budgetName => 'Tên ngân sách';

  @override
  String get errorChooseYourBudgetIcon => 'Vui lòng chọn biểu tượng ngân sách của bạn';

  @override
  String get chooseYourBudget => 'Chọn ngân sách';

  @override
  String get errorChooseYourBudget => 'Vui lòng chọn ngân sách của bạn';

  @override
  String get update => 'Cập nhật';

  @override
  String get newBudget => 'Ngân sách mới';

  @override
  String get budgetNameHint => 'Nước';

  @override
  String get add => 'Thêm';

  @override
  String get limit => 'Giới hạn';

  @override
  String get target => 'Mục tiêu';

  @override
  String get thereAreNoTransactions => 'Không có giao dịch nào';

  @override
  String get yourAvailableBalanceIs => 'Số dư khả dụng của bạn là';

  @override
  String get newExpense => 'Chi tiêu mới';

  @override
  String get myAccount => 'Tài khoản của tôi';

  @override
  String get modify => 'Sửa đổi';

  @override
  String get readModeOnly => 'View only';

  @override
  String get editModeActive => 'Editing enabled';

  @override
  String get name => 'Tên';

  @override
  String get save => 'Lưu';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get contact => 'Liên hệ';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get home => 'Trang chủ';

  @override
  String get appName => 'SmartBudget';

  @override
  String get left => 'Còn lại';

  @override
  String get approaced => 'Tiếp cận';

  @override
  String get exceeded => 'Vượt quá';

  @override
  String get anErrorUnexpectedOccur => 'Đã xảy ra một lỗi không mong muốn, vui lòng thử lại';

  @override
  String get errorUploadFiles => 'Lỗi khi tải lên tệp';

  @override
  String get errorUploadFile => 'Đã xảy ra lỗi khi tải lên hình ảnh';

  @override
  String deleteTitle(Object obj) {
    return 'Xóa $obj';
  }

  @override
  String deleteMessage(Object obj) {
    return 'Bạn có chắc chắn muốn xóa $obj này không?';
  }

  @override
  String get deleteUp => 'XÓA';

  @override
  String get cancelUp => 'HỦY';

  @override
  String get errorUp => 'LỖI';

  @override
  String get successUp => 'THÀNH CÔNG';

  @override
  String get close => 'Đóng';

  @override
  String get continueText => 'Tiếp tục';

  @override
  String get invalid => 'Không hợp lệ';

  @override
  String get noBudget => 'Không có ngân sách nào';

  @override
  String get textFieldHintDefault => 'Nhập văn bản của bạn';

  @override
  String get chooseIcon => 'Chọn biểu tượng';

  @override
  String get noImage => 'Không có ảnh';

  @override
  String get emailInvalid => 'Email không hợp lệ';

  @override
  String get dataEmpty => 'Dữ liệu trống';

  @override
  String get phoneNumberInvalid => 'Số điện thoại không hợp lệ';

  @override
  String get nameInvalid => 'Tên không hợp lệ';

  @override
  String get passwordMininum6 => 'Mật khẩu tối thiểu là 6 ký tự';

  @override
  String get confirmPasswordInvalid => 'Xác nhận mật khẩu không hợp lệ';

  @override
  String get accountCreatePleaseLogin => 'Tài khoản đã được tạo! Vui lòng đăng nhập';

  @override
  String get forgetPassword => 'Quên mật khẩu?';

  @override
  String pBudgetNameExits(String budgetName) {
    return 'Ngân sách $budgetName đã tồn tại. Vui lòng thay đổi tên ngân sách và thử lại';
  }

  @override
  String get budgetEmpty => 'Bạn chưa có ngân sách nào.';

  @override
  String pExpensesExceedIncome(String money) {
    return 'Chi phí vượt quá thu nhập ($money). Tăng thu nhập của bạn và thử lại';
  }

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get passwordTooWeak => 'Mật khẩu quá yếu.';

  @override
  String get emailAlreadyExits => 'Email đã tồn tại.';

  @override
  String get errorSignInGoogle => 'Đã xảy ra lỗi khi đăng nhập bằng Google. Hãy thử lại.';

  @override
  String get errorSignInFacebook => 'Đã xảy ra lỗi khi đăng nhập bằng Facebook. Hãy thử lại.';

  @override
  String get accountAlreadyExits => 'Tài khoản đã tồn tại.';

  @override
  String get errorCredentials => 'Đã xảy ra lỗi khi truy cập thông tin đăng nhập. Hãy thử lại.';

  @override
  String get invalidEmailOrPassword => 'Email hoặc mật khẩu không hợp lệ.';

  @override
  String get walletInvalidMatches => 'Giá trị hiện tại của ví đang trùng';

  @override
  String get cancel => 'Hủy';

  @override
  String get dateRange => 'Khoảng thời gian';

  @override
  String get budgetInUse => 'Ngân sách đang áp dụng';

  @override
  String get budgetExpired => 'Ngân sách đã hết hạn';

  @override
  String get budgetUtilized => 'Ngân sách chưa sử dụng';

  @override
  String get recentTransactions => 'Giao dịch gần đây';

  @override
  String get budget => 'Ngân sách';

  @override
  String get transactionDate => 'Ngày giao dịch';

  @override
  String get updateBalance => 'Cập nhật số dư';

  @override
  String get myWallet => 'Ví của tôi';

  @override
  String get cash => 'Tiền mặt';

  @override
  String get createdDate => 'Ngày tạo';

  @override
  String get updatedDate => 'Ngày cập nhật';

  @override
  String get balanceAdjustment => 'Điều chỉnh số dư';

  @override
  String pThisWeek(String dateStart, String dateEnd) {
    return 'Tuần này ($dateStart - $dateEnd)';
  }

  @override
  String pThisMonth(String dateStart, String dateEnd) {
    return 'Tháng này ($dateStart - $dateEnd)';
  }

  @override
  String pThisYear(String dateStart, String dateEnd) {
    return 'Năm này ($dateStart - $dateEnd)';
  }

  @override
  String pThisDayTimeCustom(String dateStart, String dateEnd) {
    return 'Tuỳ chỉnh ($dateStart - $dateEnd)';
  }

  @override
  String get custom => 'Tuỳ chỉnh';

  @override
  String get operatingTime => 'Thời gian';

  @override
  String get newTransaction => 'Giao dịch mới';

  @override
  String get developingFreatures => 'Tính năng đang phát triển';

  @override
  String get exportExcel => 'Xuất Excel';

  @override
  String get warning => 'Cảnh báo';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get budgetSummary => 'Tổng kết ngân sách';

  @override
  String get currentValue => 'Giá trị hiện tại';

  @override
  String get budgets => 'Các ngân sách';

  @override
  String pBudgetInformationFromDateToEndDate(Object endDate, Object fromDate) {
    return 'Thông tin ngân sách từ ngày $fromDate đến ngày $endDate';
  }

  @override
  String get duration => 'Khoảng thời gian';

  @override
  String get type => 'Loại';

  @override
  String get thisMonth => 'Tháng này';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get youMustCreateAtLeastOneBudget => 'Bạn phải tạo ít nhất một ngân sách để sử dụng tính năng này';

  @override
  String get navigateToIt => 'Chuyển đến';

  @override
  String get reportExportedSuccessfully => 'Xuất báo cáo thành công';

  @override
  String get report => 'Báo cáo';

  @override
  String get value => 'Giá trị';

  @override
  String get debit => 'Ghi nợ';

  @override
  String get budgetTypeIsNotEmpty => 'Loại ngân sách không được để trống';

  @override
  String get select => 'Chọn';

  @override
  String get startDate => 'Ngày bắt đầu';

  @override
  String get endDate => 'Ngày kết thúc';

  @override
  String get chooseBudgets => 'Chọn các ngân sách';

  @override
  String get chooseMonth => 'Chọn tháng';

  @override
  String get filter => 'Bộ lọc';

  @override
  String get accept => 'Đồng ý';

  @override
  String get reasonChartNotVisible => 'Biểu đồ không hiện thị vì bộ lọc đang hiện nguồn thu và chi tiêu';

  @override
  String get transactionNotScopeBudget => 'Ngày giao dịch không nằm trong phạm vi thời gian của ngân sách';

  @override
  String get totalIncome => 'Tổng Thu Nhập';

  @override
  String get totalExpense => 'Tổng Chi Phí';

  @override
  String get newVersionDescription => 'Bạn hãy cập nhật ứng dụng để có trải nghiệm tốt hơn.';

  @override
  String get newVersionTitle => 'Đã có phiên bản mới';

  @override
  String get openFile => 'Mở file';

  @override
  String get currentIncome => 'Thu nhập hiện tại';

  @override
  String get currentExpense => 'Chi phí đã bỏ ra';

  @override
  String get startIncome => 'Bắt đầu theo dõi thu nhập để đạt mục tiêu.';

  @override
  String get processIncome => 'Thu nhập ổn định. Tiếp tục cố gắng!';

  @override
  String get almostDoneIncome => 'Gần đạt mục tiêu rồi. Cố lên!';

  @override
  String get completeIncome => 'Tuyệt vời! Bạn đã đạt mục tiêu.';

  @override
  String get startExpense => 'Bắt đầu theo dõi chi tiêu để giữ ngân sách.';

  @override
  String get processExpense => 'Chi tiêu đang được kiểm soát. Tiếp tục nhé!';

  @override
  String get almostDoneExpense => 'Sắp chạm ngưỡng chi tiêu rồi. Cẩn thận nhé!';

  @override
  String get completeExpense => 'Ngân sách đã đạt giới hạn. Hãy chú ý!';

  @override
  String get send => 'Gửi';

  @override
  String get chatHint => 'Tin nhắn đến ViBot';

  @override
  String get chatWithViBot => 'Chat với ViBot';

  @override
  String get viBotHello => 'Xin chào, tôi là ViBot trợ lý ảo của ứng dụng Vi Nhỏ.\nTôi có thể giúp gì cho bạn';

  @override
  String pAppVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get coming => 'Sắp ra mắt';

  @override
  String get expired => 'Hết hạn';

  @override
  String get active => 'Hoạt động';

  @override
  String get status => 'Trạng thái';

  @override
  String get review => 'Nhận xét';

  @override
  String reviewExpense(Object date, Object money) {
    return 'Lần cuối giao dịch của bạn vào ngày $date đã có thêm $money đồng. Tiếp tục nhé';
  }

  @override
  String get featureMaintain => 'Tính năng này đang được bảo trì, vui lòng thử lại sau';

  @override
  String get errorContactSupport => 'Đã xảy ra lỗi, vui lòng liên hệ với bộ phận hỗ trợ';

  @override
  String get errorInternet => 'Không có kết nối internet';

  @override
  String get allTime => 'Không giới hạn';

  @override
  String get invalidDateRange => 'Khoảng thời gian mới phải bao gồm toàn bộ khoảng thời gian hiện tại.';

  @override
  String get emailNotFound => 'Email không tồn tại';

  @override
  String get weAreSendEmailPassword => 'Chúng tôi đã gửi email để bạn đặt lại mật khẩu. Vui lòng kiểm tra hộp thư.';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get resetPasswordTitle => 'Quên mật khẩu?';

  @override
  String get resetPasswordDescription => 'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi cho bạn hướng dẫn để đặt lại mật khẩu.';

  @override
  String get invalidPhoneNumber => 'Số điện thoại không hợp lệ';

  @override
  String get dailyTransactionReminder => 'Nhắc nhở giao dịch hàng ngày';

  @override
  String get guestAccess => 'Truy cập khách';

  @override
  String get loginToUse => 'Bạn cần đăng nhập để sử dụng tính năng này';

  @override
  String pAccountAlreadyHasExistingData(Object accountName) {
    return 'Tài khoản $accountName đã có dữ liệu. Nếu bạn tiếp tục đăng nhập, toàn bộ dữ liệu hiện tại sẽ bị xóa.\nBạn có chắc chắn muốn tiếp tục không?';
  }

  @override
  String get loginCancelledByUser => 'Đăng nhập đã bị hủy bởi người dùng';

  @override
  String get syncLocalToCloud => 'Lưu trữ dữ liệu cục bộ lên cloud';

  @override
  String get syncLocalToCloudLoading => 'Đang đồng bộ hóa dữ liệu cục bộ lên đám mây...';

  @override
  String get syncLocalToCloudSuccess => 'Đồng bộ hóa dữ liệu cục bộ lên đám mây thành công';

  @override
  String get syncLocalToCloudError => 'Đã xảy ra lỗi khi đồng bộ hóa dữ liệu cục bộ lên đám mây. Vui lòng thử lại sau';

  @override
  String get totalBalance => 'Tổng số dư';

  @override
  String get incomeExpenseThisMonth => 'THU - CHI THÁNG NÀY';

  @override
  String get totalRevenue => 'Tổng Thu';

  @override
  String get totalCost => 'Tổng Chi';

  @override
  String pSpent(Object value) {
    return 'Đã chi $value%';
  }

  @override
  String get noBudgetsAvailable => 'Không có ngân sách nào khả dụng';

  @override
  String get noRecentTransactions => 'Không có giao dịch gần đây nào';

  @override
  String get transactionHistory => 'Lịch Sử Giao Dịch';

  @override
  String get monthlySummary => 'Tóm Tắt Tháng';

  @override
  String get netBalance => 'Số Dư';

  @override
  String get budgetPageDesc => 'Quản lý và theo dõi ngân sách của bạn';

  @override
  String get errorValidateForm => 'Hãy chỉnh sửa các lỗi có trong biểu mẫu.';

  @override
  String get protected => 'Bảo vệ';

  @override
  String get initializingTheApplication => 'Đang khởi tạo ứng dụng...';

  @override
  String get selectAll => 'Chọn tất cả';

  @override
  String get removeAll => 'Xóa tất cả';

  @override
  String get noAppToOpen => 'Không tìm thấy ứng dụng nào để mở tập tin này.';

  @override
  String pFileNotFound(Object file) {
    return 'Tệp không được tìm thấy: $file';
  }

  @override
  String get permissionDenied => 'Quyền truy cập bị từ chối';

  @override
  String get transaction => 'Giao dịch';

  @override
  String get budgetDistribution => 'Phân bổ ngân sách';

  @override
  String get noBudgetsSelectedTransaction => 'Chưa có ngân sách cho loại giao dịch này';

  @override
  String get incomeVsExpense => 'Thu nhập và Chi tiêu';

  @override
  String get incomeAnalysis => 'Phân tích thu nhập';

  @override
  String get expenseAnalysis => 'Phân tích chi tiêu';

  @override
  String get budgetBreakdown => 'Chi tiết ngân sách';

  @override
  String get incomeBudgetDistribution => 'Phân bổ ngân sách thu nhập';

  @override
  String get expenseBudgetDistribution => 'Phân bổ ngân sách chi tiêu';

  @override
  String get progress => 'Tiến trình';

  @override
  String get incomeProgress => 'Tiến trình thu nhập';

  @override
  String get spendingProgress => 'Tiến trình chi tiêu';

  @override
  String get defaultBudgetHousing => 'Nhà ở';

  @override
  String get defaultBudgetFood => 'Ăn uống';

  @override
  String get defaultBudgetTransportation => 'Đi lại';

  @override
  String get defaultBudgetUtilities => 'Tiện ích';

  @override
  String get defaultBudgetEntertainment => 'Giải trí';

  @override
  String get defaultBudgetHealthcare => 'Y tế';

  @override
  String get defaultBudgetShopping => 'Mua sắm';

  @override
  String get defaultBudgetSalary => 'Lương';

  @override
  String get defaultBudgetFreelance => 'Freelance';

  @override
  String get defaultBudgetInvestments => 'Đầu tư';

  @override
  String get skip => 'Bỏ qua';
}
