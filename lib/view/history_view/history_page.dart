// import 'package:budget_app/common/log.dart';
// import 'package:budget_app/common/widget/picker/b_picker_month.dart';
// import 'package:budget_app/constants/gap_constants.dart';
// import 'package:budget_app/view/history_view/controller/history_controller.dart';
// import 'package:budget_app/view/history_view/widgets/history_item_tab_expense.dart';
// import 'package:budget_app/view/history_view/widgets/history_item_tab_income.dart';
// import 'package:flutter/material.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({Key? key}) : super(key: key);

//   @override
//   State<HistoryPage> createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage>
//     with TickerProviderStateMixin {
//   late final TabController _tabController;

//   final HistoryController _controller = HistoryController();

//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
//     _controller.init();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<Widget> get _tabs => [
//         const Tab(
//           text: 'Income',
//         ),
//         const Tab(
//           text: 'Expense',
//         ),
//       ];

//   List<Widget> _tabData() {
//     return [
//       HistoryItemTabIncome(list: _controller.budgetsIncome),
//       HistoryItemTabExpense(list: _controller.budgetsExpense),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         gapH24,
//         TabBar(controller: _tabController, tabs: _tabs),
//         gapH16,
//         BPickerMonth(onChange: (date) {
//           logSuccess(date.toString());
//         }),
//         gapH16,
//         Expanded(
//           child: TabBarView(
//             controller: _tabController,
//             children: _tabData(),
//           ),
//         )
//       ],
//     );
//   }
// }
