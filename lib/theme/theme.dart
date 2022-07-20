
import 'package:flutter/material.dart';

import 'color.dart';

ThemeData appTheme() {
  return ThemeData(
    iconTheme: new IconThemeData(color: Colors.green),
    primarySwatch: Colors.green,
  );
}

getPadding({@required context, top: 0.0, right: 0.0, bottom: 0.0, left: 0.0}) {
  return EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
}

