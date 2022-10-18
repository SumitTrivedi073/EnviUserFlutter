import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';

class ExpandableBottomSheetWidget extends StatefulWidget {

  @override
  // TODO: implement createState
  State<StatefulWidget> createState() => ExpandableBottomSheetWidgetPageState();
}

class ExpandableBottomSheetWidgetPageState extends State<ExpandableBottomSheetWidget> {
  GlobalKey<ExpandableBottomSheetState> key = new GlobalKey();
  ExpansionStatus _expansionStatus = ExpansionStatus.contracted;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return        Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height/2,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ExpandableBottomSheet(
          //use the key to get access to expand(), contract() and expansionStatus
            key: key,

            //optional
            //callbacks (use it for example for an animation in your header)
            onIsContractedCallback: () => print('contracted'),
            onIsExtendedCallback: () => print('extended'),

            //optional; default: Duration(milliseconds: 250)
            //The durations of the animations.
            /* animationDurationExtend: const Duration(milliseconds: 500),
                        animationDurationContract:
                        const Duration(milliseconds: 250),
                        animationCurveExpand: Curves.bounceOut,
                        animationCurveContract: Curves.ease,*/

            //required
            //This is the widget which will be overlapped by the bottom sheet.
            background: Container(
              color: Colors.transparent,
            ),

            //optional
            //This widget is sticking above the content and will never be contracted.
            persistentHeader: GestureDetector(
              onTap: () {
                if (_expansionStatus == ExpansionStatus.contracted) {
                  setState(() {
                    key.currentState!.expand();
                    _expansionStatus =
                        key.currentState!.expansionStatus;
                  });
                } else {
                  setState(() {
                    key.currentState!.contract();
                    _expansionStatus =
                        key.currentState!.expansionStatus;
                  });
                }
              },
              child: Container(
                color: Colors.green,
                constraints: const BoxConstraints.expand(height: 40),
                child: Center(
                  child: Container(
                    height: 8.0,
                    width: 50.0,
                    color:
                    Color.fromARGB((0.25 * 255).round(), 0, 0, 0),
                  ),
                ),
              ),
            ),

            //required
            //This is the content of the bottom sheet which will be extendable by dragging.
            expandableContent: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[FromToData(value.liveTripData!),
                  DriverDetailWidget(
                    duration: duration,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: TimerButton(
                      liveTripData: value.liveTripData!,
                    ),
                  ),],
              ),
            ),

            // optional
            // This will enable tap to toggle option on header.
            enableToggle: true,

            //optional
            //This is a widget aligned to the bottom of the screen and stays there.
            //You can use this for example for navigation.
            persistentFooter: Container()
        ),
      ),
    );
  }
}