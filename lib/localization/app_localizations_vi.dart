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
  String get welecomeAppName => 'Chào mừng đến với ứng dụng Ví Nhỏ!';

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
  String get emailHint => 'peter@gmail.com';

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
  String get spendLimitPerMonth => 'Giới hạn chi tiêu hàng tháng';

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
  String get financesGood => 'Tình hình tài chính của bạn dường như khá tốt';

  @override
  String get newExpense => 'Chi tiêu mới';

  @override
  String get myAccount => 'Tài khoản của tôi';

  @override
  String get modify => 'Sửa đổi';

  @override
  String get readOnly => 'Chỉ đọc';

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
  String pUserJoinDescriptions(Object dateTime, Object numberMonth) {
    return 'Bạn đã tham gia Ví Nhỏ vào ngày $dateTime. Đã qua $numberMonth tháng từ đó và sứ mệnh của chúng tôi vẫn là giúp bạn quản lý tiền của mình tốt hơn';
  }

  @override
  String get home => 'Trang chủ';

  @override
  String get appName => 'Ví Nhỏ';

  @override
  String get left => 'Còn lại';

  @override
  String get approaced => 'Tiếp cận';

  @override
  String get exceeded => 'Vượt quá';

  @override
  String get anErrorUnexpectedOccur => 'Đã xảy ra một lỗi không mong muốn';

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
  String nForgotPassword(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString errorText',
      one: ' mật khẩu?',
      zero: 'Quên',
    );
    return '$_temp0';
  }

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
  String get deposit => 'Tiền chuyển đến';

  @override
  String get withdrawal => 'Tiền chuyển đi';

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
  String get operatingPeriod => 'Khoảng thời gian';

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
  String get incomeWallet => 'Ví thu nhập';

  @override
  String get expenseWallet => 'Ví chi tiêu';

  @override
  String get incomeBudget => 'Ngân sách thu nhập';

  @override
  String get expenseBudget => 'Ngân sách chi tiêu';

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
  String get currentExpense => 'Chi phí hiện tại';

  @override
  String get startIncome => 'Bắt đầu theo dõi thu nhập của bạn để đảm bảo bạn đạt mục tiêu tài chính.';

  @override
  String get processIncome => 'Thu nhập của bạn đang ổn định. Hãy cố gắng để đạt được mục tiêu tài chính.';

  @override
  String get almostDoneIncome => 'Bạn gần đạt được mục tiêu thu nhập. Hãy tiếp tục duy trì!';

  @override
  String get completeIncome => 'Xuất sắc! Bạn đã đạt hoặc vượt mục tiêu thu nhập.';

  @override
  String get startExpense => 'Bắt đầu theo dõi chi tiêu của bạn để tránh vượt quá ngân sách.';

  @override
  String get processExpense => 'Chi tiêu của bạn đang trong tầm kiểm soát. Tiếp tục quản lý chặt chẽ nhé!';

  @override
  String get almostDoneExpense => 'Bạn sắp hoàn thành mục tiêu chi tiêu. Đừng quên giữ chi tiêu dưới mức cho phép!';

  @override
  String get completeExpense => 'Chú ý, ngân sách của bạn đã chạm mức giới hạn!';

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
}
