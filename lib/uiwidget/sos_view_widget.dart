import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

import '../theme/string.dart';

class SOSView extends StatefulWidget {

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SOSViewPageState();
}

class _SOSViewPageState extends State<SOSView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50,
      width: 110,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(right: 10,top: 10),
      child: Card(
        color: Colors.red,
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            side: BorderSide(width: 5, color: Colors.transparent)),

        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child:  Image.asset(
                    'assets/images/fire_alarm.png',
                    fit: BoxFit.fill,
                    height: 20,
                    color: Colors.white ,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                robotoTextWidget(textval: SOS,
                    colorval: AppColor.white,
                    sizeval: 14,
                    fontWeight: FontWeight.w800),
              ]),
        ),
      )
    );
  }
}
