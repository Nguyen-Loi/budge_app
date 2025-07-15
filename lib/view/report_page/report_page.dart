import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/size_constants.dart';
import 'package:budget_app/core/ad_helper.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/base_controller/remote_config_base_controller.dart';
import 'package:budget_app/view/report_page/controller/report_page_controller.dart';
import 'package:budget_app/view/report_page/widgets/report_filter_dialog.dart';
import 'package:budget_app/view/report_page/widgets/smart_budget_chart.dart';
import 'package:budget_app/view/report_page/widgets/budget_transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    bool isPermissionAds =
        ref.read(remoteConfigBaseControllerProvider.notifier).isUserAds;
    if (isPermissionAds) {
      _loadBannerAd();
      _loadInterstitialAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          setState(() {
            _isBannerAdReady = false;
          });
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad for next time
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad for next time
        },
      );
      _interstitialAd!.show();
      _isInterstitialAdReady = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportPageControllerProvider);
    final controller = ref.read(reportPageControllerProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          _buildBody(context, reportState, controller),
          _buildPinnedBannerAd(),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReportFilterState state,
      ReportPageController controller) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        slivers: [
          _buildSliverHeader(context, state, controller),

          // Export Button Section
          SliverToBoxAdapter(
            child: _buildExportButtonSection(context, state, controller),
          ),

          // Merged Statistics and Chart Section
          SliverToBoxAdapter(
            child:
                _buildMergedStatisticsChartSection(context, state, controller)
                    .responsiveCenter(),
          ),

          // Budget Transactions List
          SliverToBoxAdapter(
            child: _buildTransactionsSection(context, state).responsiveCenter(),
          ),

          // Bottom padding (increased to account for pinned banner ad)
          SliverToBoxAdapter(
            child: SizedBox(height: _isBannerAdReady ? 70 : 20),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, ReportFilterState state,
      ReportPageController controller) {
    return SliverAppBar(
      expandedHeight: 70,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: BText.appbar(
              context.loc.report,
            ),
          ),
          Positioned(
            right: 0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(IconManager.filter),
                  onPressed: () =>
                      _showFilterDialog(context, state, controller),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
          )
        ],
      ),
      floating: false,
      pinned: false,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildExportButtonSection(BuildContext context,
      ReportFilterState state, ReportPageController controller) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: SizeConstants.maxWidthBase,
          minWidth: SizeConstants.minWidthBase,
        ),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildExportButton(context, state, controller)),
      ),
    );
  }

  Widget _buildExportButton(BuildContext context, ReportFilterState state,
      ReportPageController controller) {
    final hasData = state.budgetTransactionsList.isNotEmpty;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final disabledColor = Theme.of(context).colorScheme.onSurface;
    final textColor = hasData
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).disabledColor;
    return GestureDetector(
      onTap: hasData && !state.isLoading
          ? () {
              _showInterstitialAd();
              controller.exportExcel(context);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasData
                ? primaryColor.withAlpha(100)
                : disabledColor.withAlpha(60),
          ),
          color: hasData
              ? primaryColor.withAlpha(200)
              : disabledColor.withAlpha(120),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (state.isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                IconManager.excel,
                color: textColor,
                size: 20,
              ),
            gapH4,
            BText(
              context.loc.exportExcel,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMergedStatisticsChartSection(BuildContext context,
      ReportFilterState state, ReportPageController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    IconManager.reportBar,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  gapW8,
                  BText.b1(
                    context.loc.report,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              gapH16,

              // Chart Section (removed separate statistics)
              if (state.chartData.isEmpty)
                _baseChartEmpty(
                    icon: IconManager.reportBar, message: context.loc.noData)
              else
                SmartBudgetChart(
                  chartData: state.chartData,
                  chartType: ChartType.auto,
                  showIncomeExpenseBreakdown: true,
                  period: _formatDateRange(state.dateTimeRange),
                  transactionTypes: state.transactionTypes,
                  transactionCount:
                      controller.getStatistics()['transactionCount'] as int,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(
      BuildContext context, ReportFilterState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Icon(
                  IconManager.budgetBar,
                  color: Theme.of(context).colorScheme.primary,
                ),
                gapW8,
                BText.b1(
                  context.loc.budgets,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          if (state.budgetTransactionsList.isEmpty)
            _baseChartEmpty(
                icon: IconManager.transactionBar,
                message: context.loc.noTransactionDescription)
          else
            ColumnWithSpacing(
              spacing: 12,
              children: state.budgetTransactionsList
                  .map((budgetTransaction) => BudgetTransactionCard(
                        budgetTransaction: budgetTransaction,
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _baseChartEmpty({required IconData icon, required String message}) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withAlpha(150),
          ),
          gapH16,
          BText(
            message,
            color: Theme.of(context).colorScheme.primary.withAlpha(150),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedBannerAd() {
    if (_isBannerAdReady && _bannerAd != null) {
      return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _formatDateRange(DateTimeRange range) {
    final start = "${range.start.day}/${range.start.month}/${range.start.year}";
    final end = "${range.end.day}/${range.end.month}/${range.end.year}";
    return "$start - $end";
  }

  void _showFilterDialog(BuildContext context, ReportFilterState state,
      ReportPageController controller) {
    showDialog(
      context: context,
      builder: (context) => ReportFilterDialog(
        currentState: state,
        availableBudgets: controller.availableBudgets,
        availableTransactionTypes: controller.availableTransactionTypes,
        dateRangeOptions: controller.dateRangeOptions,
        firstDate: controller.firstTransactionDate,
        lastDate: controller.lastTransactionDate,
        getRelevantBudgets: controller.getRelevantBudgets,
        onFiltersChanged: (dateRange, transactionTypes, budgetIds) {
          controller.setFilters(
            dateTimeRange: dateRange,
            transactionTypes: transactionTypes,
            selectedBudgetIds: budgetIds,
          );
        },
      ),
    );
  }
}
