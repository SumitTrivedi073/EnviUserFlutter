import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/color.dart';

class TimerButton extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton>
    with TickerProviderStateMixin {
  int _state = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_state == 0) {
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
              color: Color(red),
              child: setUpButtonChild(),
            ),
          )
        ],
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      return const Text(
        "CANCEL BOOKING",
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w800),
      );
    } else if (_state == 1) {
      return const LinearProgressIndicator(
        backgroundColor: Color(red),
        valueColor: AlwaysStoppedAnimation(Color(0xFFda3a00)),
        minHeight: 25,
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
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "CANCEL BOOKING -" + "₹50",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            )),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(const Duration(milliseconds: 5000), () {
      setState(() {
        _state = 2;
      });
    });
  }
}
