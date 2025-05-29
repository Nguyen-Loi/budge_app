import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/assets_constants.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum _Status { loading, error, empty }

class BStatus extends StatelessWidget {
  const BStatus.error(
      {super.key,
      this.text = 'Error',
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisAlignment = MainAxisAlignment.center})
      : _status = _Status.error;
  const BStatus.loading(
      {super.key,
      this.text = 'Loading...',
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisAlignment = MainAxisAlignment.center})
      : _status = _Status.loading;
  const BStatus.empty(
      {super.key,
      this.text = 'No data',
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisAlignment = MainAxisAlignment.center})
      : _status = _Status.empty;

  final String text;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
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
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(LottieAssets.loading1),
        gapH16,
        BText.b1(
          text,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _error() {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(LottieAssets.error),
        gapH16,
        BText.b1(text,
            fontWeight: FontWeight.bold, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _empty() {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(LottieAssets.empty),
        gapH16,
        BText.b1(text,
            fontWeight: FontWeight.bold, textAlign: TextAlign.center),
      ],
    );
  }
}
