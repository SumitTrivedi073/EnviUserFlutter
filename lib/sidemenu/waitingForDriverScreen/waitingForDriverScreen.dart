

import 'package:envi/UiWidget/cardbanner.dart';
import 'package:envi/uiwidget/appbarInside.dart';
import 'package:envi/uiwidget/mapDirectionWidget_With_Driver.dart';
import 'package:envi/uiwidget/timerbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../uiwidget/driverDetailWidget.dart';

class WaitingForDriverScreen extends StatefulWidget{
  const WaitingForDriverScreen({Key? key}) : super(key: key);

  @override
  State<WaitingForDriverScreen> createState() => _WaitingForDriverScreenState();

}

class _WaitingForDriverScreenState extends State<WaitingForDriverScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<firestoreLiveTripDataNotifier>(
        builder: (context, value, child)
    {
      //If this was not given, it was throwing error like setState is called during build . RAGHU VT
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          print(value.liveTripData);
        }
      });

    return Scaffold(
    body: Stack(alignment: Alignment.center, children: <Widget>[
    MapDirectionWidgetWithDriver(),
    Column(children: [
    const AppBarInsideWidget(title: "Envi"),
    const SizedBox(height: 5),
    const CardBanner(title: 'Connecting Driver',
    image: 'assets/images/connecting_driver_img.png'),
    const SizedBox(height: 250),
    TimerButton(),
    DriverDetailWidget(),
    ])
    ,
    ]
    )
    );
  });
  }
/**/
}