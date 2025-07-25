import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/mixin/floating_action_transaction_mixin.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/picker/b_picker_month_dialog.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/ad_helper.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/core/extension/extension_datetime.dart';
import 'package:budget_app/core/extension/extension_iterable.dart';
import 'package:budget_app/core/extension/extension_money.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/data/models/merge_model/transaction_card_model.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/base_controller/transaction_base_controller.dart';
import 'package:budget_app/view/transactions_view/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TransactionState {
  final List<TransactionCardModel> transactions;
  final int sumIncome;
  final int sumExpense;

  TransactionState({
    required this.transactions,
    required this.sumIncome,
    required this.sumExpense,
  });

  TransactionState copyWith({
    List<TransactionCardModel>? transactions,
    int? sumIncome,
    int? sumExpense,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      sumIncome: sumIncome ?? this.sumIncome,
      sumExpense: sumExpense ?? this.sumExpense,
    );
  }
}

class TransactionView extends ConsumerStatefulWidget {
  const TransactionView({super.key});

  @override
  ConsumerState<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends ConsumerState<TransactionView>
    with FloatingActionMixin {
  BannerAd? _bannerAd;

  @override
  void initState() {
    bool isPermissionAds =
        ref.read(remoteConfigBaseControllerProvider.notifier).isUserAds;

    if (isPermissionAds) {
      _loadBannerAd();
    }
    super.initState();
  }

  void _loadBannerAd() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          logError('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverHeader(),
              SliverToBoxAdapter(
                child: _buildSummarySection(),
              ),
              _buildTransactionList(),
            ],
          ),
          if (_bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: ColorManager.white,
                child: SizedBox(
                  height: _bannerAd!.size.height.toDouble(),
                  width: _bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 70,
      title: Consumer(builder: (_, ref, __) {
        final controller = ref.watch(transactionControllerProvider.notifier);
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: BText.appbar(
                context.loc.transactionHistory,
              ),
            ),
            Positioned(
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(IconManager.filter),
                    onPressed: () async {
                      DateTime? selectedDate = await BPickerMonthDialog.show(
                        context,
                        initialDate: controller.dateTimePicker,
                        firstDate: controller.dateRangeToFilter.start,
                        lastDate: controller.dateRangeToFilter.end,
                      );
                      if (selectedDate == null ||
                          selectedDate.isSameDate(controller.dateTimePicker)) {
                        return;
                      }
                      controller.updateDate(selectedDate);
                    },
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            )
          ],
        );
      }),
      floating: false,
      pinned: false,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildSummarySection() {
    return Consumer(builder: (_, ref, __) {
      final controller = ref.watch(transactionControllerProvider.notifier);
      final state = ref.watch(transactionControllerProvider);
      String timeFormat = controller.dateTimePicker.toFormatDate(
        strFormat: 'MM/yyyy',
      );
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            BText.b1(
              context.loc.monthlySummary,
              fontWeight: FontWeight.w600,
            ),
            BText.b1(
              timeFormat,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    label: context.loc.income,
                    value: state.sumIncome,
                    color: ColorManager.green,
                    icon: Icons.arrow_upward,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _summaryCard(
                    label: context.loc.expense,
                    value: state.sumExpense,
                    color: ColorManager.red,
                    icon: Icons.arrow_downward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _netIncomeCard(state),
          ],
        ),
      );
    });
  }

  Widget _summaryCard({
    required String label,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(50), color.withAlpha(5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(40),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          BText(
            label,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          const SizedBox(height: 4),
          BText(
            value.toMoneyStrContext(context),
            color: color,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _netIncomeCard(TransactionState transactionState) {
    final netIncome = transactionState.sumIncome - transactionState.sumExpense;
    final isPositive = netIncome >= 0;
    final color = isPositive ? ColorManager.green : ColorManager.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(40), color.withAlpha(20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(40),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              BText(
                context.loc.netBalance,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              BText.h3(
                netIncome.toMoneyStrContext(context),
                color: color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Consumer(builder: (_, ref, __) {
      final state = ref.watch(transactionControllerProvider);

      if (state.transactions.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              BStatus.empty(
                text: context.loc.noTransactionDescription,
              ),
              gapH80,
            ],
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withAlpha(20),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: TransactionCard(model: state.transactions[index]),
                ),
              );
            },
            childCount: state.transactions.length,
          ),
        ),
      );
    });
  }
}

final transactionControllerProvider =
    StateNotifierProvider.autoDispose<TransactionsController, TransactionState>(
        (ref) {
  final transactionBase = ref.watch(transactionsBaseControllerProvider);
  return TransactionsController(transactionsState: transactionBase);
});

class TransactionsController extends StateNotifier<TransactionState> {
  TransactionsController({
    required List<TransactionCardModel> transactionsState,
  })  : _transactionBase = transactionsState,
        super(TransactionState(transactions: [], sumIncome: 0, sumExpense: 0)) {
    updateDate(_dateTimePicker);
    _init();
  }
  final List<TransactionCardModel> _transactionBase;

  void _init() {
    final now = DateTime.now();
    if (_transactionBase.isEmpty) {
      _dateTimeRangeToFilter = now.getRangeMonth;
      return;
    }
    final allTransactions = _transactionBase.map((e) => e.transaction).toList();
    allTransactions
        .sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
    final start = allTransactions[0].transactionDate;
    final end = allTransactions.last.transactionDate.isBefore(now)
        ? now
        : allTransactions.last.transactionDate;
    _dateTimeRangeToFilter = DateTimeRange(start: start, end: end);
  }

  late DateTimeRange _dateTimeRangeToFilter;
  DateTimeRange get dateRangeToFilter => _dateTimeRangeToFilter;

  DateTime _dateTimePicker = DateTime.now();
  DateTime get dateTimePicker => _dateTimePicker;

  void updateDate(DateTime date) {
    _dateTimePicker = date;
    final filteredTransactions = _transactionBase
        .filterByMonth(
            time: _dateTimePicker,
            getDate: (x) => x.transaction.transactionDate)
        .toList();

    final sums = _calculateSums(filteredTransactions);

    state = TransactionState(
      transactions: filteredTransactions,
      sumIncome: sums.income,
      sumExpense: sums.expense,
    );
  }

  ({int income, int expense}) _calculateSums(
      List<TransactionCardModel> transactions) {
    int newIncome = 0;
    int newExpense = 0;
    for (var e in transactions) {
      switch (e.transaction.transactionType) {
        case TransactionTypeEnum.income:
          newIncome += e.transaction.amount;
          break;
        case TransactionTypeEnum.expense:
          newExpense += e.transaction.amount;
          break;
      }
    }
    return (income: newIncome, expense: newExpense.abs());
  }
}
