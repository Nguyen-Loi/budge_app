import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/picker/b_picker_month.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/enums/transaction_type_enum.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/view/history_view/controller/history_controller.dart';
import 'package:budget_app/view/history_view/model/budget_transaction_custom_model.dart';
import 'package:budget_app/view/history_view/widgets/history_item_tab.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> get _tabs => [
        Tab(
          text: context.loc.income,
        ),
        Tab(
          text: context.loc.expense,
        ),
      ];

  List<Widget> _tabData(
      {required List<BudgetTransactionCustomModel> listIn,
      required List<BudgetTransactionCustomModel> listEx}) {
    return [
      HistoryItemTab(list: listIn),
      HistoryItemTab(list: listEx),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        gapH40,
        TabBar(controller: _tabController, tabs: _tabs),
        gapH16,
        Expanded(child: _builder())
      ],
    );
  }

  Widget _builder() {
    return Consumer(builder: (_, ref, __) {
      return ref.watch(historyFutureProvider).when(
          data: (items) {
            final listIn = items
                .where((e) =>
                    e.transaction.transactionType == TransactionType.increase)
                .toList();
            final listEx = items
                .where((e) =>
                    e.transaction.transactionType == TransactionType.decrease)
                .toList();
            return Column(
              children: [
                BPickerMonth(
                    initialDate: ref
                        .watch(historyControllerProvider.notifier)
                        .dateTimePicker,
                    firstDate: ref.watch(userControllerProvider
                        .select((value) => value!.createdDate)),
                    lastDate: DateTime.now(),
                    onChange: (date) async {
                      ref
                          .read(historyControllerProvider.notifier)
                          .updateDate(date);
                      ref.invalidate(historyFutureProvider);
                    }),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabData(listIn: listIn, listEx: listEx),
                  ),
                )
              ],
            );
          },
          error: (_, __) => const BStatus.error(),
          loading: () => const BStatus.loading());
    });
  }
}
