import 'package:budget_app/common/widget/async/b_async_list.dart';
import 'package:budget_app/common/widget/b_icon.dart';
import 'package:budget_app/view/home_page/widgets/home_transactions_recently/controller/home_transactions_recently_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTransactionsRecently extends ConsumerWidget {
  const HomeTransactionsRecently({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BListAsync(
        data: ref.watch(homeTransactionsRecentlyFutureProvider),
        itemBuilder: (context, model) {
          return Card(
            child: ListTile(
              leading: BIcon(id: model.budget.iconId),
            ),
          );
        });
  }
}
