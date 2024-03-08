import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BSearchBar extends StatelessWidget {
  const BSearchBar({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: controller,
      leading:  Icon(IconConstants.search),
      trailing: <Widget>[
        Tooltip(
          message: 'Clear',
          child: IconButton(
            onPressed: () {
              controller.clear();
            },
            icon: controller.text.isEmpty
                ? const SizedBox.shrink()
                : Icon(IconConstants.clear),
          ),
        )
      ],
    );
  }
}
