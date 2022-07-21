import 'package:envi/UiWidget/frombookschedule.dart';
import 'package:envi/UiWidget/navigationdrawer.dart';
import 'package:envi/uiwidget/mappagescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../UiWidget/appbar.dart';
import '../../UiWidget/cardbanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      body: Stack(alignment: Alignment.centerRight, children: <Widget>[
        MyMap(),
        Column(
          children: [
            AppBarWidget(),
            CardBanner(),
            Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 80),
                    child: FromBookScheduleWidget(),
                  ),
                ))
          ],
        ),
      ]), /*Column(
        children: [
          AppBarWidget(),
          CardBanner(),
          Expanded(child: Center(
            child: FromToWidget(),
          )),
           TimerButton(),
        ],
      ),*/
    );
  }
}
