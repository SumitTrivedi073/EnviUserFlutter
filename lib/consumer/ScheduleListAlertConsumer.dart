
import 'package:envi/provider/firestoreScheduleTripNotifier.dart';
import 'package:envi/theme/color.dart';
import 'package:envi/uiwidget/robotoTextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/utility.dart';

class ScheduleListAlertConsumer extends StatefulWidget {
  const ScheduleListAlertConsumer({Key? key}) : super(key: key);

  @override
  State<ScheduleListAlertConsumer> createState() => _ScheduleListAlertConsumerState();
}

class _ScheduleListAlertConsumerState extends State<ScheduleListAlertConsumer> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<dynamic> _items = [];
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<firestoreScheduleTripNotifier>(builder: (context, value, child) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        var reversedList = new List.from(value.scheduleFailureSream.reversed);
        var str = '';
        if (reversedList.isNotEmpty) {
          str = reversedList.toString().replaceAll(',', "\n\n");
          print("======$str");
           showToast(str);

        }
      });
      return Center(child:
        Container(
        height: 200,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Container(
              height: double.infinity,
              child: AnimatedList(
                key: listKey,
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) {
                  return slideIt(context, index, animation);
                },
              ),
            ),
          ),

        ],
      ),));
    });
  }
  Widget slideIt(BuildContext context, int index, animation) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline4;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
        height: 128.0,
        child: Card(
         // color: Colors.primaries[item % Colors.primaries.length],
          child: Center(
            child: Text('Item 0', style: textStyle),
          ),
        ),
      ),
    );
  }
}