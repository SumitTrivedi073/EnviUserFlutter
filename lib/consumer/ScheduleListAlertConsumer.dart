import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envi/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/firestoreScheduleTripNotifier.dart';
import '../sidemenu/upcomingride/upcomingridesPage.dart';
import '../uiwidget/robotoTextWidget.dart';
import '../web_service/Constant.dart';

class ScheduleListAlertConsumer extends StatefulWidget {
  const ScheduleListAlertConsumer({Key? key}) : super(key: key);

  @override
  State<ScheduleListAlertConsumer> createState() =>
      _ScheduleListAlertConsumerState();
}

class _ScheduleListAlertConsumerState extends State<ScheduleListAlertConsumer> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
      return Consumer<firestoreScheduleTripNotifier>(builder: (context, value, child) {

        if(value.scheduleTrip != null) {
          print("scheduleTripConsumer===========${value.scheduleTrip!.status}");
           return Flexible(
               child: Wrap(children: [
                 GestureDetector(
                   onTap: () {
                     Navigator.of(context).pushAndRemoveUntil(
                         MaterialPageRoute(
                             builder: (context) => UpcomingRidesPage()),
                             (route) => true);
                   },
                   child: Container(
                     width: MediaQuery
                         .of(context)
                         .size
                         .width,
                     margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color: getColor(value.scheduleTrip!.status),
                       borderRadius: BorderRadius.all(Radius.circular(5)),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           child: SvgPicture.asset(
                             "assets/svg/schedule-ride-panel-icon.svg",
                             width: 20,
                             height: 20,
                             color: Colors.white,
                           ),
                         ),

                         Flexible(
                             child: Wrap(children: [
                               Container(
                                 margin: const EdgeInsets.only(left: 5),
                                 child: robotoTextWidget(
                                   textval: getText(value.scheduleTrip!.status),
                                   colorval: AppColor.white,
                                   sizeval: 14,
                                   fontWeight: FontWeight.w800,
                                 ),
                               ),
                             ])),
                         SvgPicture.asset(
                           "assets/svg/schedule-ride-chevron-arrow.svg",
                           width: 20,
                           height: 20,
                           color: Colors.white,
                         ),

                       ],
                     ),
                   ),
                 )
               ]));
         }else{
          print("scheduleTripConsumer===========null");
           return Container();
         }
     });
  }

  getText(String status) {
   if(status == ScheduleTripRequestedStatus){
     return  'Your schedule trip is in process';
   }else if (status == ScheduleTripConfirmedStatus){
     return  'Your schedule trip is $status';
   }else if (status == ScheduleTripRejectStatus || status == ScheduleTripCancelledByOps){
     return 'We are extremely sorry your scheduled trip is rejected';
   }else if (status == ScheduleTripDriverAssignedStatus){
     return 'Driver assigned for your schedule trip';
   }
  }

   getColor(String status) {
    if(status == ScheduleTripRequestedStatus){
      return AppColor.alfaorange;
    }else if(status == ScheduleTripConfirmedStatus || status == ScheduleTripDriverAssignedStatus){
      return AppColor.darkGreen;
    }else if(status == ScheduleTripRejectStatus || status == ScheduleTripCancelledByOps){
      return AppColor.red;
    }
  }
}
