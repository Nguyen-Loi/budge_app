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
  String get welecomeAppName => 'Chào mừng đến với ứng dụng Ví Chi Tiêu!';

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
  String get name => 'Họ tên';

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
  String get appName => 'Ví chi tiêu';

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
  String get accountCreateSuccess => 'Tạo tài khoản thành công!';

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
  String get invalidDateRange => 'Khoảng thời gian mới cần phải bao trùm toàn bộ khoảng thời gian hiện tại.';

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
  String get defaultBudgetInvestments => 'Investments';

  @override
  String get skip => 'Skip';

  @override
  String get createdByViBot => 'Được tạo bởi ViBot';

  @override
  String get viBotPersonality => 'Bạn là ViBot, một trợ lý tài chính cá nhân thân thiện và hữu ích cho ứng dụng Smart Budget.';

  @override
  String get viBotPersonalityTraits => 'Hãy ấm áp, khuyến khích và hỗ trợ về các mục tiêu tài chính\n- Giữ câu trả lời ngắn gọn nhưng đầy đủ thông tin\n- Sử dụng biểu tượng cảm xúc một cách tiết kiệm nhưng phù hợp\n- Chúc mừng những thành tựu tài chính và nhẹ nhàng hướng dẫn về việc chi tiêu quá mức';

  @override
  String get viBotCapabilities => '**Xử lý giao dịch**: Phân tích ngôn ngữ tự nhiên như \"Ăn trưa 50k\", \"Cà phê 30k hôm qua\", \"Trả tiền điện 100k\"\n2. **Quản lý ngân sách**: Tự động tạo ngân sách mới khi được đề cập\n3. **Thông tin thông minh**: Cung cấp tóm tắt chi tiêu và trạng thái ngân sách\n4. **Hành động nhanh**: Hỗ trợ chỉnh sửa, xóa và thêm ghi chú cho giao dịch';

  @override
  String viBotUserInfo(Object balance, Object currency, Object name) {
    return 'Thông tin người dùng hiện tại:\n- Tên: $name\n- Số dư: $balance\n- Tiền tệ: $currency';
  }

  @override
  String viBotAvailableBudgets(Object budgets) {
    return 'Ngân sách khả dụng: $budgets';
  }

  @override
  String get viBotTransactionRules => 'Khi xử lý giao dịch:\n- Luôn tạo giao dịch với ghi chú \"Được tạo bởi ViBot\"\n- Nếu ngân sách không tồn tại, đề cập rằng bạn đang tạo nó\n- Cung cấp tóm tắt chi tiêu sau giao dịch\n- Cảnh báo nhẹ nhàng nếu sắp đạt giới hạn ngân sách\n- Đề xuất tạo ngân sách cho các danh mục không được nhận dạng';

  @override
  String get viBotResponseFormat => 'Định dạng phản hồi cho giao dịch:\n- Xác nhận những gì đã được ghi nhận\n- Hiển thị trạng thái ngân sách nếu có liên quan\n- Đưa ra các bước tiếp theo hữu ích\n- Giữ tính trò chuyện và thân thiện';

  @override
  String get viBotExampleUser1 => 'Ăn trưa 50k';

  @override
  String get viBotExampleBot1 => 'Tôi đã ghi nhận khoản chi 50k cho bữa trưa của bạn! 🍽️ Bạn còn 150k trong ngân sách Ăn trưa tháng này.';

  @override
  String get viBotExampleUser2 => 'Quán cà phê 30k hôm qua';

  @override
  String get viBotExampleBot2 => 'Đã ghi! Tôi đã thêm khoản chi 30k cà phê hôm qua. Tôi đã tạo ngân sách \'Cà phê\' mới cho bạn vì đây là lần đầu bạn mua cà phê.';

  @override
  String get viBotClosing => 'Luôn hữu ích, chính xác và khuyến khích về quản lý tài chính!';

  @override
  String get refresh => 'Làm mới';

  @override
  String get removeChatTitle => 'Xóa cuộc trò chuyện';

  @override
  String get removeChatMessage => 'Bạn có chắc chắn muốn xóa cuộc trò chuyện này không?';

  @override
  String get signingOutLoading => 'Đang đăng xuất...';

  @override
  String get currency => 'Tiền tệ';

  @override
  String get usdCurrencyName => 'Đô la Mỹ';

  @override
  String get eurCurrencyName => 'Euro';

  @override
  String get jpyCurrencyName => 'Yên Nhật';

  @override
  String get vndCurrencyName => 'Đồng Việt Nam';

  @override
  String get cadCurrencyName => 'Đô la Canada';

  @override
  String get contactUs => 'Liên hệ';

  @override
  String get contactUsDesc => 'Chúng tôi sẵn sàng hỗ trợ và giải đáp mọi thắc mắc của bạn.';

  @override
  String get sendEmail => 'Gửi email';

  @override
  String get emailSupport => 'Hỗ trợ email';

  @override
  String get emailSupportDesc => 'Trợ giúp về tài khoản và thanh toán';

  @override
  String get phoneSupport => 'Hỗ trợ điện thoại';

  @override
  String get phoneSupportDesc => 'Có mặt Thứ 2 - Thứ 6, 9:00 - 18:00 giờ EST';

  @override
  String get followUs => 'Theo dõi chúng tôi';

  @override
  String get getInTouch => 'Kết nối với chúng tôi';

  @override
  String get copyEmail => 'Sao chép email';

  @override
  String get copyPhone => 'Sao chép số điện thoại';

  @override
  String get quickActions => 'Thao tác nhanh';

  @override
  String pSubjectContactUsEmail(Object appName) {
    return 'Hỗ trợ ứng dụng $appName';
  }

  @override
  String pBodyContactUsEmail(Object appName) {
    return 'Xin chào đội ngũ $appName,\n\nTôi cần trợ giúp về vấn đề sau:\n\n';
  }

  @override
  String pCopyToClipboard(Object value) {
    return 'Đã sao chép: $value';
  }

  @override
  String get userNameDefault => 'Khách';

  @override
  String get agreeToTerms => 'Bằng việc tiếp tục, bạn đồng ý với Điều khoản & Chính sách Bảo mật của chúng tôi';

  @override
  String get selectCurrencyDesc => 'Chọn loại tiền tệ ưa thích của bạn cho giao dịch';

  @override
  String get tellUsYourNameToGetStarted => 'Hãy cho chúng tôi biết tên của bạn để bắt đầu';

  @override
  String get letPersonalizeYourExperience => 'Hãy cá nhân hóa trải nghiệm của bạn';

  @override
  String get smartBudgetPlanning => 'Lập Kế hoạch Ngân sách Thông minh';

  @override
  String get easyExpenseTracking => 'Theo dõi Chi tiêu Dễ dàng';

  @override
  String get detailedReports => 'Báo cáo Chi tiết';

  @override
  String get next => 'Tiếp theo';

  @override
  String get takeControlOfYourFinances => 'Kiểm soát tài chính của bạn với việc lập ngân sách thông minh và theo dõi chi tiêu';

  @override
  String get chooseYourCurrency => 'Chọn loại tiền tệ của bạn';

  @override
  String pShowingBudgetsFor(Object data) {
    return 'Hiển thị ngân sách cho $data';
  }

  @override
  String get thankYouYourFeedback => 'Cảm ơn bạn đã gửi phản hồi của mình! Chúng tôi sẽ xem xét và trả lời sớm nhất có thể.';

  @override
  String get enterYourName => 'Nhập tên của bạn';

  @override
  String get feedback => 'Phản hồi';

  @override
  String get submitFeedback => 'Gửi Phản Hồi';

  @override
  String get submitFeedbackDesc => 'Giúp chúng tôi cải thiện ứng dụng bằng cách chia sẻ ý kiến và đề xuất của bạn.';

  @override
  String get ratingRequired => 'Đánh giá *';

  @override
  String get rate1Desc => 'Rất kém';

  @override
  String get rate2Desc => 'Kém';

  @override
  String get rate3Desc => 'Trung bình';

  @override
  String get rate4Desc => 'Tốt';

  @override
  String get rate5Desc => 'Xuất sắc';

  @override
  String get titleRequired => 'Tiêu đề *';

  @override
  String get feedbackTitleHint => 'Tiêu đề phản hồi của bạn';

  @override
  String get feedbackRequired => 'Phản hồi *';

  @override
  String get feedbackDescHint => 'Chia sẻ trải nghiệm, đề xuất hoặc vấn đề của bạn...';

  @override
  String get feedbackSuccess => 'Cảm ơn phản hồi của bạn! Chúng tôi đánh giá cao đóng góp này và sẽ sử dụng để cải thiện ứng dụng.';

  @override
  String get submitting => 'Đang gửi...';

  @override
  String get myFeedback => 'Phản Hồi Của Tôi';

  @override
  String get noFeedbackYet => 'Chưa có phản hồi nào';

  @override
  String get overview => 'Tổng quan';

  @override
  String get netIncome => 'Thu nhập ròng';

  @override
  String get totalBudgets => 'Tổng ngân sách';

  @override
  String get totalTransactions => 'Tổng giao dịch';

  @override
  String get rankedByActivity => 'Xếp hạng theo hoạt động';

  @override
  String get transactionCount => 'Số giao dịch';

  @override
  String get detailedView => 'Xem chi tiết';

  @override
  String get incomeTransactions => 'Giao dịch thu được';

  @override
  String get expenseTransactions => 'Giao dịch chi ra';

  @override
  String get utilization => 'Khả năng sử dụng';

  @override
  String get noLimit => 'Không giới hạn';

  @override
  String get dataSyncConflict => 'Xung đột đồng bộ dữ liệu';

  @override
  String dataSyncConflictDesc(Object email) {
    return 'Cả dữ liệu cục bộ và dữ liệu trên máy chủ đều tồn tại cho $email. Bạn muốn tiếp tục như thế nào?';
  }

  @override
  String get useCurrentData => 'Sử dụng dữ liệu hiện tại';

  @override
  String get overwriteWithNewData => 'Ghi đè bằng dữ liệu mới';

  @override
  String get combineData => 'Kết hợp dữ liệu';

  @override
  String get chooseAvatar => 'Chọn Avatar';

  @override
  String get selectYourFavoriteAvatar => 'Chọn avatar yêu thích của bạn';

  @override
  String get openInBrowser => 'Mở trong trình duyệt';

  @override
  String get premium => 'Cao cấp';

  @override
  String get subscription => 'Đăng ký';

  @override
  String get upgradeToUnlockFeatures => 'Nâng cấp để mở khóa tính năng cao cấp';

  @override
  String get premiumBenefits => 'Lợi ích Cao cấp';

  @override
  String get noAds => 'Không quảng cáo';

  @override
  String get enjoyAdFreeExperience => 'Trải nghiệm không có quảng cáo';

  @override
  String get advancedReports => 'Báo cáo nâng cao';

  @override
  String get detailedAnalyticsAndInsights => 'Phân tích và thống kê chi tiết';

  @override
  String get dataExport => 'Xuất dữ liệu';

  @override
  String get exportYourDataAnytime => 'Xuất dữ liệu của bạn bất cứ lúc nào';

  @override
  String get prioritySupport => 'Hỗ trợ ưu tiên';

  @override
  String get getFastPersonalizedHelp => 'Nhận trợ giúp nhanh chóng và cá nhân hóa';

  @override
  String get unlimitedBudgets => 'Ngân sách không giới hạn';

  @override
  String get createAsMany => 'Tạo bao nhiêu ngân sách tùy ý';

  @override
  String get chooseYourPlan => 'Chọn gói của bạn';

  @override
  String get monthly => 'Hàng tháng';

  @override
  String get yearly => 'Hàng năm';

  @override
  String saveValuePercent(Object value) {
    return 'Tiết kiệm $value%';
  }

  @override
  String get mostPopular => 'Phổ biến nhất';

  @override
  String get perMonth => 'mỗi tháng';

  @override
  String get perYear => 'mỗi năm';

  @override
  String get subscribe => 'Đăng ký';

  @override
  String get restorePurchases => 'Khôi phục mua hàng';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get freeTrial => 'Dùng thử miễn phí 7 ngày';

  @override
  String get continueWithPremium => 'Tiếp tục với Cao cấp';

  @override
  String get upgradeNow => 'Nâng cấp ngay';

  @override
  String billedAnnuallyAt(Object amount) {
    return 'Được lập hóa đơn hàng năm tại $amount';
  }

  @override
  String get processing => 'Đang xử lý...';

  @override
  String failedToStartSubscription(Object errorMessage) {
    return 'Lỗi khi bắt đầu đăng ký. Vui lòng thử lại: $errorMessage';
  }

  @override
  String get bannerDismissed => 'Đã bỏ qua quảng cáo';

  @override
  String get purchaseSuccessful => 'Mua hàng thành công! Đăng ký của bạn hiện đã hoạt động.';

  @override
  String purchaseFailed(Object errorMessage) {
    return 'Mua hàng thất bại: $errorMessage';
  }

  @override
  String get unknownError => 'Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.';

  @override
  String get purchaseCanceledByUser => 'Đơn hàng đã bị hủy bởi người dùng.';

  @override
  String get purchasePending => 'Đơn hàng đang chờ xử lý. Vui lòng chờ xác nhận.';

  @override
  String get purchaseRestored => 'Đơn hàng đã được khôi phục thành công.';

  @override
  String get errorLoadingProducts => 'Lỗi khi tải sản phẩm. Vui lòng thử lại sau.';
}
