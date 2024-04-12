import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/common/widget/b_text_rich.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBudgetAppBar extends ConsumerWidget {
  const HomeBudgetAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logError('rebuild appbar');
    return ref.watch(fetchUserProvider).when(
        data: (_) {
          String userName = ref.read(userProvider).name;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BTextRichSpace(text1: 'Hello ', text2: userName),
              gapH8,
              const BText.caption('Your finances are looking good'),
            ],
          );
        },
        error: (_, __) => const BStatus.error(
              text: 'Error when load info user',
            ),
        loading: () => const BStatus.loading(text: 'Get info user...'));
  }
}
