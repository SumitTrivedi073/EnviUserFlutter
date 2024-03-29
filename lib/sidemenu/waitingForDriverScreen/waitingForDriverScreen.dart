import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:envi/UiWidget/cardbanner.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/mapPageWidgets/mapDirectionWidgetPickup.dart';
import 'package:envi/uiwidget/otpViewWidget.dart';
import 'package:envi/uiwidget/timerbutton.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../provider/model/tripDataModel.dart';
import '../../theme/color.dart';
import '../../uiwidget/driverDetailWidget.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../utils/utility.dart';
import '../onRide/onRideWidget.dart';

class WaitingForDriverScreen extends StatefulWidget {
  final GlobalKey<MapDirectionWidgetPickupState> _key = GlobalKey();

  WaitingForDriverScreen({Key? key}) : super(key: key);

  @override
  State<WaitingForDriverScreen> createState() => _WaitingForDriverScreenState();
}

class _WaitingForDriverScreenState extends State<WaitingForDriverScreen> {
  late String duration = "0 Minute";
  bool isLoaded = false;
  Timer? fullScreenDisableTimer;
  bool showFullScreen = true;
  int delay = 13, fadeInFadeOut = 3 , fadeInFadeOutDelay =  10;

  @override
  void initState() {
    super.initState();
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }

    disableFullScreen();
  }
  
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  disableFullScreen() {
    if (fullScreenDisableTimer != null && fullScreenDisableTimer!.isActive) {
      fullScreenDisableTimer!.cancel();
    }
    if (mounted) {
      fullScreenDisableTimer = Timer(Duration(seconds: delay), () {
        if (mounted) {
          setState(() {
            showFullScreen = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<firestoreLiveTripDataNotifier>(
            builder: (context, value, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (value.liveTripData != null) {
              isLoaded = true;
              if (value.liveTripData!.tripInfo!.tripStatus ==
                  TripStatusOnboarding) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const OnRideWidget()),
                    (Route<dynamic> route) => false);
              }
            } else {
              if (isLoaded) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const HomePage(title: 'title')),
                    (Route<dynamic> route) => false);
              }
            }
          });
          if (value.liveTripData != null) {
            return Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  MapDirectionWidgetPickup(
                    key: widget._key,
                    liveTripData: value.liveTripData!,
                    callback: retrieveDuration,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (showFullScreen)
                          FadeIn(
                              animate: true,
                              duration:  Duration(seconds: fadeInFadeOut),
                              child: FadeOut(
                                  animate: true,
                                  delay: Duration(seconds: fadeInFadeOutDelay),
                                  duration:  Duration(seconds: fadeInFadeOut),
                                  child: FromToData(value.liveTripData!))),
                        GestureDetector(
                          onTap: () {
                          if(mounted){
                            setState(() {
                              showFullScreen = true;
                              disableFullScreen();
                            });
                          }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DriverDetailWidget(
                                duration: duration,
                              ),
                              TimerButton(
                                liveTripData: value.liveTripData!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(children: [
                    const AppBarInsideWidget(
                      pagetitle: "Envi",
                      isBackButtonNeeded: false,
                    ),
                    const SizedBox(height: 5),
                    if (showFullScreen)
                      FadeIn(
                          animate: true,
                          duration:  Duration(seconds: fadeInFadeOut),
                          child: FadeOut(
                              animate: true,
                              delay: Duration(seconds: fadeInFadeOutDelay),
                              duration:  Duration(seconds: fadeInFadeOut),
                              child: getCardBanner(value.liveTripData!))),
                    Align(
                      alignment: Alignment.topRight,
                      child: OTPView(otp: value.liveTripData!.tripInfo!.otp),
                    ),
                  ]),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget getCardBanner(TripDataModel liveTripData) {
    if (liveTripData.tripInfo!.tripStatus == TripStatusArrived) {
      return CardBanner(
          title: Driverarrived, image: 'assets/images/driver_arrived_img.png');
    } else if (liveTripData.tripInfo!.tripStatus == TripStatusAlloted) {
      return CardBanner(
          title: DriverOnTheWay, image: 'assets/images/driver_on_way.png');
    } else {
      return CardBanner(
          title: ContactingDriver,
          image: 'assets/images/connecting_driver_img.png');
    }
  }

  Widget FromToData(TripDataModel liveTripData) {
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
        // Just change the Image.asset widget to anything you want to fade in/out:
        child:Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(alignment: Alignment.centerRight, children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 1,
                    child: Divider(
                      color: AppColor.darkgrey,
                      height: 1,
                    ),
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: AppColor.lightwhite,
                    border: Border.all(
                        color: AppColor.grey, // Set border color
                        width: 1.0), // Set border width
                    borderRadius: const BorderRadius.all(Radius.circular(
                        5.0)), // Set rounded corner radius
                  ),
                  child:Padding(padding: const EdgeInsets.all(8),
                    child:  Align(alignment: Alignment.centerRight,
                      child: robotoTextWidget(
                        textval:'${liveTripData.tripInfo!.priceClass!.distance.toStringAsFixed(2)}Km',
                        colorval: AppColor.black,
                        sizeval: 12,
                        fontWeight: FontWeight.w600,
                      ),),),
                ),

                Container(
                  margin: const EdgeInsets.only(right: 70),
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            print("Tapped a Container");
                          },
                          child: Container(
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
                                      InkWell(
                                        onTap: () {
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          child: robotoTextWidget(
                                            textval:formatAddress(liveTripData
                                                .tripInfo!.pickupLocation!.pickupAddress
                                                .toString()),
                                            colorval: AppColor.black,
                                            sizeval: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ])),
                              ],
                            ),
                          )),
                      GestureDetector(
                          onTap: () {
                            print("Tapped a Container");
                          },
                          child: Container(
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
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          child: robotoTextWidget(
                                            textval: formatAddress(liveTripData
                                                .tripInfo!.dropLocation!.dropAddress
                                                .toString()),
                                            colorval: AppColor.black,
                                            sizeval: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ])),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ]),
            ))
        );
  }

  retrieveDuration(String durationToPickupLocation) {
    if (mounted) {
      setState(() {
        duration = durationToPickupLocation;
      });
    }
  }
}
