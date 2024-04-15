import 'package:budget_app/common/widget/b_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BAsyncData extends StatelessWidget {
  final AsyncValue<void> async;
  final Widget Function(BuildContext context) builder;

  const BAsyncData({super.key, required this.async, required this.builder});
  @override
  Widget build(BuildContext context) {
    return async.when(
        data: (_) => builder(context),
        error: (_, __) => const BStatus.error(),
        loading: () => const BStatus.loading());
  }
}
