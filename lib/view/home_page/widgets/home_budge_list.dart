import 'package:budget_app/common/widget/b_list_builder_async.dart';
import 'package:budget_app/common/widget/b_status.dart';
import 'package:budget_app/common/widget/with_spacing.dart';
import 'package:budget_app/models/budget_model.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:budget_app/view/home_page/widgets/home_budge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBudgeList extends ConsumerWidget {
  const HomeBudgeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BListBuilderAsync(
        data: ref.watch(getBudgetsProvider),
        itemBuilder: (_, budget) => HomeBudgeCard(model: budget));
  }
}
