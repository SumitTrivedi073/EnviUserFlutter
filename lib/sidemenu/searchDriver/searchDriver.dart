// ignore: file_names
import 'package:envi/enum/BookingTiming.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/fromtowidget.dart';
import 'package:envi/uiwidget/mapPageWidgets/mapDirectionWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../uiwidget/driverListWidget.dart';

class SearchDriver extends StatefulWidget {
  final GlobalKey<DriverListItemPageState> _key = GlobalKey();
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

   SearchDriver({Key? key, this.toAddress, this.fromAddress})
      : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SearchDriverPageState();
}

class _SearchDriverPageState extends State<SearchDriver> {
  final pagecontroller = PageController();
  late String distance = "";

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
        const AppBarInsideWidget(title: "Envi",isBackButtonNeeded: true,),
        const SizedBox(height: 5),
        FromToWidget(
          fromAddress: widget.fromAddress,
          toAddress: widget.toAddress,
          distance: distance,
          tripType: BookingTiming.now,
        ),
        // const SizedBox(height: 250),
        DriverListItem(
          key: widget._key,
          fromAddress: widget.fromAddress,
          toAddress: widget.toAddress,
          callback: retrieveDistance,
        ),
      ]),
    ]));
  }
  retrieveDistance(String distanceInKm){
   setState(() {
     distance = distanceInKm;
   });
  }
}
