import 'dart:async';
import 'dart:convert' as convert;

import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/sidemenu/home/homePage.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/web_service/APIDirectory.dart';
import 'package:envi/web_service/HTTP.dart' as HTTP;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:permission_handler/permission_handler.dart';

import '../provider/model/tripDataModel.dart';
import '../theme/color.dart';
import '../theme/string.dart';

class TimerButton extends StatefulWidget {
  TripDataModel? liveTripData;

  TimerButton({Key? key, this.liveTripData}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton>
    with TickerProviderStateMixin {
  int state = 0;
  Timer? timer;
  LatLng? latlong = null;
  int counter = 60;
  String reasonForCancellation = ShorterWaitingTime;
  bool isLoading = false;
  final List<String> _status = [
    ShorterWaitingTime,
    PlanChanged,
    DriverDeniedPickup,
    Other
  ];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (AppConfig().getisCancellationFeeApplicable() == true) {
      if (state == 0) {
        animateButton();
      }
    }
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) getLocation();
      return;
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (mounted) {
      setState(() {
        latlong = LatLng(position.latitude, position.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: MaterialButton(
                onPressed: () => {
                      //payment not charge that's whywhen cancel booking provide false
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            cancelBooking(context, false),
                      )
                    },
                elevation: 4.0,
                minWidth: double.infinity,
                height: 48.0,
                color: AppColor.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: (!isLoading)
                    ? setUpButtonChild()
                    : const Center(
                        child: CircularProgressIndicator(
                        color: AppColor.white,
                      ))),
          )
        ],
      ),
    );
  }

  Widget setUpButtonChild() {
    if (state == 0) {
      return cancelBookingText(CancelBooking);
    } else if (state == 1) {
      return SizedBox(
        width: double.infinity,
        child: MaterialButton(
            onPressed: () => {
                  //payment not charge that's whywhen cancel booking provide false
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        cancelBooking(context, false),
                  )
                },
            textColor: Colors.white,
            child: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                robotoTextWidget(
                  textval: '0:$counter',
                  colorval: AppColor.white,
                  sizeval: 16,
                  fontWeight: FontWeight.w800,
                ),
                Center(
                  child: cancelBookingText(CancelBooking),
                ),
              ],
            )),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: MaterialButton(
            onPressed: () => {
                  //payment charge that's why when cancel booking provide true

                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        cancelBooking(context, true),
                  )
                },
            textColor: Colors.white,
            child: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                const Icon(
                  Icons.info_outline,
                  color: AppColor.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    cancelBookingText(
                        "$CancelBooking - ₹${AppConfig().getcancellationFee().toString()}"),
                  ],
                ),
              ],
            )),
      );
    }
  }

  void animateButton() {
    if (mounted) {
      setState(() {
        state = 1;
      });
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 1) {
        if (mounted) {
          setState(() {
            counter--;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            state = 2;
          });
        }
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }

  Widget cancelBooking(BuildContext context, bool applyCancelCharge) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: SizedBox(
            height: 240,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: [
                  robotoTextWidget(
                      textval: ReasonForCancellation,
                      colorval: AppColor.black,
                      sizeval: 18,
                      fontWeight: FontWeight.w800),
                  const Divider(),
                  RadioGroup<String>.builder(
                      direction: Axis.vertical,
                      groupValue: reasonForCancellation,
                      horizontalAlignment: MainAxisAlignment.spaceAround,
                      onChanged: (value) {
                        setState(() {
                          reasonForCancellation = value.toString();
                        });
                      },
                      items: _status,
                      textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      itemBuilder: (item) => RadioButtonBuilder(
                            item,
                          )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          height: 40,
                          width: 100,
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColor.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // <-- Radius
                              ),
                            ),
                            child: robotoTextWidget(
                              textval: backText,
                              colorval: AppColor.greyblack,
                              sizeval: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      Container(
                          height: 40,
                          width: 100,
                          margin: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                isLoading = true;
                                cancelTripAPI(context);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColor.greyblack,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(5), // <-- Radius
                              ),
                            ),
                            child: robotoTextWidget(
                              textval: okText,
                              colorval: AppColor.white,
                              sizeval: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ],
                  )
                ])),
          ));
    });
  }

  Future<void> cancelTripAPI(BuildContext context) async {
    Map data;
    data = {
      "passengerTripMasterId":
          widget.liveTripData!.tripInfo!.passengerTripMasterId != null
              ? widget.liveTripData!.tripInfo!.passengerTripMasterId
              : "",
      "driverTripMasterId": widget.liveTripData!.driverInfo!.driverId != null
          ? widget.liveTripData!.driverInfo!.driverId
          : "",
      "reason": reasonForCancellation != null
          ? reasonForCancellation
          : ShorterWaitingTime,
      "driverId": widget.liveTripData!.driverInfo!.driverId != null
          ? widget.liveTripData!.driverInfo!.driverId
          : "",
      "location": {
        "latitude": latlong != null ? latlong!.latitude : 0.0,
        "longitude": latlong != null ? latlong!.longitude : 0.0
      }
    };
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    dynamic res = await HTTP.post(cancelTrip(), data);
    if (res != null && res.statusCode != null && res.statusCode == 200) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

Widget cancelBookingText(String cancelBooking) {
  return robotoTextWidget(
    textval: cancelBooking,
    colorval: AppColor.white,
    sizeval: 16,
    fontWeight: FontWeight.w800,
  );
}
//https://protocoderspoint.com/count-down-timer-flutter-dart/
