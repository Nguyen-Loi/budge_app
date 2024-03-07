import 'package:flutter/material.dart';

class BDivider extends StatelessWidget {
  final bool isHorizental;
  final double? width;
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  const BDivider.v({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.color,
    this.endIndent,
  })  : isHorizental = false,
        width = null;

  const BDivider.h({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.color,
    this.endIndent,
  })  : isHorizental = false,
        width = null;
  @override
  Widget build(BuildContext context) {
    return isHorizental ? _hDivider() : _vDivider();
  }

  Widget _vDivider() {
    return VerticalDivider(
      width: width,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  Widget _hDivider() {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
