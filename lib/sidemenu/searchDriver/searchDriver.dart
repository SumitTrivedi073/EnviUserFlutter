import 'package:envi/sidemenu/pickupDropAddressSelection/model/fromAddressModel.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/searchPlaceModel.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/toAddressModel.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/fromtowidget.dart';
import 'package:envi/uiwidget/mapDirectionWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

import '../../theme/color.dart';
import '../../uiwidget/driverListWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';

class SearchDriver extends StatefulWidget {

  // final DetailsResult? fromLocation;
  // final DetailsResult? toLocation;

  // final ToAddressLatLong? toAddress;
  // final FromAddressLatLong? fromAddress;

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
      MapDirectionWidget(),
      Column(children: [
        const AppBarInsideWidget(title: "Envi"),
        const SizedBox(height: 5),
        FromToWidget(),
        const Spacer(),
        DriverListItem(),
        Container(
            height: 40,
            margin: const EdgeInsets.all(5),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: AppColor.greyblack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                ),
              ),
              child: robotoTextWidget(
                textval: bookNow,
                colorval: AppColor.white,
                sizeval: 14,
                fontWeight: FontWeight.w600,
              ),
            )),
      ]),
    ]));
  }
}
