import 'package:budget_app/common/color_manager.dart';
import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum _Status { loading, error, empty }

class BStatus extends StatelessWidget {
  const BStatus.error({super.key, this.text = 'Error'})
      : _status = _Status.error;
  const BStatus.loading({super.key, this.text = 'Loading...'})
      : _status = _Status.loading;
  const BStatus.empty({super.key, this.text = 'No data'})
      : _status = _Status.empty;

  final String text;
  final _Status _status;
  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _Status.loading:
        return _loading();
      case _Status.error:
        return _error();
      case _Status.empty:
        return _empty();
    }
  }

  Widget _loading() {
    return Column(
      children: [
        Lottie.asset(LottieAssets.loading1),
        gapH16,
        BText.b1(text, color: ColorManager.grey1),
      ],
    );
  }

  Widget _error() {
    return Lottie.asset(LottieAssets.error);
  }

  Widget _empty() {
    return Column(
      children: [
        Lottie.asset(LottieAssets.empty),
        gapH16,
        BText.b1(text, color: ColorManager.grey1),
      ],
    );
  }
}
