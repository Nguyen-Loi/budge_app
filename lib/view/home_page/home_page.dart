import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_dropdown.dart';
import 'package:budget_app/common/widget/b_search_bar.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/constants/icon_constants.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budget_list/home_budget_list.dart';
import 'package:budget_app/view/home_page/widgets/home_statistical_card/home_income_and_expense_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _searchController = TextEditingController();
  List<String> get listCategory => ['A', 'B', 'C', 'D'];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // ref.read(uidControllerProvider.notifier).init(context);
    //// ref.watch();
    return ref.watch(userFutureProvider).when(
        data: (_) => body(),
        error: (_, __) => const BStatus.error(),
        loading: () => const BStatus.loading());
  }

  Widget body() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          gapW16,
          const SizedBox.shrink(),
          Expanded(
            child: _appbarInfo(),
          ),
          gapW16,
          GestureDetector(
              onTap: () {}, child: Icon(IconConstants.notification)),
          gapW16,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _cardBalance(),
          gapH16,
          const HomeIncomeAndExpenseCard(),
          gapH16,
          _searchAndCategory(),
          gapH16,
          const HomeBudgetList()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.budgetNew);
        },
        child: Icon(IconConstants.add, color: ColorManager.white),
      ),
    );
  }

  Widget _searchAndCategory() {
    return Row(
      children: [
        Expanded(
          child: BSearchBar(
            controller: _searchController,
            hintText: 'Search ...',
          ),
        ),
        gapW16,
        BDropdown<String>(
            value: listCategory.isNotEmpty ? listCategory.first : null,
            label: (v) => v.toString(),
            items: listCategory,
            onChanged: (v) => {})
      ],
    );
  }

  Widget _cardBalance() {
    return Consumer(builder: (_, ref, __) {
      final UserModel user = ref.watch(userControllerProvider)!;
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: ColorManager.primary,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BAvatar.network(user.profileUrl),
                gapH24,
                BText('Your available lalance is', color: ColorManager.white),
                gapH16,
                BText.h1('\$ 2028', color: ColorManager.white),
              ],
            )),
      );
    });
  }

  Widget _appbarInfo() {
    return Consumer(builder: (_, ref, __) {
      final UserModel user = ref.watch(userControllerProvider)!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BTextRichSpace(text1: 'Hello ', text2: user.name),
          gapH8,
          const BText.caption('Your finances are looking good'),
        ],
      );
    });
  }
}
