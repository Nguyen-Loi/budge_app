import 'package:budget_app/core/icon_manager.dart';
import 'package:flutter/material.dart';

class BSearchBar extends StatefulWidget {
  const BSearchBar({super.key, required this.controller, this.hintText});
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
      leading: Icon(IconManager.search),
      padding:
          const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
      trailing: <Widget>[
        widget.controller.text.isNotEmpty
            ? IconButton(
                isSelected: widget.controller.text.isNotEmpty,
                onPressed: () {
                  widget.controller.clear();
                  setState(() {});
                },
                icon: Icon(IconManager.clear),
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
