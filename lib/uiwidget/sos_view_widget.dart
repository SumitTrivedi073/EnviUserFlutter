import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

class SOSView extends StatefulWidget {
  final String? otp;

  // receive data from the FirstScreen as a parameter
  const SOSView({Key? key, required this.otp})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SOSViewPageState();
}

class _SOSViewPageState extends State<SOSView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 40,
      width: 110,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
      child: Card(
        color: Colors.red,
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(width: 5, color: Colors.transparent)),

        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

            ]),
      )
    );
  }
}
