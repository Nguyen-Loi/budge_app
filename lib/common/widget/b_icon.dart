import 'package:budget_app/core/icon_manager.dart';
import 'package:budget_app/models/models_widget/icon_model.dart';
import 'package:flutter/material.dart';

class BIcon extends StatelessWidget {
  final int id;
  final double? size;
  const BIcon({super.key, required this.id, this.size});

  IconModel get icon => IconManager.getIconModel(id);
  @override
  Widget build(BuildContext context) {
    return Icon(icon.iconData, color: icon.color, size: size);
  }
}
