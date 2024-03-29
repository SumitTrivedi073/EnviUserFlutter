import 'package:envi/provider/model/tripDataModel.dart';
import 'package:envi/uiwidget/estimate_fare_widget.dart';
import 'package:envi/uiwidget/sos_view_widget.dart';
import 'package:envi/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import '../../UiWidget/cardbanner.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../theme/color.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/mapPageWidgets/mapDirectionWidget_onRide.dart';
import '../../uiwidget/robotoTextWidget.dart';
import '../../web_service/Constant.dart';
import '../home/homePage.dart';
import '../payment/payment_page.dart';

class OnRideWidget extends StatefulWidget {
  const OnRideWidget({Key? key}) : super(key: key);

  @override
  State<OnRideWidget> createState() => _OnRideWidgetState();
}

class _OnRideWidgetState extends State<OnRideWidget> {

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Consumer<firestoreLiveTripDataNotifier>(
          builder: (context, value, child) {
            if (value.liveTripData != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (value.liveTripData!.tripInfo!.tripStatus ==
                    TripStatusCompleted) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const PaymentPage()),
                      (Route<dynamic> route) => false);
                }
              });
              return Scaffold(
                  body: Stack(alignment: Alignment.center, children: <Widget>[
                MapDirectionWidgetOnRide(
                  liveTripData: value.liveTripData!,
                ),
                Column(children: [
                  const AppBarInsideWidget(pagetitle: "Envi",isBackButtonNeeded: false,),
                  const SizedBox(height: 5),
                  CardBanner(
                      title: DriverOnRide,
                      image: 'assets/images/driver_on_ride.png'),
                  Align(
                    alignment: Alignment.topRight,
                    child: SOSView(
                      liveTripData: value.liveTripData!,
                    ),
                  ),
                  Spacer(),
                  FromToData(value.liveTripData!),
                  EstimateFareWidget(
                      amountTobeCollected: value
                          .liveTripData!.tripInfo!.priceClass!.amountToBeCollected
                          .toStringAsFixed(2))
                ]),
              ]));
              // }
            }else{
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const HomePage(title: 'title')),
                        (Route<dynamic> route) => false);
              });

            }
            return  Container(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
