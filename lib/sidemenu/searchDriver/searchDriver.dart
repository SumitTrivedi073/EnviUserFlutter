// ignore: file_names
import 'package:envi/enum/BookingTiming.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/fromtowidget.dart';
import 'package:envi/uiwidget/mapPageWidgets/mapDirectionWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import '../../uiwidget/driverListWidget.dart';
import '../home/homePage.dart';

class SearchDriver extends StatefulWidget {
  final GlobalKey<DriverListItemPageState> _key = GlobalKey();
  final SearchPlaceModel? fromAddress;
  final SearchPlaceModel? toAddress;

  SearchDriver({Key? key, this.toAddress, this.fromAddress}) : super(key: key);

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => _SearchDriverPageState();
}

class _SearchDriverPageState extends State<SearchDriver> {
  final pagecontroller = PageController();
  late String distance = "";

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }

}

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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
        AppBarInsideWidget(
          onPressBack: () {
             Navigator.pop(context);
             Navigator.pop(context, [widget.fromAddress, widget.toAddress]);
           /* if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage(
                          title: "",
                        )),
                (Route<dynamic> route) => false);*/
          },
          pagetitle: "Envi",
          isBackButtonNeeded: true,
        ),
        FromToWidget(
          fromAddress: widget.fromAddress,
          toAddress: widget.toAddress,
          distance: distance,
          tripType: BookingTiming.now,
        ),
      ]),
      Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            child: DriverListItem(
              key: widget._key,
              fromAddress: widget.fromAddress,
              toAddress: widget.toAddress,
              callback: retrieveDistance,
            ),
          )),
    ]));
  }

  retrieveDistance(String distanceInKm) {
    setState(() {
      distance = distanceInKm;
    });
  }
}
