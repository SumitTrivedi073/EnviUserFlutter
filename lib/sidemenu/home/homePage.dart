import 'package:envi/UiWidget/navigationdrawer.dart';
import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/consumer/ScheduleListAlertConsumer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../UiWidget/appbar.dart';
import '../../UiWidget/cardbanner.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../uiwidget/mappagescreen.dart';
import '../../web_service/Constant.dart';
import '../waitingForDriverScreen/waitingForDriverScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {


    return Consumer<firestoreLiveTripDataNotifier>(
        builder: (context, value, child) {
      //If this was not given, it was throwing error like setState is called during build . RAGHU VT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print("liveTripData===>${value.liveTripData!.tripStatus}");
         if (value.liveTripData!.tripStatus == TripStatusRequest ||
              value.liveTripData!.tripStatus == TripStatusAlloted||
             value.liveTripData!.tripStatus == TripStatusArrived) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const WaitingForDriverScreen()),
                (Route<dynamic> route) => false);
          }


      }
      });
      return Scaffold(
        drawer: NavigationDrawer(),
        body: Stack(alignment: Alignment.centerRight, children: <Widget>[
          MyMap(),
          Column(
            children: [
              AppBarWidget(),
              const CardBanner(
                  title: 'Connecting Driver',
                  image: 'assets/images/connecting_driver_img.png'),

              /*PaymentModeOptionWidget(
              strpaymentOptions: "qr_code,online,cash",
              selectedOption: "qr_code",
            )*/
              const ScheduleListAlertConsumer()
            ],
          ),
        ]),
      );
    });
  }
}
