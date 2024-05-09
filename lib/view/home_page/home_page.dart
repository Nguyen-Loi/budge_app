import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/core/route_path.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/models/user_model.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/home_page/home_transactions_recently.dart';
import 'package:budget_app/view/home_page/widgets/home_update_wallet_card.dart';
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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          gapW16,
          const SizedBox.shrink(),
          Expanded(
            child: _appbarInfo(),
          ),
          gapW16,
          GestureDetector(onTap: () {}, child: Icon(IconManager.notification)),
          gapW16,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          HomeUpdateWalletCard(),
          gapH16,
          HomeTransactionsRecently(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.newBudget);
        },
        child: Icon(IconManager.add, color: ColorManager.white),
      ),
    );
  }

  Widget _appbarInfo() {
    return Consumer(builder: (_, ref, __) {
      final UserModel user = ref.watch(userBaseControllerProvider)!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BTextRichSpace(text1: '${context.loc.hello} ', text2: user.name),
          gapH8,
          BText.caption(context.loc.financesGood),
        ],
      );
    });
  }
}
