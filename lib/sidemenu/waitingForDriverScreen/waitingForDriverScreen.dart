import 'package:envi/UiWidget/cardbanner.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/theme/string.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/mapPageWidgets/mapDirectionWidgetPickup.dart';
import 'package:envi/uiwidget/otpViewWidget.dart';
import 'package:envi/uiwidget/timerbutton.dart';
import 'package:envi/web_service/Constant.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
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
  final GlobalKey<MapDirectionWidgetPickupState> _key = GlobalKey();

  WaitingForDriverScreen({Key? key}) : super(key: key);

  @override
  State<WaitingForDriverScreen> createState() => _WaitingForDriverScreenState();
}

class _WaitingForDriverScreenState extends State<WaitingForDriverScreen> {
  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();
  late String duration = "0 Minute";
  bool isLoaded = false;
  int _contentAmount = 0;
  ExpansionStatus _expansionStatus = ExpansionStatus.contracted;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          return value.liveTripData != null
              ? Scaffold(
                  body: Stack(alignment: Alignment.center, children: <Widget>[
                  MapDirectionWidgetPickup(
                    key: widget._key,
                    liveTripData: value.liveTripData!,
                    callback: retrieveDuration,
                  ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        //Do not remove this height otherwise map is not scrolling
                          height: MediaQuery.of(context).size.height/2,
                          margin: EdgeInsets.only(left: 10, right: 10),
                        child: ExpandableBottomSheet(
                          //use the key to get access to expand(), contract() and expansionStatus
                          key: key,

                          //optional
                          //callbacks (use it for example for an animation in your header)
                          onIsContractedCallback: () => print('contracted'),
                          onIsExtendedCallback: () => print('extended'),

                          //optional; default: Duration(milliseconds: 250)
                          //The durations of the animations.
                          /* animationDurationExtend: const Duration(milliseconds: 500),
                        animationDurationContract:
                        const Duration(milliseconds: 250),
                        animationCurveExpand: Curves.bounceOut,
                        animationCurveContract: Curves.ease,*/

                          //required
                          //This is the widget which will be overlapped by the bottom sheet.
                          background: Container(
                            height: 1,
                            color: Colors.transparent,
                          ),

                          //For showing some content below green banner provide this height
                       //   persistentContentHeight: 50,
                          //optional
                          //This widget is sticking above the content and will never be contracted.
                          persistentHeader: GestureDetector(
                            onTap: () {
                              if (_expansionStatus == ExpansionStatus.contracted) {
                                setState(() {
                                  key.currentState!.expand();
                                  _expansionStatus =
                                      key.currentState!.expansionStatus;
                                });
                              } else {
                                setState(() {
                                  key.currentState!.contract();
                                  _expansionStatus =
                                      key.currentState!.expansionStatus;
                                });
                              }
                            },
                            child: Container(
                              color: Colors.green,
                              constraints: const BoxConstraints.expand(height: 40),
                              child: Center(
                                child: Container(
                                  height: 8.0,
                                  width: 50.0,
                                  color:
                                  Color.fromARGB((0.25 * 255).round(), 0, 0, 0),
                                ),
                              ),
                            ),
                          ),

                          //required
                          //This is the content of the bottom sheet which will be extendable by dragging.
                          expandableContent:SingleChildScrollView(
                           child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              FromToData(value.liveTripData!),])
                          ),


                          // optional
                          // This will enable tap to toggle option on header.
                          enableToggle: true,

                          //optional
                          //This is a widget aligned to the bottom of the screen and stays there.
                          //You can use this for example for navigation.
                          persistentFooter: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              DriverDetailWidget(
                                duration: duration,
                              ),
                              TimerButton(
                                liveTripData: value.liveTripData!,
                              ),],
                          ),
                        ),
                      ),
                    ),

                  Column(children: [
                    const AppBarInsideWidget(
                      title: "Envi",
                      isBackButtonNeeded: false,
                    ),
                    const SizedBox(height: 5),
                    getCardBanner(value.liveTripData!),
                    Align(
                      alignment: Alignment.topRight,
                      child: OTPView(otp: value.liveTripData!.tripInfo!.otp),
                    ),
                  ]),

                ]))
              : Container();
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
                              fontWeight: FontWeight.w600,
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
                        textval:
                            '${liveTripData.tripInfo!.priceClass!.distance.toStringAsFixed(2)} Km',
                        colorval: AppColor.black,
                        sizeval: 14,
                        fontWeight: FontWeight.w600,
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
                              fontWeight: FontWeight.w600,
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

  retrieveDuration(String durationToPickupLocation) {
      setState(() {
        duration = durationToPickupLocation;
      });
  }

}
