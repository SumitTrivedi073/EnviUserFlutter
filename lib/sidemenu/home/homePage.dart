import 'package:envi/UiWidget/navigationdrawer.dart';
import 'package:envi/appConfig/appConfig.dart';
import 'package:envi/consumer/ScheduleListAlertConsumer.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:envi/utils/utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../UiWidget/appbar.dart';
import '../../UiWidget/cardbanner.dart';
import '../../appConfig/Profiledata.dart';
import '../../notificationService/local_notification_service.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../uiwidget/mapPageWidgets/mappagescreen.dart';
import '../../web_service/Constant.dart';
import '../onRide/onRideWidget.dart';
import '../payment/payment_page.dart';
import '../waitingForDriverScreen/waitingForDriverScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<firestoreLiveTripDataNotifier>(
        builder: (context, value, child) {
      //If this was not given, it was throwing error like setState is called during build . RAGHU VT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && value.liveTripData != null && value.liveTripData!.tripInfo != null) {
          if (value.liveTripData!.tripInfo!.tripStatus == TripStatusRequest ||
              value.liveTripData!.tripInfo!.tripStatus == TripStatusAlloted ||
              value.liveTripData!.tripInfo!.tripStatus == TripStatusArrived) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        WaitingForDriverScreen()),
                (Route<dynamic> route) => false);
          } else if (value.liveTripData!.tripInfo!.tripStatus ==
              TripStatusOnboarding) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => const OnRideWidget()),
                (Route<dynamic> route) => false);
          } else if (value.liveTripData!.tripInfo!.tripStatus ==
              TripStatusCompleted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => const PaymentPage()),
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
              CardBanner(
                  title: 'Welcome ${name.toTitleCase()}',
                  image: 'assets/images/welcome_card_dashboard.png'),
              const ScheduleListAlertConsumer(),
            ],
          ),
        ]),
      );
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await _showExitBottomSheet(context);
    return exitResult ?? false;
  }

  Future<bool?> _showExitBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: _buildBottomSheet(context),
        );
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 24,
        ),
        robotoTextWidget(textval: "Do you really want to exit the app?",
            colorval: AppColor.black, sizeval: 18, fontWeight: FontWeight.w400),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: robotoTextWidget(textval: 'CANCEL',
                  colorval: AppColor.darkgrey, sizeval: 16, fontWeight: FontWeight.w600),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: robotoTextWidget(textval: 'YES, EXIT',
                  colorval: AppColor.darkGreen, sizeval: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> getUserName() async {
    setState(() {
      name = Profiledata().getname();
    });
  }
}
