import 'package:envi/UiWidget/cardbanner.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/mapDirectionWidgetPickup.dart';
import 'package:envi/uiwidget/otpViewWidget.dart';
import 'package:envi/uiwidget/timerbutton.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../provider/model/tripDataModel.dart';
import '../../theme/color.dart';
import '../../uiwidget/driverDetailWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../onRide/onRideWidget.dart';

class WaitingForDriverScreen extends StatefulWidget {
  const WaitingForDriverScreen({Key? key}) : super(key: key);

  @override
  State<WaitingForDriverScreen> createState() => _WaitingForDriverScreenState();
}

class _WaitingForDriverScreenState extends State<WaitingForDriverScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Consumer<firestoreLiveTripDataNotifier>(
          builder: (context, value, child) {
            if (value.liveTripData != null) {
              if(value.liveTripData!.tripStatus == TripStatusOnboarding){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const OnRideWidget()),
                        (Route<dynamic> route) => false);
              }
              return Scaffold(
                  body: Stack(alignment: Alignment.center, children: <Widget>[
                MapDirectionWidgetPickup(
                  liveTripData: value.liveTripData!,
                ),
                Column(children: [
                  const AppBarInsideWidget(title: "Envi"),
                  const SizedBox(height: 5),
                  getCardBanner(value.liveTripData!),
                  const Align(
                    alignment: Alignment.topRight,
                    child: OTPView(
                      otp: "3592",
                    ),
                  ),
                  const Spacer(),
                  TimerButton(
                    liveTripData: value.liveTripData!,
                  ),
                  DriverDetailWidget(),
                  FromToData(value.liveTripData!),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget getCardBanner(TripDataModel liveTripData) {
    if (liveTripData.tripStatus == TripStatusArrived) {
      return  CardBanner(
          title: Driverarrived,
          image: 'assets/images/driver_arrived_img.png');
    } else if (liveTripData.tripStatus == TripStatusAlloted) {
      return  CardBanner(
          title: DriverOnTheWay,
          image: 'assets/images/driver_on_way.png');
    } else {
     return  CardBanner(
          title: ContactingDriver,
          image: 'assets/images/connecting_driver_img.png');
    }
  }
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
                                .tripInfo!.pickupLocation!.pickupAddress
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
                      textval: '${liveTripData.priceClass!.distance} Km',
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
                                .tripInfo!.dropLocation!.dropAddress
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
