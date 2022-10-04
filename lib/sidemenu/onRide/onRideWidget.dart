

import 'package:envi/provider/model/tripDataModel.dart';
import 'package:envi/uiwidget/estimate_fare_widget.dart';
import 'package:envi/uiwidget/mapPageWidgets/mapDirectionWidgetPickup.dart';
import 'package:envi/uiwidget/sos_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../UiWidget/cardbanner.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/mapPageWidgets/mapDirectionWidget_onRide.dart';
import '../../uiwidget/robotoTextWidget.dart';

class OnRideWidget extends StatefulWidget {
  const OnRideWidget({Key? key}) : super(key: key);

  @override
  State<OnRideWidget> createState() => _OnRideWidgetState();
}

class _OnRideWidgetState extends State<OnRideWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Consumer<firestoreLiveTripDataNotifier>(
          builder: (context, value, child) {
            if (value.liveTripData != null) {
              return Scaffold(
                  body: Stack(alignment: Alignment.center, children: <Widget>[
                    MapDirectionWidgetOnRide(
                      liveTripData: value.liveTripData!,
                    ),

                    Column(children: [
                      const AppBarInsideWidget(title: "Envi"),
                      const SizedBox(height: 5),
                  CardBanner(
                      title: DriverOnRide,
                      image: 'assets/images/driver_on_ride.png'),
                      Align(
                        alignment: Alignment.topRight,
                        child: SOSView(liveTripData: value.liveTripData!,),
                      ),
                      Spacer(),
                      FromToData(value.liveTripData!),
                      EstimateFareWidget(amountTobeCollected: value.liveTripData!.tripInfo.priceClass.amountToBeCollected.toString())
                      ]),

                  ]));
              // }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }


  Widget FromToData(TripDataModel liveTripData) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/from-location-img.svg",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Wrap(children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: robotoTextWidget(
                                  textval: liveTripData
                                      .tripInfo.pickupLocation.pickupAddress
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 16,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ])),
                      ],
                    ),
                  ),
                  Stack(alignment: Alignment.centerRight, children: <Widget>[
                    const SizedBox(
                      height: 2,
                      child: Divider(
                        color: AppColor.darkgrey,
                        height: 2,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.lightwhite,
                        border: Border.all(
                            color: AppColor.grey, // Set border color
                            width: 1.0), // Set border width
                        borderRadius: const BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius
                      ),
                      child: robotoTextWidget(
                        textval: '${liveTripData.tripInfo.priceClass.distance} Km',
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ]),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/to-location-img.svg",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                            child: Wrap(children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: robotoTextWidget(
                                  textval: liveTripData
                                      .tripInfo.dropLocation.dropAddress
                                      .toString(),
                                  colorval: AppColor.black,
                                  sizeval: 16,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ])),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



}
