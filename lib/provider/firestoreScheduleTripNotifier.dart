import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:envi/appConfig/Profiledata.dart';
import 'package:envi/sidemenu/upcomingride/model/ScheduleTripModel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../utils/utility.dart';
import '../web_service/Constant.dart';
import 'model/scheduleTrip.dart';

class firestoreScheduleTripNotifier extends ChangeNotifier {
  dynamic scheduleFailureSream = [];
  ScheduleTrip? scheduleTrip;
  Future<void> listenToLiveUpdateStream() async {
    String liveUpdatecollectionName =
        'user/${Profiledata().getusreid()}/scheduled-trips';
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(liveUpdatecollectionName);
    try {
      DateTime now = new DateTime.now();
      final notificationStream = await collectionRef.snapshots();
      notificationStream.listen((result) {
        print("object$result");
        for (var res in result.docChanges) {
          var data = res.doc.data();

          var encodedJson = json.encode(data, toEncodable: myEncode);
          var jsonData = json.decode(encodedJson);
          DateTime date = DateTime.parse(res.doc['scheduledAt'].toDate().toString());

          String dt1 = DateFormat.yMd().format(date);
          String dt2 = DateFormat.yMd().format(DateTime.now());
          DateTime? scheduleDate = DateFormat.yMd().parse(dt1);
          DateTime? currentDate = DateFormat.yMd().parse(dt2);

          if(jsonData!=null && jsonData.toString().isNotEmpty) {
            if(scheduleDate.isAtSameMomentAs(currentDate)|| scheduleDate.isAfter(currentDate)) {

              scheduleTrip = ScheduleTrip.fromJson(jsonData);
              print("scheduleTripProvider===========${scheduleTrip!.status}");
              if(scheduleTrip!.status == ScheduleTripCancelledByOps ||scheduleTrip!.status == ScheduleTripRejectStatus ){
                collectionRef.doc(res.doc.id).delete().then(
                      (doc) => print("Document deleted"),
                  onError: (e) => print("Error updating document $e"),
                );
              }

            }else{
              scheduleTrip = null;
              collectionRef.doc(res.doc.id).delete().then(
                    (doc) => print("Document deleted"),
                onError: (e) => print("Error updating document $e"),
              );

            }
          } else {
            scheduleTrip = null;
          }
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint("ERROR - $e");
      return null;
    }
  }
}
