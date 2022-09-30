// ignore: file_names
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/fromtowidget.dart';
import 'package:envi/uiwidget/mapPageWidgets/mapDirectionWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme/color.dart';
import '../../uiwidget/driverListWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';

class SearchDriver extends StatefulWidget {
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  const SearchDriver({Key? key, this.toAddress, this.fromAddress}) : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SearchDriverPageState();
}

class _SearchDriverPageState extends State<SearchDriver> {
  final pagecontroller = PageController();
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Stack(alignment: Alignment.centerRight, children: <Widget>[
      MapDirectionWidget(
        fromAddress: widget.fromAddress,
        toAddress: widget.toAddress,
      ),
      Column(children: [
        const AppBarInsideWidget(title: "Envi"),
        const SizedBox(height: 5),
        FromToWidget(
      fromAddress: widget.fromAddress,
      toAddress: widget.toAddress,),
        const SizedBox(height: 230),
        DriverListItem(
          fromAddress: widget.fromAddress,
          toAddress: widget.toAddress,
        ),

      ]),
    ]));
  }
}
