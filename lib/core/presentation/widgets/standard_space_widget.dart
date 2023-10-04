import 'package:flutter/material.dart';
import 'package:regression/core/constants.dart';

class StandardSpaceWidget extends StatelessWidget {
  final double space;
  final bool isHorizontal;
  const StandardSpaceWidget.horizontal({
    super.key,
    this.space = krPadding,
  }) : isHorizontal = true;

  const StandardSpaceWidget.vertical({
    super.key,
    this.space = krPadding,
  }) : isHorizontal = false;

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? SizedBox(width: space) : SizedBox(height: space);
  }
}
