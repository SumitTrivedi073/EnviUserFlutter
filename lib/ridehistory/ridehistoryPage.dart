import 'package:envi/uiwidget/appbarInside.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RideHistoryPage extends StatefulWidget {

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Column(
        children: const [
          AppBarInsideWidget(title: "Ride History",),

        ],
      ),
    );
  }
}