import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';

class robotoTextWidget extends StatelessWidget {
  final String textval;
final Color? colorval;
  final FontWeight fontWeight;
final double sizeval;
  const robotoTextWidget({ required this.textval,required this.colorval,required this.sizeval, required this.fontWeight}) ;

  @override
  Widget build(BuildContext context) {
    return Text(
      textval,
      style:  TextStyle(fontSize: sizeval,color: colorval, fontWeight: fontWeight,fontFamily: 'Roboto'),
    );
  }
}