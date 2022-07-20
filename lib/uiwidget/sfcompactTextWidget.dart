import 'dart:ui';

import 'package:flutter/cupertino.dart';

class SFCompactTextWidget extends StatelessWidget {
  final String textval;
  final Color? colorval;
  final FontWeight fontWeight;
  final double sizeval;

  const SFCompactTextWidget(
      {required this.textval,
      required this.colorval,
      required this.sizeval,
      required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      textval,
      style: TextStyle(
          fontSize: sizeval,
          color: colorval,
          fontWeight: fontWeight,
          fontFamily: 'SFCompactText'),
    );
  }
}
