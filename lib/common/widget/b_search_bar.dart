import 'package:budget_app/constants/icon_constants.dart';
import 'package:flutter/material.dart';

class BSearchBar extends StatefulWidget {
  const BSearchBar({Key? key, required this.controller, this.hintText})
      : super(key: key);
  final TextEditingController controller;
  final String? hintText;

  @override
  State<BSearchBar> createState() => _BSearchBarState();
}

class _BSearchBarState extends State<BSearchBar> {
  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: widget.controller,
      hintText: widget.hintText,
      onChanged: (value) {
        setState(() {});
      },
      leading: Icon(IconConstants.search),
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0)),
      trailing: <Widget>[
        widget.controller.text.isNotEmpty
            ? IconButton(
                isSelected: widget.controller.text.isNotEmpty,
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                },
                icon: Icon(IconConstants.clear),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
