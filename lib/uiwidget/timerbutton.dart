import 'dart:async';

import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.all(16.0),
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
            onPressed: () => {},
            textColor: Colors.white,
            child: Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Text(
                  '0:$counter',
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 16.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w800,
                  ),
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
            onPressed: () => {},
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
                  children:  <Widget>[
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

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
