

import 'package:envi/uiwidget/mapDirectionWidgetPickup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../UiWidget/cardbanner.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../theme/string.dart';
import '../../uiwidget/appbarInside.dart';
import '../../uiwidget/mapDirectionWidget_onRide.dart';

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


}
