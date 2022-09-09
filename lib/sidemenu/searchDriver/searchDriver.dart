import 'package:envi/sidemenu/pickupDropAddressSelection/model/fromAddressModel.dart';
import 'package:envi/sidemenu/pickupDropAddressSelection/model/toAddressModel.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/fromtowidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';

import '../../theme/color.dart';
import '../../uiwidget/driverListWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';

class SearchDriver extends StatefulWidget {
  //variables for selectpickup drop address navigation route
  final DetailsResult? fromLocation;
  final DetailsResult? toLocation;
  // variables for confirm drop location navigation route
  final ToAddressLatLong? toAddress;
  final FromAddressLatLong? fromAddress;
  const SearchDriver({Key? key, this.fromLocation, this.toLocation, this.toAddress, this.fromAddress}) : super(key: key);

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
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(PageBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(children: [

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
    ));
  }
}
