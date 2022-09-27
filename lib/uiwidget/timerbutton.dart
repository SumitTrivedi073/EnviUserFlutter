import 'dart:async';

import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../theme/color.dart';
import '../theme/string.dart';

class TimerButton extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton>
    with TickerProviderStateMixin {
  int state = 0;
  late Timer timer;
  int counter = 60;
  String reasonForCancellation = ShorterWaitingTime;
  final List<String> _status = [
    ShorterWaitingTime,
    PlanChanged,
    DriverDeniedPickup,
    Other
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (state == 0) {
      animateButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
            child: MaterialButton(
              onPressed: () {},
              elevation: 4.0,
              minWidth: double.infinity,
              height: 48.0,
              color: AppColor.red,
              child: setUpButtonChild(),
            ),
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
                    cancelBookingText("$CancelBooking- ₹50"),
                  ],
                ),
              ],
            )),
      );
    }
  }

  void animateButton() {
    setState(() {
      state = 1;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 1) {
        setState(() {
          counter--;
        });
      } else {
        setState(() {
          state = 2;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (timer.isActive) {
      timer.cancel();
    }
  }

  Widget cancelBooking(BuildContext context, bool applyCancelCharge) {
   return StatefulBuilder(builder: (context, StateSetter setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
                      onChanged: (value) => setState(() {
                            reasonForCancellation = value.toString();
                          }),
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
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: robotoTextWidget(
                              textval: cancel,
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
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColor.greyblack,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: robotoTextWidget(
                              textval: confirm,
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
