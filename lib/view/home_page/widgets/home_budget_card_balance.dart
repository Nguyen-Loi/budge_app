import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/log.dart';
import 'package:budget_app/common/widget/b_avatar.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/view/home_page/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeBudgetCardBalance extends ConsumerWidget {
  const HomeBudgetCardBalance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logError('rebuild card');
    bool isLoading = ref.watch(homeControllerProvider);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: ColorManager.primary,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? Column(
                children: [
                  BAvatar.network(ref.read(userProvider).profileUrl),
                  gapH24,
                  BText('Your available lalance is', color: ColorManager.white),
                  gapH16,
                  BText.h1('\$ 2028', color: ColorManager.white),
                ],
              )
            : Column(
                children: [
                  const BAvatar.network(
                      'https://acpro.edu.vn/hinh-nhung-chu-meo-de-thuong/imager_173.jpg'),
                  gapH24,
                  BText('----------------------', color: ColorManager.white),
                  gapH16,
                  BText.h1('\$ ----', color: ColorManager.white),
                ],
              ),
      ),
    );
  }
}
