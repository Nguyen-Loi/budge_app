import 'package:budget_app/common/widget/dialog/b_dialog_info.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/localization/app_localizations_context.dart';
import 'package:budget_app/data/models/user_model.dart';
import 'package:budget_app/theme/app_text_theme.dart';
import 'package:budget_app/view/base_controller/user_base_controller.dart';
import 'package:budget_app/view/home_page/home_transactions_recently.dart';
import 'package:budget_app/view/home_page/widgets/home_chart/home_chart.dart';
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
          GestureDetector(
              onTap: () {
                BDialogInfo(
                        message: context.loc.developingFreatures,
                        dialogInfoType: BDialogInfoType.warning)
                    .present(context);
              },
              child: Icon(IconManager.notification)),
          gapW16,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: const [
          HomeUpdateWalletCard(),
          gapH16,
          HomeChart(),
          gapH16,
          HomeTransactionsRecently(),
        ],
      ).responsiveCenter(),
    );
  }

  Widget _appbarInfo() {
    return Consumer(builder: (_, ref, __) {
      final UserModel user = ref.watch(userBaseControllerProvider);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          gapH8,
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: '${context.loc.hello} ',
                style: context.textTheme.bodyMedium),
            TextSpan(
                text: user.name,
                style: context.textTheme.bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
          ])),
          gapH8,
        ],
      );
    });
  }
}
