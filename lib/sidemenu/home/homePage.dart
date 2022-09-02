import 'package:envi/UiWidget/navigationdrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../UiWidget/appbar.dart';
import '../../UiWidget/cardbanner.dart';
import '../../provider/firestoreLiveTripDataNotifier.dart';
import '../../uiwidget/mappagescreen.dart';

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
print(value.liveTripData);
        }
      });
    return Scaffold(
      drawer: NavigationDrawer(),
      body: Stack(alignment: Alignment.centerRight, children: <Widget>[
        MyMap(),
        Column(
          children: [
            AppBarWidget(),
            CardBanner(),

            /*PaymentModeOptionWidget(
              strpaymentOptions: "qr_code,online,cash",
              selectedOption: "qr_code",
            )*/
          ],
        ),
      ]),
    );
        });
  }
}
