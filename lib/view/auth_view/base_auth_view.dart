import 'package:budget_app/common/widget/b_text.dart';
import 'package:budget_app/constants/gap_constants.dart';
import 'package:budget_app/core/extension/extension_widget.dart';
import 'package:flutter/material.dart';

class BaseAuthView extends StatelessWidget {
  const BaseAuthView({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: BText.appbar(title),
              centerTitle: true,
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    gapH24,
                    ...children.responsiveCenter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
